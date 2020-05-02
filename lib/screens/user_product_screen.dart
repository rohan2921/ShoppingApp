import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/widgets/app_drawer.dart';
import 'package:shoppingapp/widgets/user_product_item.dart';
import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
   static const routeName='/user-product-screen';

   Future<void> _refresh(BuildContext context) async{
      await Provider.of<Products>(context,listen: false).getAndSetProducts(true);
   }
  @override
  Widget build(BuildContext context) {
   // final productsData=Provider.of<Products>(context);
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
    body: FutureBuilder(
          future: _refresh(context),
          builder:(ctx,snapshot)=> snapshot.connectionState==ConnectionState.waiting? Center(child:CircularProgressIndicator())
          :RefreshIndicator(
          onRefresh: ()=>_refresh(context),
            child: Consumer<Products>(

                          builder:(ctx,productsData,_)=> ListView.builder(itemBuilder: (ctx,ind){
                return UserProductItem(productsData.item[ind].id,productsData.item[ind].title,productsData.item[ind].imageUrl);
        },itemCount: productsData.item.length,),
            ),
      ),
    ),
    );
  }
}