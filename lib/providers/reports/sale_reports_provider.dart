import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class SaleReportsProvider with ChangeNotifier {
  final _auth;
  SaleReportsProvider(this._auth);

  Future<Map<String, dynamic>> getSalesByIncharge(
    String fromDate,
    String toDate,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/sales-by-incharge',
      query: {
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

  Future<Map<String, dynamic>> getProductWiseSales(
    String fromDate,
    String toDate,
    String branch,
    int pageNo,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/product-wise-sales',
      query: {
        'branch': branch,
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

  Future<Map<String, dynamic>> getSaleRegister(
    String fromDate,
    String toDate,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/sale-register',
      query: {
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
}
