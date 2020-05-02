import 'package:flutter/material.dart';
import '../screens/OrdersScreen.dart';
import '../screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
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
          ),
           Divider(),
          ListTile(
              leading: Icon(Icons.edit), 
              title: Text('Manage Products'),
              onTap: ()=>Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app), 
              title: Text('Logout'),
              onTap: (){
                Navigator.of(context).pop();
                Provider.of<Auth>(context,listen: false).logout();
                Navigator.of(context).popAndPushNamed('/');
                }
          ),
          
        ],
      ),
      
    );
  }
}