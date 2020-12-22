import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../pages/edit_products_page.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user_product_item';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndAddProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('your products'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsPage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, index) => Column(children: <Widget>[
                UserProductItem(
                  productsData.items[index].id,
                  productsData.items[index].title,
                  productsData.items[index].imageUrl,
                ),
                Divider(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
