import 'package:flutter/cupertino.dart';

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
  Map<String, CartItem> _item={};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get size{
    return _item.length;
  }
  double get totalAmount{
    var tot=0.0;
    _item.forEach((key,item){
        tot+=item.amount*item.quantity;
    });
    return tot;
  }

  void addItem(String id, String title, double amount) {
    if (_item.containsKey(id)) {
      _item.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity + 1,
              amount: existing.amount));
    } else {
      _item.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              amount: amount));
    }
  }
  void deleteItem(String pid,String id){

    if(_item[pid].quantity==1){
        _item.remove(pid);
    }else{
        _item[pid].quantity=_item[pid].quantity-1;
    }
    notifyListeners();

  }
  void clearOrders(){
    _item={};
    notifyListeners();
  }
}
