import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../../utils.dart' as utils;
import './../../constants.dart' as constants;

class DashboardProvider extends ChangeNotifier {
  final _auth;

  DashboardProvider(this._auth);

  Future<List<Map<String, dynamic>>> loadSaleSummary(
      DateTime fromDate, DateTime toDate) async {
    final url = utils.encodeUrl(
        organization: _auth.organizationName,
        path: '/report/dashboard/sale-summary',
        query: {
          'from_date': constants.isoDateFormat.format(fromDate),
          'to_date': constants.isoDateFormat.format(toDate)
        });
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      List responseData = json.decode(response.body);
      return responseData.map((elm) {
        return {
          'branch': elm['branch']['name'],
          'amount': elm['cash'].toDouble() + elm['credit'].toDouble(),
        };
      }).toList();
    } else {
      final responseData = json.decode(response.body);
      throw HttpException(responseData['message']);
    }
  }
}
