import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItems(String prodId, String prodTitle, double prodPrice) {
    if (_items.containsKey(prodId)) {
      _items.update(
        prodId,
        (existingCartItems) => CartItem(
          id: existingCartItems.id,
          title: existingCartItems.title,
          price: existingCartItems.price,
          quantity: existingCartItems.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: prodTitle,
                price: prodPrice,
                quantity: 1,
              ));
      // _items[prodId] = CartItem(
      //   id: DateTime.now().toString(),
      //   title: prodTitle,
      //   price: prodPrice,
      //   quantity: 1,
      // );
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeOne(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          price: existingItem.price,
          quantity: existingItem.quantity,
          title: existingItem.title,
        ),
        // {() {return;}},
      );
    } else
      removeItem(id);

    notifyListeners();
  }

  notifyListeners();
}
