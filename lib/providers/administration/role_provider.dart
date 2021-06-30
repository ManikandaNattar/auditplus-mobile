import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../../utils.dart' as utils;

class RoleProvider with ChangeNotifier {
  final _auth;
  RoleProvider(this._auth);

  Future<List> roleAutoComplete({@required String searchText}) async {
    final url = utils.encodeApiUrl(
        apiName: 'qsearch',
        path: '/autocomplete/role/',
        organization: _auth.organizationName,
        query: {'searchText': searchText});
    final headers = {'X-Auth-Token': _auth.token as String};
    final response = await http.get(url, headers: headers);
    return json.decode(response.body)['records'];
  }
}
