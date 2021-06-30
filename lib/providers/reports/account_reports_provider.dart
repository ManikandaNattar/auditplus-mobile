import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class AccountReportsProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/report';
  AccountReportsProvider(this._auth);

  Future<Map<String, dynamic>> getAccountBook(
    String fromDate,
    String toDate,
    String accountId,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/account-book',
      query: {
        'account': accountId,
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
    return utils.handleResponse(response.statusCode, response.body);
  }

  Future<Uint8List> getAccountBookPrintData(
    String fromDate,
    String toDate,
    String accountId,
    List branch,
    String selectedBranch,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/account-book/print',
      query: {
        'account_id': accountId,
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

  Future<Map<String, dynamic>> getAccountOutstandingReport(
    List accountTypes,
    List groupBy,
    int pageNo,
    String orderBy,
    Map<String, List> filterArguments,
  ) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/account-outstanding',
      query: {
        'filter': filterArguments == null ? null : json.encode(filterArguments),
        'group': groupBy == null ? null : json.encode(groupBy),
        'accountType': accountTypes == null ? null : json.encode(accountTypes),
        'page': pageNo.toString(),
        'sort': orderBy,
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

  Future<Map<String, dynamic>> generateAccountOutstandingReport(
    Map<String, dynamic> generateData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/account-outstanding/generate',
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
