import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../../utils.dart' as utils;

class VoucherProvider extends ChangeNotifier {
  static const _baseUrl = '/accounting/voucher';
  final _auth;
  VoucherProvider(this._auth);

  Future<Map<String, dynamic>> getVoucherList(
    Map<String, dynamic> searchQuery,
    int pageNo,
    int perPage,
    String sortOrder,
    String sortColumn,
    String voucherType,
    String branchId,
  ) async {
    final url = utils.encodeQSearchListApiUrl(
      organization: _auth.organizationName,
      path: 'voucher/',
      filterQuery: {
        'search': searchQuery.isEmpty ? null : json.encode(searchQuery),
        'page': pageNo.toString(),
        'perPage': perPage.toString(),
        'sortColumn': sortColumn.isEmpty ? null : sortColumn,
        'sortOrder': sortOrder.isEmpty ? null : sortOrder,
      },
      query: {
        'args': json.encode(
          {
            'voucherType': voucherType,
            'branch': branchId,
          },
        ),
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

  Future<void> createVoucher(Map accountPaymentData) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/create',
    );
    final response = await http.post(
      url,
      body: json.encode(accountPaymentData),
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

  Future<void> updateVoucher(
    String paymentVoucherId,
    Map accountPaymentData,
  ) async {
    String url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$paymentVoucherId/update',
    );
    final response = await http.put(
      url,
      body: json.encode(accountPaymentData),
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

  Future<Map<String, dynamic>> getVoucher(String paymentVoucherId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$paymentVoucherId',
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

  Future<void> deleteVoucher(
      String paymentVoucherId, String cashRegisterId) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/$paymentVoucherId/delete',
      query: cashRegisterId.isEmpty
          ? null
          : {
              'cashRegister': cashRegisterId,
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

  Future<List> getVoucherPendings(
    String branchId,
    String accountId,
    String voucherMode,
    List adjustmentPendings,
  ) async {
    final url = utils.encodeUrl(
      organization: _auth.organizationName,
      path: '$_baseUrl/pendings',
      query: {
        'branch_id': branchId,
        'account_id': accountId,
        'mode': voucherMode,
        'adj_pendings':
            adjustmentPendings.isEmpty ? null : json.encode(adjustmentPendings),
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
}
