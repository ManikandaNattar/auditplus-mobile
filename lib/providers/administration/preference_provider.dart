import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class PreferenceProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/administration/preference';
  PreferenceProvider(this._auth);

  Future<Map<String, dynamic>> getInventoryPreference(
    String branchId,
  ) async {
    String url = utils.encodeUrl(
        organization: _auth.organizationName,
        path: '$_baseUrl/inventory',
        query: {
          'branch': branchId,
        });
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    final responseData = json.decode(response.body);
    if (response.statusCode != 200) {
      final message = responseData['message'];
      throw HttpException(message is List ? message.join(',') : message);
    }
    return responseData;
  }
}
