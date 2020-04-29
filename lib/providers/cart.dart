import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CartItem {
  final String id;
  final String title;
  int quantity;
  final double amount;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.amount});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get size {
    return _item.length;
  }

  double get totalAmount {
    var tot = 0.0;
    _item.forEach((key, item) {
      tot += item.amount * item.quantity;
    });
    return tot;
  }
 
 Future<void> getAndSetCartItems() async{
    const url='https://practiseproject-2b643.firebaseio.com/cart.json';
    
    try{
      final response =await http.get(url) ;

      var _dataReceived=json.decode(response.body) as Map<String,dynamic>;

      final Map<String,CartItem> _recievedList={};
      _dataReceived.forEach((pid,product){
          _recievedList.putIfAbsent(product['id'],()=>
            CartItem(
            id:pid,
            amount: product['amount'],
            title: product['title'],
            quantity: product['quantity']
          ));
      });
      _item=_recievedList;
      notifyListeners();
    }catch(error){
      throw error;
    }

  }


  Future addItem(String id, String title,double amount) async{
   
    if (_item.containsKey(id)) {
      final url='https://practiseproject-2b643.firebaseio.com/cart/${_item[id].id}.json';
      await http.patch(url,body: json.encode({
        'quantity':_item[id].quantity+1
      }));
      _item.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity + 1,
              amount: existing.amount
            )
        );
    } else {
      final url='https://practiseproject-2b643.firebaseio.com/cart.json';
     await  http.post(url,body:json.encode({
       'id':id,
        'title':title,
        'amount':amount,
        'quantity':1        
      })).then((onValue){
        print(json.decode(onValue.body)['name']);
        _item.putIfAbsent(
          id,
          () => CartItem(
              id: json.decode(onValue.body)['name'],
              title: title,
              quantity: 1,
              amount: amount));
      }).catchError((onError){
        print(onError);
      });      
    }
  }

  void removeSingleItem(String id) {

    if(!_item.containsKey(id)) return;

    if (_item[id].quantity > 1) {
      final url='https://practiseproject-2b643.firebaseio.com/cart/${_item[id].id}.json';
      http.patch(url,body:json.encode({
          'quantity':_item[id].quantity-1,
      }));
      _item.update(
          id,
          (existing) => CartItem(
              id: _item[id].id,
              title: _item[id].title,
              quantity: _item[id].quantity - 1,
              amount: _item[id].amount));
    }else{
      final url='https://practiseproject-2b643.firebaseio.com/cart/${_item[id].id}.json';
      http.delete(url);
      _item.remove(id);

    }
    notifyListeners();
  }

  void deleteItem(String pid, String id) {
    if (_item[pid].quantity == 1) {
      final url='https://practiseproject-2b643.firebaseio.com/cart/${_item[id].id}.json';
      http.delete(url);
      _item.remove(pid);
    } else {
      final url='https://practiseproject-2b643.firebaseio.com/cart/${_item[id].id}.json';
      http.patch(url,body:json.encode({
          'quantity':_item[id].quantity-1,
      }));
      _item[pid].quantity = _item[pid].quantity - 1;
    }
    notifyListeners();
  }

  void clearOrders() {

    final url='https://practiseproject-2b643.firebaseio.com/cart/.json';
      http.delete(url);
    _item = {};
    
    notifyListeners();
  }
}
