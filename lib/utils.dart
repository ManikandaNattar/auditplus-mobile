import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auditplusmobile/providers/auth/cloud_auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/shared/user_branch_selection.dart';
import './models/organization.dart';
import './providers/auth/tenant_auth_provider.dart';

String _domain;

T cast<T>(x) => x is T ? x : null;

String encodeUrl({
  @required String path,
  @required String organization,
  Map<String, String> query,
}) {
  if (kDebugMode) {
    _domain = 'http://192.168.1.130:4001/api/v1';
  } else {
    _domain = '${Organization(organization).domain}/api/v1';
  }
  var url = '$_domain$path?organization=$organization';
  if (query != null) {
    query.forEach((k, v) {
      if (k != null && v != null) {
        url += '&$k=$v';
      }
    });
  }
  print(url);
  return url;
}

String cloudEncodeUrl({
  @required String path,
  Map<String, String> query,
}) {
  if (kDebugMode) {
    _domain = 'http://192.168.1.147:4001/api/v1';
  } else {
    _domain = 'https://cloud.auditplus.io/api/v1';
  }
  var url = '$_domain$path?';
  if (query != null) {
    query.forEach((k, v) {
      url += '&$k=$v';
    });
  }
  return url;
}

String encodeApiUrl({
  @required String apiName,
  @required String path,
  @required String organization,
  Map<String, String> query,
}) {
  if (kDebugMode) {
    apiName == 'report'
        ? _domain = 'http://192.168.1.130:8030/$apiName/api'
        : _domain = 'http://192.168.1.130:8050/$apiName/api';
  } else {
    _domain = '${Organization(organization).domain}/$apiName/api';
  }
  var url = '$_domain$path?organization=$organization';
  if (query != null) {
    query.forEach((k, v) {
      if (k != null && v != null) {
        url += '&$k=$v';
      }
    });
  }
  print(url);
  return url;
}

String encodeQSearchListApiUrl({
  @required String path,
  @required String organization,
  Map<String, String> filterQuery,
  Map<String, String> query,
}) {
  String queryString = '';
  if (kDebugMode) {
    _domain = 'http://192.168.1.130:8050/qsearch/api/list/';
  } else {
    _domain = '${Organization(organization).domain}/qsearch/api/list/';
  }
  var url = '$_domain$path?organization=$organization';
  if (filterQuery != null) {
    filterQuery.forEach((k, v) {
      if (k != null && v != null) {
        final encodedKey = json.encode(k);
        if (k == 'search') {
          queryString += '$encodedKey:$v,';
        } else if (k == 'page' || k == 'perPage' || k == 'sortOrder') {
          queryString += '$encodedKey:${int.parse(v)},';
        } else {
          queryString += '$encodedKey:${json.encode(v)},';
        }
      }
    });
    url += '&filter={${queryString.substring(0, queryString.length - 1)}}';
  }
  if (query != null) {
    query.forEach((k, v) {
      if (k != null && v != null) {
        url += '&$k=$v';
      }
    });
  }
  print(url);
  return url;
}

