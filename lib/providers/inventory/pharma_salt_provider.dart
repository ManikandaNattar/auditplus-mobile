import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class PharmaSaltProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/pharma-salt';
  PharmaSaltProvider(this._auth);

  Future<List> pharmaSaltAutoComplete({@required String searchText}) async {
    final url = utils.encodeApiUrl(
        apiName: 'qsearch',
        path: '/autocomplete/pharma-salt/',
        organization: _auth.organizationName,
        query: {'searchText': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }

  Future<Map<String, dynamic>> getPharmaSaltList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'pharma-salt/',
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

  Future<Map<String, dynamic>> getPharmaSalt(String saltId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$saltId',
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

  Future<void> deletePharmaSalt(String saltId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$saltId/delete',
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

  Future<Map<String, dynamic>> createPharmaSalt(
      Map<String, dynamic> saltData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(saltData),
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

  Future<void> updatePharmaSalt(
      String saltId, Map<String, dynamic> saltData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$saltId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(saltData),
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
