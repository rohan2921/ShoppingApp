import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' ;
import '../widgets/order_item.dart' as od;
class OrdersScreen extends StatelessWidget {
  static const routeName='/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title:Text('Your Orders')),
      drawer: AppDrawer(),
      body: ListView.builder(itemCount: orderData.getOrders.length,
      itemBuilder: (ctx,ind){
        return od.OrderItem(orderData.getOrders[ind]);
      }
      
      ),
      
    );
  }
}