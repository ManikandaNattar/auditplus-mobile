import 'dart:convert';
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
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/inventory-book',
      query: {
        'inventory': inventoryId,
        'branch': json.encode(branch),
        'fromDate': fromDate,
        'toDate': toDate,
        'page': pageNo.toString(),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<Map<String, dynamic>> getStockAnalysisReport(
    int pageNo,
    String groupBy,
    Map<String, List> filterArguments,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/stock-analysis',
      query: {
        'group': groupBy,
        'filter': filterArguments == null ? null : json.encode(filterArguments),
        'page': pageNo.toString(),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<void> generateStockAnalysisReport(
    Map<String, dynamic> generateData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/stock-analysis/generate',
    );
    final response = await http.post(
      url,
      body: json.encode(generateData),
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
