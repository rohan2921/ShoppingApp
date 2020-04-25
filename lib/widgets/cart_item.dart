import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/cart.dart';
class CartItem extends StatelessWidget {
  final str = String.fromCharCode(8377);
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
           color: Theme.of(context).errorColor,
           child: Icon(
             Icons.delete,
             size:40,
             color: Colors.white,
             ),
             alignment: Alignment.centerRight,
      
           ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
              Provider.of<Cart>(context,listen: false).deleteItem(productId,id);
          },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                  padding: EdgeInsets.all(3),
                  child: FittedBox(child: Text('$str $price'))),
            ),
            title: Text(title),
            subtitle: Text((price * quantity).toString()),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
