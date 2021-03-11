import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils.dart' as utils;

class QSearchProvider with ChangeNotifier {
  final _auth;
  QSearchProvider(this._auth);
  static const _baseUrl = '/qsearch/api/fetch';

  Future<Map<String, dynamic>> getInventoryInfo(
    String inventoryId,
    String branchId,
    String inventoryHead,
  ) async {
    final url = utils.encodeApiUrl(
      path: '$_baseUrl/inventory-info',
      organization: _auth.organizationName,
      query: {
        'inventory': inventoryId,
        'branch': branchId,
        'inventory_head': inventoryHead,
      },
    );
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
