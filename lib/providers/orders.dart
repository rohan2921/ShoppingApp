
import 'package:flutter/foundation.dart';
import 'package:shoppingapp/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{
  String id;
  double amount;
  List<CartItem> items;
  DateTime dateTime;
  OrderItem({
      @required this.id,
      @required this.amount,
      @required this.items,
      @required this.dateTime
  });
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders=[];
  final String _token;
  final String _userId;
  Orders(this._token,this._userId,this._orders);

  List<OrderItem> get getOrders{
    return [..._orders];
  }
  Future<void> fetchAndAddOrders() async{
      final url='https://practiseproject-2b643.firebaseio.com/orders/$_userId.json?auth=$_token';
      final response=await http.get(url);
      final data=json.decode(response.body) as Map<String,dynamic>;
      List<OrderItem> dup=[];
      if(data==null) return;
      data.forEach((orderId,orderData){
          dup.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              items: (orderData['items'] as List).map((f){
                  return CartItem(id: f['id'], title: f['title'], quantity: f['quantity'], amount: f['amount']);
              }).toList(),
          
          ),);
      });
      _orders=dup.reversed.toList();
    //  print(_orders);
      notifyListeners();
  }

  Future<void> addOrders(List<CartItem> items,double total) async{
    final url='https://practiseproject-2b643.firebaseio.com/orders/$_userId.json?auth=$_token';
    final time=DateTime.now();
    final response=await http.post(url,body: json.encode({
      'amount':total,
      'dateTime':time.toIso8601String(),
      'items':items.map((f)=>{
        'id': f.id,
        'title':f.title,
        'amount':f.amount,
        'quantity':f.quantity

      }).toList(),

    }));
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: time,
      items: items)
    );
    notifyListeners();
  }
}