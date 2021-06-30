import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class PurchaseReportsProvider with ChangeNotifier {
  final _auth;
  PurchaseReportsProvider(this._auth);

  Future<Map<String, dynamic>> getPurchaseRegister(
    String fromDate,
    String toDate,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/purchase-register',
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
