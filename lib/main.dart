import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/products_overveiw_screen.dart';
import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './providers/orders.dart';
import './screens/OrdersScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 static final  Map<int, Color> color =
{
50:Color.fromRGBO(225,225,204, .1),
100:Color.fromRGBO(225,225,153, .2),
200:Color.fromRGBO(255,255,102, .3),
300:Color.fromRGBO(255,255,51, .4),
400:Color.fromRGBO(255,255,0, .5),
500:Color.fromRGBO(255,255,0, .6),
600:Color.fromRGBO(204,204,0, .7),
700:Color.fromRGBO(153,153,0, .8),
800:Color.fromRGBO(102,102,0, .9),
900:Color.fromRGBO(51,51,0, 1),

};
final MaterialColor swatch=MaterialColor(0xFFFFFFE0,color);
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (ctx)=> Products()),
        ChangeNotifierProvider(
          create: (ctx)=>Cart()),
        ChangeNotifierProvider(create: (ctx)=>
        Orders()
        )
        ],
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          accentColor: Colors.yellow[100],
          primarySwatch: swatch,
          primaryColor: Color.fromRGBO(255,255,153,1),
          fontFamily: 'Lato',
          errorColor: Colors.red,
        ),
        home: ProductsOverVeiwCsreen(),
        routes: {
          ProductDetailScreen.routeName:(ctx)=> ProductDetailScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          OrdersScreen.routeName:(ctx)=>OrdersScreen(),
        },
      ),
    );
  }
}
