import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/orders.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final str = String.fromCharCode(8377);
  
  
 

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    
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
                      OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return _isLoading? CircularProgressIndicator():  FlatButton(
      onPressed: (widget.cart.totalAmount<=0 ||  _isLoading ) ? null : () {
        setState(() {
          _isLoading=true;
        });
        Provider.of<Orders>(context,listen: false).addOrders(widget.cart.item.values.toList(), widget.cart.totalAmount);
        widget.cart.clearOrders();
        setState(() {
          _isLoading=false;
        });
      },
      child: Text('Place Order'),
      color: Theme.of(context).primaryColor,
    );
  }
}
