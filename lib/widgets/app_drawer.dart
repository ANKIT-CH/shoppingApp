import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/orders_page.dart';
import '../pages/user_products_page.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text(''),
        ),
        Divider(),
        ListTile(
          title: Text('shop'),
          leading: Icon(Icons.shop),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          title: Text('orders'),
          leading: Icon(Icons.payment),
          onTap: () {
            Navigator.of(context).pushNamed(OrdersPage.routeName);
          },
        ),
        Divider(),
        ListTile(
          title: Text('edit products'),
          leading: Icon(Icons.edit),
          onTap: () {
            Navigator.of(context).pushNamed(UserProductsPage.routeName);
          },
        ),
        Divider(),
        ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ]),
    );
  }
}
