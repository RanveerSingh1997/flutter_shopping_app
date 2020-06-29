import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/order.dart';
import 'package:shopping_app/chat/auth.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/product_overview_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';
import 'package:shopping_app/screens/user_product_screen.dart';

import './providers/products.dart';

void main() {
  Provider.debugCheckInvalidValueType=null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProductData) => Products(
              auth.token,
              previousProductData == null ? [] : previousProductData.items,
              auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch:Colors.indigo,
            backgroundColor:Colors.indigo,
            primaryColor: Colors.orange,
            accentColor: Colors.deepPurple,
            accentColorBrightness:Brightness.dark,
            buttonTheme:ButtonTheme.of(context).copyWith(
              buttonColor:Colors.amber,
              textTheme:ButtonTextTheme.primary,
              shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20.0)
              )
            )
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductOverviewScreen.routName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
            CartScreen.routName: (ctx) => CartScreen(),
            OrderScreen.routName: (ctx) => OrderScreen(),
            UserProductScreen.routName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
