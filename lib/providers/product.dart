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
  Future<void> addFavourite(String requestTo,String userId) async{
    final oldStatus=isFavourite;
    isFavourite= (!isFavourite);
    notifyListeners();
    try{
    final url='https://practiseproject-2b643.firebaseio.com/isFavourite/$userId/$id.json?auth=$requestTo';
    final res=await http.put(url,body: json.encode(
      isFavourite
    ));
    
    if(res.statusCode >=400){
      isFavourite=oldStatus;
      notifyListeners();
    }
    }catch(error){
      isFavourite=oldStatus;
      notifyListeners();
    }
  }
}