import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../../utils.dart' as utils;

class CostCentreProvider with ChangeNotifier {
  static const _baseUrl = '/accounting/cost-centre';
  final _auth;

  CostCentreProvider(this._auth);

  Future<List> costCentreAutocomplete({
    @required String searchText,
  }) async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      organization: _auth.organizationName,
      path: '/autocomplete/cost-centre/',
      query: {'searchText': searchText},
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body)['records'];
  }

  Future<Map<String, dynamic>> getCostCentreList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'cost-centre/',
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

  Future<Map<String, dynamic>> getCostCentre(String costCentreId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$costCentreId',
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

  Future<void> deleteCostCentre(String costCentreId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$costCentreId/delete',
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

  Future<Map<String, dynamic>> createCostCentre(
    Map<String, dynamic> costCentreData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(costCentreData),
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

  Future<void> updateCostCentre(
    String costCentreId,
    Map<String, dynamic> costCentreData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$costCentreId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(costCentreData),
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
