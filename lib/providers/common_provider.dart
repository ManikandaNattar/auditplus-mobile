import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils.dart' as utils;

class CommonProvider with ChangeNotifier {
  final _auth;
  CommonProvider(this._auth);

  Future<List> getCountryList() async {
    final url = utils.encodeUrl(
      path: '/common/country/list',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<List> getStateList() async {
    final url = utils.encodeUrl(
      path: '/common/state/list',
      organization: _auth.organizationName,
      query: {'country': 'INDIA'},
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }
}
