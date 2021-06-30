import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../../utils.dart' as utils;
import './../../constants.dart' as constants;

class DashboardProvider extends ChangeNotifier {
  final _auth;

  DashboardProvider(this._auth);

  Future<Map<String, dynamic>> loadSaleSummary(
      DateTime fromDate, DateTime toDate) async {
    final url = utils.encodeApiUrl(
      apiName: 'report',
      organization: _auth.organizationName,
      path: '/sale/summary',
      query: {
        'fromDate': constants.isoDateFormat.format(fromDate),
        'toDate': constants.isoDateFormat.format(toDate),
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
