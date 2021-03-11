import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class SectionProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/section';
  SectionProvider(this._auth);

  Future<List> sectionAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getSectionList(
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

  Future<Map<String, dynamic>> getSection(String sectionId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$sectionId',
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

  Future<void> deleteSection(String sectionId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$sectionId/delete',
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

  Future<Map<String, dynamic>> createSection(
      Map<String, dynamic> sectionData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(sectionData),
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

  Future<void> updateSection(
    String sectionId,
    Map<String, dynamic> sectionData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$sectionId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(sectionData),
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
