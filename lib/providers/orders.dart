import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  String id;
  double amount;
  List<CartItem> products;
  DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrders(double amount, List<CartItem> products) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: amount,
          products: products,
          dateTime: DateTime.now(),
        ));

    notifyListeners();
  }
}
