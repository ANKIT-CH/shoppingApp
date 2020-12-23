import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import './products_class.dart';
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

  final String token;
  final String userId;
  Orders(this.token, this.userId, this._orders);

  Future<void> fetchAndAddOrders() async {
    try {
      final url =
          'https://flutter-app-53158-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];

      if (extractedData == null) return;

      extractedData.forEach(
        (orderId, order) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: order['amount'],
              dateTime: DateTime.parse(order['dateTime']),
              products: (order['products'] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ))
                  .toList(),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrders(double amount, List<CartItem> products) async {
    final url =
        'https://flutter-app-53158-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode(
          {
            'amount': amount,
            'dateTime': timeStamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList()
          },
        ));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          products: products,
          dateTime: timeStamp,
        ));

    notifyListeners();
  }
}
