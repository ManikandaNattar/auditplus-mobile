import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class UserListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _userList = [];
  UserProvider _userProvider;
  Map _formData = {
    'name': '',
    'email': '',
    'role': '',
    'nameFilterKey': 'a..',
    'emailFilterKey': 'a..',
    'filterFormName': 'User',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getUserList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _getUserList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getUserList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'username': _formData['nameFilterKey']}: _formData['name'],
        {'email': _formData['emailFilterKey']}: _formData['email'],
        {'role': 'eq'}: _formData['role'],
      });
      Map response = await _userProvider.getUserList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addUser(data);
      });
      return _userList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addUser(List data) {
    _userList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'title': elm['username'],
            'subtitle': '',
            // 'subtitle': elm['role'].toString().replaceAll('null', ''),
          };
        },
      ).toList(),
    );
  }

  void _appbarSearchFuntion() {
    setState(() {
      pageNo = 1;
      _isLoading = true;
    });
    _formData = {
      'name': widget._appbarSearchEditingController.text,
      'nameFilterKey': '.a.',
      'filterFormName': 'User',
      'role': '',
      'email': '',
      'emailFilterKey': 'a..',
    };
    _userList.clear();
    _getUserList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/administration/manage/administration-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _userList.clear();
          _getUserList();
        }
      },
    );
  }

  void _clearFilterPressed() {
    setState(() {
      _isLoading = true;
      pageNo = 1;
    });
    _formData = {
      'name': '',
      'email': '',
      'role': '',
      'nameFilterKey': 'a..',
      'emailFilterKey': 'a..',
      'filterFormName': 'User',
    };
    _userList.clear();
    _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'User',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {});
            }
          },
        ),
        drawer: MainDrawer(),
        body: GeneralListView(
          hasMorePages: hasMorePages,
          isLoading: _isLoading,
          routeName: '/administration/manage/user/detail',
          list: _userList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add User',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/user/form',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/administration');
        return true;
      },
    );
  }
}
