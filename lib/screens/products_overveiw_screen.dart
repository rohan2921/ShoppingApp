import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';


class ProductsOverVeiwCsreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).accentColor ,
      body: ProductGrid(),
    );
  }
}

