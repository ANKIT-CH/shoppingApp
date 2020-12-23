import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'products_class.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final token;
  final String userId;
  Products(this.token, this.userId, this._items);

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite == true).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndAddProducts([bool isFilter = false]) async {
    final filterText = isFilter ? 'orderBy="userId"&equalTo="$userId"' : "";
    var url =
        'https://flutter-app-53158-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extractedData == null) return;
      url =
          'https://flutter-app-53158-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$token&$filterText';
      final favResponse = await http.get(url);

      extractedData.forEach((prodId, product) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavourite: json.decode(favResponse.body) == null
                ? false
                : json.decode(favResponse.body)[prodId]
                    ? false
                    : json.decode(favResponse.body)[prodId],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-app-53158-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': userId,
            // 'isFavourite': product.isFavourite,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> editProduct(String id, Product newProduct) async {
    var productId = _items.indexWhere((element) => element.id == id);

    if (productId >= 0) {
      final url =
          'https://flutter-app-53158-default-rtdb.firebaseio.com/products/$id.json?auth=$token';

      await http.patch(url,
          body: json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              // 'isFavourite': product.isFavourite,
            },
          ));
      _items[productId] = newProduct;
      notifyListeners();
    } else
      print('..................');
  }

  Future<void> removeProduct(String id) async {
    var existingProductId = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductId];

    final url =
        'https://flutter-app-53158-default-rtdb.firebaseio.com/products/$id.json?auth=$token';

    _items.removeAt(existingProductId);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.add(existingProduct);
      notifyListeners();
      throw HttpException('unable to delete this item');
    }

    existingProductId = null;
  }
}
