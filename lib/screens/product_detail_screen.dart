import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
class ProductDetailScreen extends StatelessWidget {

  static const routeName='/product-detail-screen';
  @override
  Widget build(BuildContext context) {
    final String id=ModalRoute.of(context).settings.arguments as String;
    final _item=Provider.of<Products>(context,listen: false).findById(id);
    
    return Scaffold(
      appBar: AppBar(title:Text(_item.title)),
      body: Container(),
      
    );
  }
}