import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptins {
  All,
  OnlyFavourites,
}

class ProductsOverVeiwCsreen extends StatefulWidget {
  @override
  _ProductsOverVeiwCsreenState createState() => _ProductsOverVeiwCsreenState();
}

class _ProductsOverVeiwCsreenState extends State<ProductsOverVeiwCsreen> {
  var _isFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptins val) {
                setState(() {
                  if (val == FilterOptins.OnlyFavourites) {
                    _isFavorites = true;
                  } else {
                    _isFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptins.All),
                    PopupMenuItem(
                        child: Text('Show Favs'),
                        value: FilterOptins.OnlyFavourites)
                  ]),
          Consumer<Cart>(
            builder: (_,cart,ch) => Badge(
              child: ch,
              value: cart.size.toString(),
            ),
            child:IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      drawer: AppDrawer(),
      body: ProductGrid(_isFavorites),
    );
  }
}
