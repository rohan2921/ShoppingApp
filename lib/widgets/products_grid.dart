import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final _products = productsData.item;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _products.length,
      itemBuilder: (ctx, ind) => ChangeNotifierProvider.value(
        value: _products[ind],
          child: ProductItem(),),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
