import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/pages/user_products_page.dart';
import '../pages/edit_products_page.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffoldVar = Scaffold.of(context);
    return
        // Card(
        //   margin: EdgeInsets.all(5),
        //   elevation: 5,
        //   shadowColor: Colors.grey,
        // child:
        ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductsPage.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // Navigator.of(context).pushNamed(EditProductsPage.routeName);
                try {
                  await Provider.of<Products>(
                    context,
                    listen: false,
                  ).removeProduct(id);
                } catch (error) {
                  scaffoldVar.showSnackBar(
                    SnackBar(
                      content: Text(
                        'unable to delete product',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
