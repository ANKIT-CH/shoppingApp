import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_product.dart';
import '../widgets/drawer.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('order now'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrders(
                        cartData.totalAmount,
                        cartData.items.values.toList(),
                      );
                      cartData.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.items.length,
              itemBuilder: (ctx, index) => CartProduct(
                cartData.items.values.toList()[index].id,
                cartData.items.keys.toList()[index],
                cartData.items.values.toList()[index].title,
                cartData.items.values.toList()[index].price,
                cartData.items.values.toList()[index].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
