import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: _product.id);
          },
          child: Image.network(
            _product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, _product, _) => IconButton(
              icon: Icon(_product.isFavourite == true
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                _product.addFavourite();
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(_product.title),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              _cart.addItem(_product.id, _product.title, _product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Item added to Cart',),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO', onPressed: (){
                  _cart.removeSingleItem(_product.id);
                }),
              ));
            },
          ),
        ),
      ),
    );
  }
}
