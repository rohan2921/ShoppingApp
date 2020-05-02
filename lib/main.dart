import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overveiw_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';

import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './providers/orders.dart';
import './screens/OrdersScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final Map<int, Color> color = {
    50: Color.fromRGBO(225, 225, 204, .1),
    100: Color.fromRGBO(225, 225, 153, .2),
    200: Color.fromRGBO(255, 255, 102, .3),
    300: Color.fromRGBO(255, 255, 51, .4),
    400: Color.fromRGBO(255, 255, 0, .5),
    500: Color.fromRGBO(255, 255, 0, .6),
    600: Color.fromRGBO(204, 204, 0, .7),
    700: Color.fromRGBO(153, 153, 0, .8),
    800: Color.fromRGBO(102, 102, 0, .9),
    900: Color.fromRGBO(51, 51, 0, 1),
  };
  final MaterialColor swatch = MaterialColor(0xFFFFFFE0, color);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.item),
          create: (context) => Products(null, null, []),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
            update: (ctx, auth, previousCartItems) => Cart(auth.token,
                previousCartItems == null ? null : previousCartItems.item),
            create: (ctx) => Cart(null, {})),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? null : previousOrders.getOrders),
          create: (ctx) => Orders(null, null, []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            accentColor: Colors.yellow[100],
            primarySwatch: swatch,
            primaryColor: Color.fromRGBO(255, 255, 153, 1),
            fontFamily: 'Lato',
            errorColor: Colors.red,
          ),
          home: auth.isAuth
              ? ProductsOverVeiwCsreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
