import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;

  bool get isAuth {
    if (_token != null) return true;
    return false;
  }

  String get token {
    if (_token != null &&
        _expiryTime != null &&
        _expiryTime.isAfter(DateTime.now())) return _token;
    return null;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDZdhiZf5ppnpoDekKno25I18ezGR74adk';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDZdhiZf5ppnpoDekKno25I18ezGR74adk';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
