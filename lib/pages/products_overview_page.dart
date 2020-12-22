import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../widgets/Products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../pages/cart_page.dart';
import '../providers/products_provider.dart';

// enum FilterOptions {
//   Favourites,
//   All,
// }

class ProductsOverviewPage extends StatefulWidget {
  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _onlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero)
  //       .then((value) => Provider.of<Products>(context).fetchAndAddProducts());
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndAddProducts();
    }
    setState(() {
      _isLoading = false;
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only favourites'),
                // value: FilterOptions.Favourites,
                value: 0,
              ),
              PopupMenuItem(
                child: Text('All items'),
                // value: FilterOptions.All,
                value: 1,
              )
            ],
            onSelected: (int selected) {
              setState(() {
                if (selected == 0) {
                  _onlyFavourites = true;
                  // print('marked afvourite');
                } else {
                  _onlyFavourites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, child) => Badge(
              cchild: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
              ),
              value: cartData.itemCount.toString(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_onlyFavourites),
    );
  }
}
