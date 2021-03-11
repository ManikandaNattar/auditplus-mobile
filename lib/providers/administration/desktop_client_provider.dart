import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class DesktopClientProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/administration/desktop-client';
  DesktopClientProvider(this._auth);

  Future<List> desktopClientAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getDesktopClientList(
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

  Future<Map<String, dynamic>> getDesktopClient(String desktopClientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId',
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

  Future<void> deleteDesktopClient(String desktopClientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId/delete',
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

  Future<Map<String, dynamic>> createDesktopClient(
    Map<String, dynamic> desktopClientData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(desktopClientData),
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

  Future<void> updateDesktopClient(
    String desktopClientId,
    Map<String, dynamic> desktopClientData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(desktopClientData),
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
    String desktopClientId,
    List<String> branchesList,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId/assign-branch',
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

  Future<List> getClientAssignedBranches(String desktopClientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId/branches',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body);
  }

  Future<Map> generateRegistrationCode(String desktopClientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$desktopClientId/generate-registration-code',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    return json.decode(response.body);
  }
}
