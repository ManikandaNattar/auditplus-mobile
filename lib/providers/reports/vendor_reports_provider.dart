import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class VendorReportsProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/report';
  VendorReportsProvider(this._auth);

  Future<Map<String, dynamic>> getVendorOutstandingConsolidatedReport(
    String groupBy,
    List vendor,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-outstanding/consolidated',
      query: {
        'vendor': json.encode(vendor),
        'branch': json.encode(branch),
        'group_by': groupBy,
        'page': pageNo.toString(),
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

  Future<Map<String, dynamic>> getVendorOutstandingSummary(
    String groupBy,
    List vendor,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-outstanding/summary',
      query: {
        'vendor': json.encode(vendor),
        'branch': json.encode(branch),
        'group_by': groupBy,
        'page': pageNo.toString(),
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

  Future<Map<String, dynamic>> getVendorOutstandingDetail(
    String groupBy,
    List vendor,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-outstanding/detail',
      query: {
        'vendor': json.encode(vendor),
        'branch': json.encode(branch),
        'group_by': groupBy,
        'page': pageNo.toString(),
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

  Future<Map<String, dynamic>> getVendorBook(
    String fromDate,
    String toDate,
    String vendorId,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-book',
      query: {
        'vendor_id': vendorId,
        'branch_id': json.encode(branch),
        'from_date': fromDate,
        'to_date': toDate,
        'page': pageNo.toString(),
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

  Future<Uint8List> getVendorOutstandingPrintData(
    Map requestData,
    String branchId,
    String viewReportMode,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-outstanding/$viewReportMode/print',
      query: {
        'branch': branchId,
      },
    );
    final headers = {
      'X-Auth-Token': _auth.token as String,
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(requestData),
    );
    if (response.statusCode != 201) {
      final responseData = json.decode(response.body);
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    } else {
      final responseData = response.bodyBytes;
      return responseData;
    }
  }

  Future<Uint8List> getVendorBookPrintData(
    String branchId,
    String fromDate,
    String toDate,
    String vendorId,
    List branch,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/vendor-book/print',
      query: {
        'branch': branchId,
        'vendor_id': vendorId,
        'branch_id': json.encode(branch),
        'from_date': fromDate,
        'to_date': toDate,
      },
    );
    final headers = {
      'X-Auth-Token': _auth.token as String,
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      throw HttpException(responseData['message'] is List
          ? responseData['message'].join(',')
          : responseData['message']);
    } else {
      final responseData = response.bodyBytes;
      return responseData;
    }
  }
}
