import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    if (_token != null)
      return true;
    else
      return false;
  }

  String get token {
    if (_token != null &&
        _expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()))
      return _token;
    else
      return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    final url =
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
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final data = json.encode(
        {
          'token': _token,
          'expiryTime': _expiryTime.toIso8601String(),
          'userId': _userId,
        },
      );
      pref.setString('data', data);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLoginAttemp() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('data')) return false;

    final extractedData =
        json.decode(pref.getString('data')) as Map<String, dynamic>;

    final expiryTime = DateTime.parse(extractedData['expiryTime']);
    if (expiryTime.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _expiryTime = extractedData['expiryTime'];
    _userId = extractedData['usedId'];

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logIn(String email, String password) async {
    final url =
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
      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            json.decode(response.body)['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiryTime = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    // pref.remove('data');
    pref.clear();
    // notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
        Duration(seconds: _expiryTime.difference(DateTime.now()).inSeconds),
        logout);
  }
}
