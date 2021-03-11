import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class InventoryReportsProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/report';
  InventoryReportsProvider(this._auth);

  Future<Map<String, dynamic>> getInventoryBook(
    String fromDate,
    String toDate,
    String inventoryId,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/inventory-book',
      query: {
        'inventory_id': inventoryId,
        'branch_id': json.encode(branch),
        'from_date': fromDate,
        'to_date': toDate,
        'page': pageNo.toString(),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message']);
    }
    return responseData;
  }

  Future<Uint8List> getInventoryBookPrintData(
    String fromDate,
    String toDate,
    String inventoryId,
    List branch,
    String selectedBranch,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/inventory-book/print',
      query: {
        'inventory_id': inventoryId,
        'branch_id': json.encode(branch),
        'from_date': fromDate,
        'to_date': toDate,
        'branch': selectedBranch,
      },
    );
    final headers = {
      'X-Auth-Token': _auth.token as String,
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    } else {
      final responseData = response.bodyBytes;
      return responseData;
    }
  }
}
