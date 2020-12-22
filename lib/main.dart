// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import './pages/products_overview_page.dart';
import 'pages/product_detail_page.dart';
import './providers/products_provider.dart';
// import './providers/products_class.dart';
import 'pages/cart_page.dart';
import './providers/orders.dart';
import 'pages/orders_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_products_page.dart';
import './pages/auth_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'My shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewPage(),
        routes: {
          // '/': (context) => MyApp(),
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrdersPage.routeName: (ctx) => CartPage(),
          UserProductsPage.routeName: (ctx) => UserProductsPage(),
          EditProductsPage.routeName: (ctx) => EditProductsPage(),
        },
      ),
    );
  }
}
