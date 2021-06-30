import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class UnitProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/unit';
  UnitProvider(this._auth);

  Future<List> unitAutoComplete({@required String searchText}) async {
    final url = utils.encodeApiUrl(
        apiName: 'qsearch',
        path: '/autocomplete/unit/',
        organization: _auth.organizationName,
        query: {'searchText': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }

  Future<Map<String, dynamic>> getUnitList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'unit/',
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

  Future<Map<String, dynamic>> getUnit(String unitId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$unitId',
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

  Future<void> deleteUnit(String unitId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$unitId/delete',
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

  Future<Map<String, dynamic>> createUnit(Map<String, dynamic> unitData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(unitData),
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

  Future<void> updateUnit(
    String unitId,
    Map<String, dynamic> unitData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$unitId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(unitData),
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

  Future<List> getUnitUQC() async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      path: '/fetch/uqc/',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }
}
