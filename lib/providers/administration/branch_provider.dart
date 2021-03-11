import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class BranchProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/administration/branch';
  BranchProvider(this._auth);

  Future<List> branchAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getBranchList(
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

  Future<Map<String, dynamic>> getBranch(String branchId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$branchId',
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

  Future<Map<String, dynamic>> createBranch(
    Map<String, dynamic> branchData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(branchData),
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

  Future<void> updateBranch(
    String branchId,
    Map<String, dynamic> branchData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$branchId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(branchData),
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

  Future<void> assignUsers(
    String branchId,
    List<String> usersList,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$branchId/assign-user',
    );
    final response = await http.put(
      url,
      body: json.encode({'users': usersList}),
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

  Future<void> assignDesktopClients(
    String branchId,
    List<String> clientsList,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$branchId/assign-client',
    );
    final response = await http.put(
      url,
      body: json.encode({'clients': clientsList}),
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

  Future<List> getInventoryHead() async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/inventory-head',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body);
  }

  Future<void> createInventoryHead(Map<String, List> inventoryHeads) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/inventory-head',
    );
    final response = await http.put(
      url,
      body: json.encode(inventoryHeads),
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
}