Future<void> handleErrorResponse(
    BuildContext context, String message, String appLoginMode) async {
  if (appLoginMode == 'cloud' && message == 'Unauthorized') {
    final _auth = Provider.of<CloudAuth>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final authInfo = json.decode(prefs.getString('cloud_auth_info'));
    String email = authInfo['email'];
    await _auth.logout();
    Navigator.of(context).pushReplacementNamed(
      '/cloud/login',
      arguments: {'email': email},
    );
  } else if (appLoginMode == 'tenant' && message == 'Unauthorized') {
    final _auth = Provider.of<TenantAuth>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final authInfo = json.decode(prefs.getString('auth_info'));
    String username = authInfo['username'];
    String organization = authInfo['organization'];
    await _auth.logout();
    Navigator.of(context).pushReplacementNamed(
      '/login',
      arguments: {
        'username': username,
        'organization': organization,
      },
    );
  } else {
    if (message.contains('Organization not found')) {
      Navigator.of(context).pushReplacementNamed('/organization');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.contains('Failed host lookup')
              ? 'Please check your internet connection!'
              : message,
          style: Theme.of(context).textTheme.button,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}

Future<bool> checkBranchSelected(BuildContext context, String routeName) async {
  TenantAuth tenantAuth = Provider.of<TenantAuth>(context, listen: false);
  final data = tenantAuth.selectedBranch;
  if (data['name'] == 'Select Branch') {
    showModalUserBranchSelection(
      context: context,
      selectedBranch: data['name'],
      inventoryHead: '',
    ).then(
      (value) {
        if (value != null) {
          Navigator.of(context).pushNamed(
            routeName,
          );
        }
      },
    );
    return false;
  } else {
    Navigator.of(context).pushNamed(routeName);
    return true;
  }
}

String _getFilterKey(String name, String filterKey) {
  if (filterKey == 'sw' || filterKey == 'a..') {
    return name + '__sw';
  } else if (filterKey == 'ew' || filterKey == '..a') {
    return name + '__ew';
  } else if (filterKey == 'cns' || filterKey == '.a.') {
    return name + '__cns';
  } else if (filterKey == 'eq' || filterKey == '=') {
    return name + '__eq';
  } else if (filterKey == 'gte' || filterKey == '≥') {
    return name + '__gte';
  } else if (filterKey == 'lte' || filterKey == '≤') {
    return name + '__lte';
  } else if (filterKey == '>') {
    return name + '__gt';
  } else if (filterKey == '<') {
    return name + '__lt';
  } else if (filterKey == '≠') {
    return name + '__ne';
  } else {
    return '';
  }
}

Map<String, dynamic> buildSearchQuery(Map<Map<String, String>, dynamic> map) {
  Map<String, dynamic> searchQuery = Map();
  for (final query in map.entries) {
    final value = query.value;
    final filterKeyMap = query.key;
    String filterKey;
    for (final filterKeyQuery in filterKeyMap.entries) {
      filterKey = _getFilterKey(filterKeyQuery.key, filterKeyQuery.value);
      if (value != '') {
        searchQuery.addAll({filterKey: value});
      }
    }
  }
  return searchQuery;
}

Map<String, Map<String, String>> buildDetailQuery(
    Map<String, Map<String, String>> map) {
  Map<String, Map<String, String>> detailQuery = Map();
  if (map != null) {
    for (final query in map.entries) {
      Map<String, String> valueData = Map();
      final key = query.key;
      final data = query.value;
      if (data != null) {
        for (final dataQuery in data.entries) {
          if (dataQuery.value != null && dataQuery.value != '') {
            valueData.addAll({dataQuery.key: dataQuery.value});
          }
        }
        if (valueData.isNotEmpty) {
          detailQuery.addAll({key: valueData});
        }
      }
    }
  }
  return detailQuery;
}

void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}

void showAlertDialog(
    BuildContext context, Function onPressed, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              onPressed();
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}

bool checkFeatures(BuildContext context, String menuName) {
  TenantAuth tenantAuth = Provider.of<TenantAuth>(context, listen: false);
  final branch = tenantAuth.selectedBranch;
  bool features = false;
  if (menuName == 'pharmacy') {
    if (branch['name'] != 'Select Branch') {
      features = branch['features'];
    }
  }
  return features;
}

bool checkMenuWiseAccess(BuildContext context, List<String> menuList) {
  TenantAuth tenantAuth = Provider.of<TenantAuth>(context, listen: false);
  bool isMenuAccess = false;
  if (tenantAuth.isAdmin != null && tenantAuth.isAdmin == true) {
    isMenuAccess = true;
    return isMenuAccess;
  } else {
    if (tenantAuth.privileges != null) {
      Map<String, dynamic> privilegesData = tenantAuth.privileges;
      if (privilegesData != null) {
        if (menuList.isEmpty || menuList == null) {
          isMenuAccess = false;
        } else {
          for (int i = 0; i <= menuList.length - 1; i++) {
            String menuCode = menuList[i];
            final splitterValue = menuCode.split('.');
            String category = splitterValue[0];
            String subcategory = splitterValue[1];
            String menu = splitterValue[2];
            Map categoryObject = privilegesData[category] == null
                ? {}
                : privilegesData[category];
            Map subcaregoryObject = categoryObject[subcategory] == null
                ? {}
                : categoryObject[subcategory];
            isMenuAccess = subcaregoryObject[menu] == null
                ? false
                : subcaregoryObject[menu];
            if (isMenuAccess == true) {
              break;
            }
          }
        }
      }
    }
    return isMenuAccess;
  }
}

Map<Map<String, dynamic>, List<Map<String, dynamic>>> checkMenuVisibility(
  BuildContext context,
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> map,
) {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _menuItemList = {};
  for (final query in map.entries) {
    List<Map<String, dynamic>> _data = [];
    final key = query.key;
    final value = query.value;
    for (int i = 0; i <= value.length - 1; i++) {
      final privileges = value[i]['privileges'] as List<String>;
      final features = value[i]['features'].toString().replaceAll('null', '');
      if (_checkVisibility(context, features, privileges)) {
        if (_data.where((element) => element == value[i]).isEmpty) {
          _data.add(value[i]);
        }
      }
    }
    if (_data.isNotEmpty) {
      _menuItemList.addAll({key: _data});
    }
  }
  return _menuItemList;
}

bool _checkVisibility(
  BuildContext context,
  String features,
  List<String> privileges,
) {
  if (features.isNotEmpty) {
    final a = checkFeatures(
      context,
      features,
    );
    if (!a) {
      return false;
    }
  }
  return privileges[0].isEmpty
      ? true
      : checkMenuWiseAccess(
          context,
          privileges,
        );
}

Future<bool> checkPermission() async {
  Map<Permission, PermissionStatus> statuses = {};
  PermissionStatus _permissionStatus;
  _permissionStatus = await Permission.storage.status;
  if (_permissionStatus.isDenied) {
    statuses = await [
      Permission.storage,
    ].request();
    _permissionStatus = statuses[Permission.storage];
  }
  return _permissionStatus.isGranted == true ? true : false;
}

Future<File> downloadFile(Uint8List stream, String reportName) async {
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String fileName = '${reportName}_$currentDate';
  final directory =
      Directory('/storage/emulated/0/io.auditplus.mobile/Reports');
  if (!await directory.exists()) {
    directory.create(recursive: true);
  }
  final file = File('${directory.path}/$fileName.pdf');
  return file.writeAsBytes(stream);
}

bool checkHasMorePages(Map pageContext, int currentPage) {
  int totalPageCount =
      (pageContext['totalCount'].toInt() / pageContext['perPage'].toInt())
          .ceil();
  if (currentPage == totalPageCount) {
    return false;
  } else {
    return true;
  }
}

Future<void> launchUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Could not launch url $url',
        ),
      ),
    );
  }
}

dynamic handleResponse(int statusCode, dynamic responseData) {
  var response;
  switch (statusCode) {
    case 200:
      response = responseData.isNotEmpty ? json.decode(responseData) : null;
      return response;
      break;
    case 201:
      response = responseData.isNotEmpty ? json.decode(responseData) : null;
      return response;
      break;
    case 401:
      response = {'message': 'Unauthorized'};
      throw HttpException(response['message']);
      break;
    default:
      response = json.decode(responseData);
      throw HttpException(response['message'] is List
          ? response['message'].join(',')
          : response['message']);
  }
}
