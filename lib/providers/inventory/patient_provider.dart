import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../utils.dart' as utils;

class PatientProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/inventory/sale/patient';
  PatientProvider(this._auth);

  Future<Map<String, dynamic>> getPatientList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'patient/',
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
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['message']);
    }
    return responseData;
  }

  Future<Map<String, dynamic>> getPatient(String patientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$patientId',
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

  Future<void> deletePatient(String patientId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$patientId/delete',
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

  Future<void> createPatient(Map<String, dynamic> patientData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(patientData),
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

  Future<void> updatePatient(
      String patientId, Map<String, dynamic> patientData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$patientId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(patientData),
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

  Future<List> patientAutoComplete({
    @required String searchText,
    String customerId,
  }) async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      path: '/autocomplete/doctor/',
      organization: _auth.organizationName,
      query: {
        'searchText': searchText,
        'args': json.encode({'customer': customerId})
      },
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }
}
