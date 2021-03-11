import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../utils.dart' as utils;

class OrganizationProvider with ChangeNotifier {
  Map<String, dynamic> _organization;

  Map<String, dynamic> get organization {
    return _organization;
  }

  Future<void> getOrganization(String organizationName) async {
    String url = utils.encodeUrl(
      organization: organizationName,
      path: '/organization/$organizationName',
    );
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _organization = json.decode(response.body);
  }
}
