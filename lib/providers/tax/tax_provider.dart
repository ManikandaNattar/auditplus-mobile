import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class TaxProvider with ChangeNotifier {
  final _auth;
  static const _baseUrl = '/tax/item';
  TaxProvider(this._auth);

  Future<List> getRegistrationType({@required String registerType}) async {
    final url = utils.encodeUrl(
      path: '/tax/reg-types',
      organization: _auth.organizationName,
      query: {'tax_type': 'GST', 'registrant_type': registerType},
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<List> taxAutoComplete({@required String searchText}) async {
    final url = utils.encodeUrl(
        path: '$_baseUrl/autocomplete',
        organization: _auth.organizationName,
        query: {'search_text': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['results'];
  }
}
