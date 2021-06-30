import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class BranchProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/administration/branch';

  BranchProvider(this._auth);

  Future<List> branchAutoComplete({@required String searchText}) async {
    final url = utils.encodeApiUrl(
        apiName: 'qsearch',
        path: '/autocomplete/branch/',
        organization: _auth.organizationName,
        query: {'searchText': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }

  Future<Map<String, dynamic>> getBranchList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'branch/',
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }
}
