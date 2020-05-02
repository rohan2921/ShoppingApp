import 'package:flutter/Material.dart';
import 'package:shoppingapp/models/http_exception.dart';
import 'dart:convert';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {

  String _authToken;
  
  List<Product> _items = [];
  String _userId;
  Products(this._authToken,this._userId,this._items);
  List<Product> get item {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((test) => id == test.id);
  }

  List<Product> get favItems {
    return _items.where((test) => test.isFavourite == true).toList();
  }

  Future<void> getAndSetProducts([bool filter=false]) async{
    final filterData= filter?  '&orderBy="creatorId"&equalTo="$_userId"':'';
    var url='https://practiseproject-2b643.firebaseio.com/product.json?auth=$_authToken$filterData';
    
    try{
      final response =await http.get(url) ;

      var _dataReceived=json.decode(response.body) as Map<String,dynamic>;
      if(_dataReceived==null) return;
      url='https://practiseproject-2b643.firebaseio.com/isFavourite/$_userId.json?auth$_authToken';
      final response1= await http.get(url);
      var _favData=json.decode(response1.body);
      final List<Product> _recievedList=[];
      _dataReceived.forEach((pid,product){
          _recievedList.add(
            Product(
            id:pid,
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavourite: _favData==null? false:_favData[pid] ?? false,
          ));
      });
      _items=_recievedList;
      notifyListeners();
    }catch(error){
      throw error;
    }

  }

  Future<void> addProduct(Product value) async {
    
    final url='https://practiseproject-2b643.firebaseio.com/product.json?auth=$_authToken';
    final url1='https://practiseproject-2b643.firebaseio.com/isFavourite/$_userId/.json?auth=$_authToken';
    try{
   final response=await http.post(url,body: json.encode({
        'title':value.title,
        'description':value.description,
        'price':value.price,
        'imageUrl':value.imageUrl,
        'creatorId':_userId
    }));
      await http.post(url1,body:json.encode({json.decode(response.body)['name']:false}));
      var p = Product(
        id: json.decode(response.body)['name'],
        price: value.price,
        description: value.description,
        imageUrl: value.imageUrl,
        title: value.title);
    _items.add(p);
    notifyListeners();
    }catch(error){
      throw error;
    }
    
 
  }

  Future<void> updateProduct(String id, Product p) async {

    final url='https://practiseproject-2b643.firebaseio.com/product/$id.json?auth=$_authToken';
    http.patch(url,body: json.encode({
        'title':p.title,
        'description':p.description,
        'price':p.price,
        'imageUrl':p.imageUrl,
        'isFavourite':p.isFavourite,
    }    
    ));
    var ind = _items.indexWhere((test) => test.id == id);
    if (ind >= 0) {
      _items[ind] = p;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {

    final url='https://practiseproject-2b643.firebaseio.com/product/$id.json?auth=$_authToken';
    final existingIndex=_items.indexWhere((pd) => pd.id == id);
    var existingProduct=_items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response= await http.delete(url);
      if(response.statusCode>=400){
        _items.insert(existingIndex,existingProduct);
        notifyListeners();
          throw HttpException('Could not delete');
      }
      existingProduct=null;
  }
}
