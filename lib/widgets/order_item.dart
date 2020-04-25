
import 'dart:math';
import 'package:flutter/Material.dart';
import '../providers/orders.dart' as od;
import 'package:intl/intl.dart';
class OrderItem extends StatefulWidget {
  final od.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final str=String.fromCharCode(8377);
  var _expanded=false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('$str ${widget.order.amount}'),
          subtitle: Text(DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(icon: _expanded? Icon(Icons.expand_less):Icon(Icons.expand_more),onPressed: (){
            setState(() {
              _expanded=!_expanded;
            });
          },),
          ),
          if(_expanded) Container(
            padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
            height: min(widget.order.items.length*20.0+40,180),
            child: ListView.builder(itemBuilder: (ctx,ind){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                      Text(widget.order.items[ind].title,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                      ,
                      Text('${widget.order.items[ind].quantity} x $str ${widget.order.items[ind].amount}',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
              ],);
            },itemCount: widget.order.items.length,),
            
            )
      ],),
      
    );
  }
}