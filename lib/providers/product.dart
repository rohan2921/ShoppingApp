import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite=false,
  });
  Future<void> addFavourite() async{
    isFavourite=!isFavourite;
    final url='https://practiseproject-2b643.firebaseio.com/product/$id.json';
    http.patch(url,body: json.encode({
      'isFavourite':isFavourite
    }));
    notifyListeners();
  }
}