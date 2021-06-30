import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart' as utils;

class TenantAuth with ChangeNotifier {
  String _token;
  String _userId;
  String _organizationName;
  Map<String, dynamic> _profile;
  bool _isAdminAccess;
  Map<String, dynamic> _selectedBranch;

  bool get isAuthenticated {
    return (_token != null);
  }

  String get organizationName {
    return _organizationName;
  }

  String get userId {
    return _userId;
  }

  String get token {
    return _token;
  }

  Map<String, dynamic> get profile {
    return _profile;
  }

  Map<String, dynamic> get selectedBranch {
    return _selectedBranch;
  }

  bool get isAdmin {
    if (profile != null) {
      _isAdminAccess = profile['isAdmin'];
    }
    return _isAdminAccess;
  }

  List<Map<String, dynamic>> get assignedBranches {
    if (profile == null) {
      return [];
    } else {
      List branches = profile['branches'];
      return branches.map((elm) {
        return {
          'id': elm['id'] as String,
          'name': elm['name'] as String,
          'displayName': elm['displayName'] as String,
          'inventoryHead': elm['inventoryHead'] as String,
          'features': elm['features']['pharmacyRetail'] as bool,
        };
      }).toList();
    }
  }

  List get assignedCashRegisters {
    if (profile == null) {
      return [];
    } else {
      return profile['cashRegisters'];
    }
  }

  Map<String, dynamic> get privileges {
    String privilegesData = '';
    if (profile != null) {
      privilegesData = profile['privileges'];
    }
    return privilegesData == null || privilegesData.isEmpty
        ? null
        : jsonDecode(privilegesData);
  }

  Future<void> getselectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    final response = prefs.getString('selected_branch_info');
    if (response == null) {
      _selectedBranch = {
        'id': '-1',
        'name': 'Select Branch',
        'displayName': 'Select Branch'
      };
    } else {
      _selectedBranch = json.decode(response);
    }
  }

  setAuth(String token, String userId, String organization) {
    _token = token;
    _userId = userId;
    _organizationName = organization;
  }

  Future<void> getProfile() async {
    String url = utils.encodeUrl(
      organization: _organizationName,
      path: '/auth/profile/',
    );
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _token,
      },
    );
    _profile = json.decode(response.body);
  }

  Future<void> login(
    String username,
    String password,
    String organization,
  ) async {
    String url = utils.encodeUrl(
      organization: organization,
      path: '/auth/login/',
    );
    final response = await http.post(
      url,
      body: json.encode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    final prefs = await SharedPreferences.getInstance();
    final authInfo = json.encode({
      'token': responseData['xat'],
      'organization': organization,
      'userId': responseData['id'],
      'username': username,
    });
    prefs.setString('auth_info', authInfo);
    _token = responseData['xat'];
    _organizationName = organization;
    _userId = responseData['id'];
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_info');
    prefs.remove('selected_branch_info');
    _token = null;
    _userId = null;
    _organizationName = null;
  }

  Future<Map<String, dynamic>> changePassword(
      Map<String, dynamic> changePasswordData) async {
    String url = utils.encodeUrl(
      organization: organizationName,
      path: 'auth/change-password/',
    );
    final response = await http.post(
      url,
      body: json.encode(changePasswordData),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,
      },
    );
    return utils.handleResponse(
      response.statusCode,
      response.body,
    );
  }
}
