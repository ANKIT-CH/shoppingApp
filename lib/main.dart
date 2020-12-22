// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/products_overview_page.dart';
import 'package:shop_app/providers/cart.dart';

// import './pages/products_overview_page.dart';
import 'pages/product_detail_page.dart';
import './providers/products_provider.dart';
// import './providers/products_class.dart';
import 'pages/cart_page.dart';
import './providers/orders.dart';
import 'pages/orders_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_products_page.dart';
import './pages/auth_page.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) {},
          update: (ctx, authData, previousProducts) => Products(
            authData.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) {},
          update: (ctx, authData, previousOrders) => Orders(
            authData.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'My shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth ? ProductsOverviewPage() : AuthPage(),
          routes: {
            // '/': (context) => MyApp(),

            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartPage.routeName: (ctx) => CartPage(),
            OrdersPage.routeName: (ctx) => CartPage(),
            UserProductsPage.routeName: (ctx) => UserProductsPage(),
            EditProductsPage.routeName: (ctx) => EditProductsPage(),
          },
        ),
      ),
    );
  }
}
