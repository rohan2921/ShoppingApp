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

  final String _token;
  final String _userId;
  Cart(this._token,this._userId,this._item);

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

  Future<void> getAndSetCartItems() async {
    final url = 'https://practiseproject-2b643.firebaseio.com/cart/$_userId.json?auth=$_token';

    try {
      final response = await http.get(url);

      var _dataReceived = json.decode(response.body) as Map<String, dynamic>;
      if (_dataReceived == null) return;
      final Map<String, CartItem> _recievedList = {};
      _dataReceived.forEach((pid, product) {
        _recievedList.putIfAbsent(
            product['id'],
            () => CartItem(
                id: pid,
                amount: product['amount'],
                title: product['title'],
                quantity: product['quantity']));
      });
      _item = _recievedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addItem(String id, String title, double amount) async {
    if (_item.containsKey(id)) {
      final url =
          'https://practiseproject-2b643.firebaseio.com/cart/$_userId/${_item[id].id}.json?auth=$_token';
      await http.patch(url,
          body: json.encode({'quantity': _item[id].quantity + 1}));
      _item.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity + 1,
              amount: existing.amount));
    } else {
      final url = 'https://practiseproject-2b643.firebaseio.com/cart/$_userId.json?auth=$_token';
      await http
          .post(url,
              body: json.encode(
                  {'id': id, 'title': title, 'amount': amount, 'quantity': 1}))
          .then((onValue) {
        _item.putIfAbsent(
            id,
            () => CartItem(
                id: json.decode(onValue.body)['name'],
                title: title,
                quantity: 1,
                amount: amount));
        notifyListeners();
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  Future removeSingleItem(String id) async {
    if (!_item.containsKey(id)) return null;

    if (_item[id].quantity > 1) {
      final url =
          'https://practiseproject-2b643.firebaseio.com/cart/$_userId/${_item[id].id}.json?auth=$_token';
      try {
        final response = await http.patch(url,
            body: json.encode({
              'quantity': _item[id].quantity - 1,
            }));
        if (response.statusCode >= 400) throw response;
        _item.update(
            id,
            (existing) => CartItem(
                id: _item[id].id,
                title: _item[id].title,
                quantity: _item[id].quantity - 1,
                amount: _item[id].amount));
        notifyListeners();
      } catch (err) {}
    } else {
      final url =
          'https://practiseproject-2b643.firebaseio.com/cart/$_userId/${_item[id].id}.json?auth=$_token';
      try {
        final response = await http.delete(url);
        if (response.statusCode >= 400) throw response;
        _item.remove(id);
        if (response.statusCode >= 400) throw response;
        notifyListeners();
      } catch (err) {}
    }
  }

  Future deleteItem(String pid, String id) async {
    if (_item[pid].quantity == 1) {
      final url =
          'https://practiseproject-2b643.firebaseio.com/cart/$_userId/${_item[pid].id}.json?auth=$_token';
      try {
        final response = await http.delete(url);
        if (response.statusCode >= 400) throw response;
        _item.remove(pid);
        notifyListeners();
      } catch (err) {
        //...
      }
    } else {
      final url =
          'https://practiseproject-2b643.firebaseio.com/cart/$_userId/${_item[pid].id}.json?auth=$_token';
      try {
        final response = await http.patch(url,
            body: json.encode({
              'quantity': _item[id].quantity - 1,
            }));
        if (response.statusCode >= 400) throw response;
        _item[pid].quantity = _item[pid].quantity - 1;
        notifyListeners();
      } catch (err) {
        //...
      }
    }
  }

  Future clearOrders() async {
    final url = 'https://practiseproject-2b643.firebaseio.com/cart/$_userId/.json?auth=$_token';
    try {
      final response = await http.delete(url);
      _item = {};
      if (response.statusCode >= 400) throw response;
      notifyListeners();
    } catch (err) {}
  }
}
