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
      Provider.of<Products>(context).fetchAndAddProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }

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
            itemBuilder: (_) => [
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
            onSelected: (int selectedValue) {
              setState(() {
                if (selectedValue == 0) {
                  _onlyFavourites = true;
                  // print('marked afvourite');
                } else {
                  _onlyFavourites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              cchild: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
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
