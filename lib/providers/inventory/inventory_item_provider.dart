import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class InventoryItemProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory';
  InventoryItemProvider(this._auth);

  Future<List> inventoryItemAutoComplete({
    @required String searchText,
    @required List inventoryHeads,
  }) async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      path: '/autocomplete/inventory/',
      organization: _auth.organizationName,
      query: {
        'searchText': searchText,
        'args': inventoryHeads == null
            ? null
            : json.encode(
                {
                  'heads': inventoryHeads,
                },
              ),
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }

  Future<Map<String, dynamic>> getInventoryList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
    List<String> inventoryHead,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'inventory/',
      filterQuery: {
        'search': searchQuery.isEmpty ? null : json.encode(searchQuery),
        'page': pageNo.toString(),
        'perPage': perPage.toString(),
        'sortColumn': sortColumn.isEmpty ? null : sortColumn,
        'sortOrder': sortOrder.isEmpty ? null : sortOrder,
      },
      query: {
        'args': inventoryHead.contains(null)
            ? null
            : json.encode({'heads': inventoryHead}),
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<List> getDealers(String inventoryId) async {
    final url = utils.encodeUrl(
      path: '$_baseUrl/$inventoryId/dealers/list',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<void> setUnitConversion(
    String inventoryId,
    Map unitConversionData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/unit',
    );
    final response = await http.put(
      url,
      body: json.encode(unitConversionData),
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

  Future<List> getUnitConversion(String inventoryId) async {
    final url = utils.encodeUrl(
      path: '$_baseUrl/$inventoryId/units',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<void> deleteUnitConversion(String inventoryId, int conversion) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$inventoryId/unit',
      query: {
        'conversion': conversion.toString(),
      },
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
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
      body: json.encode({'items': batches}),
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

  Future<Map> getInventoryOpening(
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
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }
}
