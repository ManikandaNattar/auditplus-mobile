import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class CloudAuth extends ChangeNotifier {
  String _email;
  String _token;

  setAuth(String token, String email) {
    _token = token;
    _email = email;
  }

  String get email {
    return _email;
  }

  String get token {
    return _token;
  }

  bool get isAuthenticated {
    return (_token != null);
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    String url = utils.cloudEncodeUrl(
      path: '/auth/login/',
    );
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    final prefs = await SharedPreferences.getInstance();
    final authInfo = json.encode({
      'token': responseData['token'],
      'email': email,
      'isCloudLogin': true,
    });
    prefs.setString('cloud_auth_info', authInfo);
    _token = responseData['token'];
    _email = email;

    if (responseData['error'] != null) {
      throw HttpException(responseData['message']);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cloud_auth_info');
    _token = null;
    _email = null;
  }
}
