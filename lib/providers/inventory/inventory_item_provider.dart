import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class InventoryItemProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/item';
  InventoryItemProvider(this._auth);

  Future<List> inventoryItemAutoComplete({
    @required String searchText,
    @required List inventoryHeads,
  }) async {
    final url = utils.encodeUrl(
      path: '$_baseUrl/autocomplete',
      organization: _auth.organizationName,
      query: {
        'search_text': searchText,
        'head': json.encode(inventoryHeads),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }

  Future<Map<String, dynamic>> getInventoryList(
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
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    }
    return responseData;
  }

  Future<Map<String, dynamic>> getInventory(String inventoryId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    }
    return responseData;
  }

  Future<void> deleteInventory(String inventoryId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/delete',
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.delete(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    }
  }

  Future<void> createInventory(Map<String, dynamic> inventoryData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(inventoryData),
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
  }

  Future<void> updateInventory(
    String inventoryId,
    Map<String, dynamic> inventoryData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(inventoryData),
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

  Future<void> setPriceConfiguration(
    String inventoryId,
    String branchId,
    Map priceConfigData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/price-config/$branchId',
    );
    final response = await http.put(
      url,
      body: json.encode(priceConfigData),
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

  Future<Map<String, dynamic>> getPriceConfiguration(
    String inventoryId,
    String branchId,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/price-config/$branchId',
    );
    final response = await http.get(
      url,
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
    return responseData;
  }

  Future<List> getDealers(String inventoryId) async {
    final url = utils.encodeUrl(
      path: '$_baseUrl/$inventoryId/dealers/list',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<void> setDealers(
    String inventoryId,
    String vendorId,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/dealers/add',
    );
    final response = await http.put(
      url,
      body: json.encode({'vendor': vendorId}),
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

  Future<void> setDealersPreferred(
    String inventoryId,
    String vendorId,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/dealers/set-preferred',
    );
    final response = await http.post(
      url,
      body: json.encode({'vendor': vendorId}),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    if (response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      if (response.statusCode != 201) {
        final message = responseData['message'];
        throw HttpException(message is List ? message.join(',') : message);
      }
    }
  }

  Future<void> removeDealers(
    String inventoryId,
    List vendorIdList,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/dealers/remove',
    );
    final response = await http.put(
      url,
      body: json.encode({'vendors': vendorIdList}),
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

  Future<void> setUnitConversion(
    String inventoryId,
    Map unitConversionData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/unit-conversion/add',
    );
    final response = await http.post(
      url,
      body: json.encode(unitConversionData),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _auth.token as String,
      },
    );
    if (response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      if (response.statusCode != 201) {
        final message = responseData['message'];
        throw HttpException(message is List ? message.join(',') : message);
      }
    }
  }

  Future<List> getUnitConversion(String inventoryId) async {
    final url = utils.encodeUrl(
      path: '$_baseUrl/$inventoryId/unit-conversion',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['conversion'];
  }

  Future<void> setUnitConversionPreferred(
    String inventoryId,
    Map unitConversionData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/unit-conversion/set-preferred',
    );
    final response = await http.put(
      url,
      body: json.encode(unitConversionData),
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

  Future<void> setAssignedRacks(
    String inventoryId,
    String branchId,
    Map assignedRacksData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/racks/$branchId',
    );
    final response = await http.put(
      url,
      body: json.encode(assignedRacksData),
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

  Future<Map<String, dynamic>> getAssignedRacks(
    String inventoryId,
    String branchId,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/racks/$branchId',
    );
    final response = await http.get(
      url,
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
    return responseData;
  }

  Future<void> setInventoryOpening(
    String inventoryId,
    String branchId,
    List batches,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/opening/$branchId',
    );
    final response = await http.put(
      url,
      body: json.encode({'trns': batches}),
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

  Future<List> getInventoryOpening(
    String inventoryId,
    String branchId,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/opening/$branchId',
    );
    final response = await http.get(
      url,
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
    return responseData['trns'];
  }
}
