import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class UserProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/administration/user';
  UserProvider(this._auth);

  Future<List> userAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<List> accountantAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/external-accountant-autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getUserList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/list',
      query: {
        'search': searchQuery.isEmpty ? null : json.encode(searchQuery),
        'page': pageNo.toString(),
        'per_page': perPage.toString(),
        'sort_column': sortColumn.isEmpty ? null : sortColumn,
        'sort_order': sortOrder.isEmpty ? null : sortOrder,
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

  Future<Map<String, dynamic>> getUser(String userId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$userId',
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

  Future<void> deactivateUser(String userId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/deactivate',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Auth-Token': _auth.token as String
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'userId': userId}),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message']);
    }
  }

  Future<Map<String, dynamic>> createUser(
    Map<String, dynamic> userData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(userData),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    final responseData = json.decode(response.body);
    if (response.statusCode != 201) {
      final message = responseData['message'];
      throw HttpException(message is List ? message.join(',') : message);
    }
    return responseData;
  }

  Future<void> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$userId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(userData),
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

  Future<void> assignBranches(
    String userId,
    List<String> branchesList,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$userId/assign-branch',
    );
    final response = await http.put(
      url,
      body: json.encode({'branches': branchesList}),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    if (response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        final message = responseData['message'];
        throw HttpException(message is List ? message.join(',') : message);
      }
    }
  }

  Future<List> getUserAssignedBranches(String userId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$userId/branches',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body);
  }

  Future<Map> resetPassword(String id) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/reset-password',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Auth-Token': _auth.token as String
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'userId': id}),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    }
    return responseData;
  }

  Future<List> getAccountantList() async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/external-accountant-list',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<Map<String, dynamic>> addAccountant(
    Map<String, dynamic> accountantData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/add-external-accountant',
    );
    final response = await http.post(
      url,
      body: json.encode(accountantData),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    final responseData = json.decode(response.body);
    if (response.statusCode != 201) {
      final message = responseData['message'];
      throw HttpException(message is List ? message.join(',') : message);
    }
    return responseData;
  }

  Future<Map> removeAccountant(int accountantCode) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/remove-external-accountant',
    );
    final headers = {
      'Content-Type': 'application/json',
      'X-Auth-Token': _auth.token as String
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'actCode': accountantCode}),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    }
    return responseData;
  }
}
