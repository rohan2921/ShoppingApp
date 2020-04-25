
import 'package:flutter/foundation.dart';
import 'package:shoppingapp/providers/cart.dart';

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

  List<OrderItem> get getOrders{
    return [..._orders];
  }
  void addOrders(List<CartItem> items,double total){
    _orders.insert(0, OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      dateTime: DateTime.now(),
      items: items)
    );
    notifyListeners();
  }
}