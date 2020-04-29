import 'package:flutter/Material.dart';
import 'package:shoppingapp/models/http_exception.dart';
import 'dart:convert';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 350.0,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 559.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 119.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 449.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get item {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((test) => id == test.id);
  }

  List<Product> get favItems {
    return _items.where((test) => test.isFavourite == true).toList();
  }

  Future<void> getAndSetProducts() async{
    const url='https://practiseproject-2b643.firebaseio.com/product.json';
    
    try{
      final response =await http.get(url) ;

      var _dataReceived=json.decode(response.body) as Map<String,dynamic>;

      final List<Product> _recievedList=[];
      _dataReceived.forEach((pid,product){
          _recievedList.add(
            Product(
            id:pid,
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavourite: product['isFavourite'],
          ));
      });
      _items=_recievedList;
      notifyListeners();
    }catch(error){
      throw error;
    }

  }

  Future<void> addProduct(Product value) async {
    
    const url='https://practiseproject-2b643.firebaseio.com/product.json';
    try{
   final response=await http.post(url,body: json.encode({
        'title':value.title,
        'description':value.description,
        'price':value.price,
        'imageUrl':value.imageUrl,
        'isFavourite':value.isFavourite,
    }));
      
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

    final url='https://practiseproject-2b643.firebaseio.com/product/$id.json';
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

    final url='https://practiseproject-2b643.firebaseio.com/product/$id.json';
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
