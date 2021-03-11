import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class RackProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/rack';
  RackProvider(this._auth);

  Future<List> rackAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getRackList(
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

  Future<Map<String, dynamic>> getRack(String rackId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$rackId',
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

  Future<void> deleteRack(String rackId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$rackId/delete',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.delete(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message']);
    }
  }

  Future<Map<String, dynamic>> createRack(Map<String, dynamic> rackData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(rackData),
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

  Future<void> updateRack(
    String rackId,
    Map<String, dynamic> rackData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$rackId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(rackData),
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
