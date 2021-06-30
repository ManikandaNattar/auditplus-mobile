import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../../utils.dart' as utils;

class AccountProvider extends ChangeNotifier {
  static const _baseUrl = '/accounting/account';
  final _auth;
  AccountProvider(this._auth);

  Future<List> accountAutocomplete({
    @required String searchText,
    List<String> accountType,
  }) async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      organization: _auth.organizationName,
      path: '/autocomplete/account/',
      query: {
        'searchText': searchText,
        'args': accountType == null
            ? null
            : json.encode(
                {
                  'accountTypes': accountType,
                },
              ),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body)['records'];
  }

  Future<List> getAccountType() async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      organization: _auth.organizationName,
      path: '/fetch/account-types/',
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

  Future<Map<String, dynamic>> getAccountList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'account/',
      filterQuery: {
        'search': searchQuery.isEmpty ? null : json.encode(searchQuery),
        'page': pageNo.toString(),
        'perPage': perPage.toString(),
        'sortColumn': sortColumn.isEmpty ? null : sortColumn,
        'sortOrder': sortOrder.isEmpty ? null : sortOrder,
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

  Future<Map<String, dynamic>> getAccount(String accountId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$accountId',
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

  Future<void> deleteAccount(String accountId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$accountId/delete',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.delete(
      url,
      headers: headers,
    );
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<Map<String, dynamic>> createAccount(
    Map<String, dynamic> accountData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(accountData),
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

  Future<void> updateAccount(
    String accountId,
    Map<String, dynamic> accountData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$accountId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(accountData),
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

  Future<Map> getAccountOpening(
    String branchId,
    String accountId,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$accountId/opening/$branchId',
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

  Future<void> setAccountOpening(
    String branchId,
    String accountId,
    List transactions,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$accountId/opening/$branchId',
    );
    final response = await http.put(
      url,
      body: json.encode({'items': transactions}),
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
  }
}
