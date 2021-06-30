import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class TaxProvider with ChangeNotifier {
  final _auth;
  TaxProvider(this._auth);

  Future<List> getRegistrationType({@required String registerType}) async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      path: '/fetch/gst-reg-types/',
      organization: _auth.organizationName,
      query: {'registration': registerType},
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<List> taxAutoComplete() async {
    final url = utils.encodeApiUrl(
      apiName: 'qsearch',
      path: '/fetch/gst-taxes/',
      organization: _auth.organizationName,
    );
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }
}
