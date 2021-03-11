import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  List<Map<String, dynamic>> _accountList = [];
  AccountProvider _accountProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'type': '',
    'parentAccount': '',
    'filterFormName': 'Account',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getAccountList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    _getAccountList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getAccountList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
        {'type': 'eq'}: _formData['type'],
        {'parentAccount': 'eq'}: _formData['parentAccount'],
      });
      Map response = await _accountProvider.getAccountList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      hasMorePages = response['hasMorePages'];
      List data = response['results'];
      setState(() {
        _isLoading = false;
        addAccount(data);
      });
      return _accountList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addAccount(List data) {
    _accountList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['type']['name'],
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
      'aliasName': '',
      'nameFilterKey': '.a.',
      'aliasNameFilterKey': 'a..',
      'type': '',
      'parentAccount': '',
      'filterFormName': 'Account',
    };
    _accountList.clear();
    _getAccountList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/accounts/manage/accounts-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _accountList.clear();
          _getAccountList();
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
      'aliasName': '',
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'type': '',
      'parentAccount': '',
      'filterFormName': 'Account',
    };
    _accountList.clear();
    _getAccountList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Account',
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
          routeName: '/accounts/manage/account/detail',
          list: _accountList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Account',
            onPressed: () => Navigator.of(context)
                .pushNamed('/accounts/manage/account/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'accounting.account.create',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/accounts');
        return true;
      },
    );
  }
}
