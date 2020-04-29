import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/orders.dart';
import '../screens/OrdersScreen.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  final str = String.fromCharCode(8377);
  var _isInit=true;
  
 
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    if(_isInit){
      cart.getAndSetCartItems();
      _isInit=false;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Cart Items')),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total'),
                      Spacer(),
                      Chip(
                        label: Text('$str ${cart.totalAmount}'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 5),
                      FlatButton(
                        onPressed: () {
                          Provider.of<Orders>(context,listen: false).addOrders(cart.item.values.toList(), cart.totalAmount);
                          cart.clearOrders();
                          Navigator.of(context).pushNamed(OrdersScreen.routeName);
                        },
                        child: Text('Place Order'),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ))),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, ind) {
             return ci.CartItem(
                  id: cart.item.values.toList()[ind].id,
                  productId: cart.item.keys.toList()[ind],
                  title: cart.item.values.toList()[ind].title,
                  price: cart.item.values.toList()[ind].amount,
                  quantity: cart.item.values.toList()[ind].quantity);
            },
            itemCount: cart.item.length,
          )),
        ],
      ),
    );
  }
}
