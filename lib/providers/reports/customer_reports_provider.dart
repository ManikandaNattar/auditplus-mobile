import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import './../../utils.dart' as utils;
import 'package:http/http.dart' as http;

class CustomerReportsProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/report';
  CustomerReportsProvider(this._auth);

  Future<Map<String, dynamic>> getCustomerOutstandingConsolidatedReport(
    String groupBy,
    List customer,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-outstanding/consolidated',
      query: {
        'customer': json.encode(customer),
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

  Future<Map<String, dynamic>> getCustomerOutstandingSummary(
    String groupBy,
    List customer,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-outstanding/summary',
      query: {
        'customer': json.encode(customer),
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

  Future<Map<String, dynamic>> getCustomerOutstandingDetail(
    String groupBy,
    List customer,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-outstanding/detail',
      query: {
        'customer': json.encode(customer),
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

  Future<Map<String, dynamic>> getCustomerBook(
    String fromDate,
    String toDate,
    String customerId,
    List branch,
    int pageNo,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-book',
      query: {
        'customer_id': customerId,
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

  Future<Uint8List> getCustomerOutstandingPrintData(
    Map requestData,
    String branchId,
    String viewReportMode,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-outstanding/$viewReportMode/print',
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

  Future<Uint8List> getCustomerBookPrintData(
    String branchId,
    String fromDate,
    String toDate,
    String customerId,
    List branch,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/customer-book/print',
      query: {
        'branch': branchId,
        'customer_id': customerId,
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
