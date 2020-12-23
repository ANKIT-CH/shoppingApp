import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavourite(String token, String userId) async {
    final oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-app-53158-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldFavourite;
        // notifyListeners();
      }
    } catch (error) {
      isFavourite = oldFavourite;
      notifyListeners();
    }
  }

  // Future<void> editProduct(String id, Product newProduct) async {
  //   var productId = _items.indexWhere((element) => element.id == id);

  //   if (productId >= 0) {
  //     await http.patch(url,
  //         body: json.encode(
  //           {
  //             'title': newProduct.title,
  //             'description': newProduct.description,
  //             'price': newProduct.price,
  //             'imageUrl': newProduct.imageUrl,
  //             // 'isFavourite': product.isFavourite,
  //           },
  //         ));
  //     _items[productId] = newProduct;
  //     notifyListeners();
  //   } else
  //     print('..................');
  // }
}
