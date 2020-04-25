import 'package:flutter/material.dart';
import 'package:shoppingapp/screens/OrdersScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text('Welcome Mr./Mrs.'),automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop), 
              title: Text('Shop'),
              onTap: ()=>Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
              leading: Icon(Icons.payment), 
              title: Text('Orders'),
              onTap: ()=>Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          )
          
        ],
      ),
      
    );
  }
}