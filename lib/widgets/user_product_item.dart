import 'package:flutter/material.dart';
import 'package:shoppingapp/screens/edit_product_screen.dart';


class UserProductItem extends StatelessWidget {

 

  final String title;
  final String imgUrl;
  final String id;

  UserProductItem(this.id,this.title,this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
          child: ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),    
        trailing: Container(
          width: 200,
          child: Row(
            children: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
              }, child: Icon(Icons.edit)),
              FlatButton(onPressed: (){}, child: Icon(Icons.delete)),
            ],
          ),
        ),
        
      ),
    );
  }
}