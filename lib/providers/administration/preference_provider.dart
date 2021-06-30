import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class PreferenceProvider with ChangeNotifier {
  final _auth;
  PreferenceProvider(this._auth);

  Future<Map<String, dynamic>> getPreference(
    String branchId,
    List<String> menuName,
  ) async {
    String url = utils.encodeUrl(
        organization: _auth.organizationName,
        path: '/administration/preference',
        query: {
          'branch': branchId,
          'code': json.encode(menuName),
        });
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }
}
