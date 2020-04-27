import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/widgets/app_drawer.dart';
import 'package:shoppingapp/widgets/user_product_item.dart';
import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
   static const routeName='/user-product-screen';
  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    return Scaffold(appBar: AppBar(
      title: const Text('Your Products'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add),
       onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
       })
      ],
    ),
    drawer: AppDrawer(),
    body: ListView.builder(itemBuilder: (ctx,ind){
          return UserProductItem(productsData.item[ind].id,productsData.item[ind].title,productsData.item[ind].imageUrl);
    },itemCount: productsData.item.length,),
    );
  }
}