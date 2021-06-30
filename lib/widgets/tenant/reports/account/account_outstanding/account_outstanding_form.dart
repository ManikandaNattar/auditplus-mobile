import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountOutstandingFormScreen extends StatefulWidget {
  @override
  _AccountOutstandingFormScreenState createState() =>
      _AccountOutstandingFormScreenState();
}

class _AccountOutstandingFormScreenState
    extends State<AccountOutstandingFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TenantAuth _tenantAuth;
  AccountProvider _accountProvider;
  FocusNode _accountFocusNode = FocusNode();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _accountTextEditingController = TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  List<Map<String, dynamic>> _selectedAccountList = [];
  List<String> _selectedAccountIdList = [];
  List<Map<String, dynamic>> _selectedBranchList = [];
  List<String> _selectedBranchIdList = [];
  Map _userSelectedBranch = {};
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  Map arguments = {};
  bool _allBranchSelected = false;
  bool _allAccountSelected = false;
  bool _defaultBranchDeleted = false;
  List _selectedAccountTypesList = [];
  List<String> _selectedAccountTypes = [];
  List _accountTypesList = [];
  List _groupByList = [];
  bool _isBranchGroupBy = true;
  bool _isAccountGroupBy = false;
  String _orderBy = '';
  bool _isBranchOrderBy = true;
  bool _isAccountOrderBy = false;
  Map<String, dynamic> _branchData = {
    'id': '-1',
    'name': 'All Branch',
    'displayName': 'All Branch',
  };
  Map<String, dynamic> _accountData = {
    'id': '-1',
    'name': 'All Account',
    'displayName': 'All Account',
  };

  @override
  void initState() {
    _checkVisibility();
    _selectedAccountList.add(_accountData);
    super.initState();
  }

  @override
  void dispose() {
    _accountFocusNode.dispose();
    _branchFocusNode.dispose();
    _branchTextEditingController.dispose();
    _accountTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _tenantAuth = Provider.of<TenantAuth>(context);
    _accountProvider = Provider.of<AccountProvider>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    _assignedBranches = _tenantAuth.assignedBranches;
    arguments = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(
      context,
      [
        'rpt.ac.py',
        'rpt.ac.pr',
        'rpt.ac.tp',
        'rpt.ac.tr',
        'rpt.ac.ap',
        'rpt.ac.ar',
      ],
    )) {
      _accountTypesList.add(
        {
          "name": "All",
          "defaultName": "ALL",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.py'])) {
      _accountTypesList.add(
        {
          "name": "Payable",
          "defaultName": "PAYABLE",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.rc'])) {
      _accountTypesList.add(
        {
          "name": "Receivable",
          "defaultName": "RECEIVABLE",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.tp'])) {
      _accountTypesList.add(
        {
          "name": "Trade Payable",
          "defaultName": "TRADE_PAYABLE",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.tr'])) {
      _accountTypesList.add(
        {
          "name": "Trade Receivable",
          "defaultName": "TRADE_RECEIVABLE",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.ap'])) {
      _accountTypesList.add(
        {
          "name": "Account Payable",
          "defaultName": "ACCOUNT_PAYABLE",
        },
      );
    }
    if (utils.checkMenuWiseAccess(context, ['rpt.ac.ar'])) {
      _accountTypesList.add(
        {
          "name": "Account Receivable",
          "defaultName": "ACCOUNT_RECEIVABLE",
        },
      );
    }
    _selectedAccountTypesList.add(_accountTypesList[0]);
  }

  void _getFormData() {
    if (arguments['groupBy'] != '') {
      _groupByList = arguments['groupBy'];
      _isAccountGroupBy = _groupByList.contains('account');
      _isBranchGroupBy = _groupByList.contains('branch');
    } else {
      _groupByList.add('branch');
    }
    if (arguments['orderBy'] != '') {
      _orderBy = arguments['orderBy'];
      _isAccountOrderBy = _orderBy.contains('account');
      _isBranchOrderBy = _orderBy.contains('branch');
    } else {
      _orderBy = 'branch';
    }
    _defaultBranchDeleted = arguments['branchList'] == ''
        ? _defaultBranchDeleted
        : _selectedBranchList
            .where((element) => element == _userSelectedBranch)
            .isEmpty;
    _selectedBranchList = arguments['branchList'] == ''
        ? _selectedBranchList
        : arguments['branchList'];
    _selectedAccountList = arguments['accountList'] == ''
        ? _selectedAccountList
        : arguments['accountList'];
    _selectedBranchIdList =
        arguments['branch'] == '' ? _selectedBranchIdList : arguments['branch'];
    _selectedAccountIdList = arguments['account'] == ''
        ? _selectedAccountIdList
        : arguments['account'];
    var checkSelectedBranchAdded =
        _selectedBranchList.where((element) => element == _userSelectedBranch);
    _allBranchSelected = _selectedBranchList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    _allAccountSelected = _selectedAccountList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    if (arguments['accountTypesList'] != '' &&
        arguments['accountTypes'] != '') {
      _selectedAccountTypesList = arguments['accountTypesList'];
      _selectedAccountTypes = arguments['accountTypes'];
    }
    if (_userSelectedBranch['id'] != '-1' &&
        checkSelectedBranchAdded.isEmpty &&
        _defaultBranchDeleted == false) {
      _selectedBranchList.add(_userSelectedBranch);
    }
  }

  void _getSelectedAccountList() {
    if (_selectedAccountList.isNotEmpty) {
      for (int i = 0; i <= _selectedAccountList.length - 1; i++) {
        if (_selectedAccountList[i]['id'] != '-1') {
          if (_selectedAccountIdList
              .where((element) => element == _selectedAccountList[i]['id'])
              .isEmpty) {
            _selectedAccountIdList.add(_selectedAccountList[i]['id']);
          }
        }
      }
    }
  }

  void _getSelectedBranchList() {
    if (_selectedBranchList.isNotEmpty) {
      for (int i = 0; i <= _selectedBranchList.length - 1; i++) {
        if (_selectedBranchList[i]['id'] != '-1') {
          if (_selectedBranchIdList
              .where((element) => element == _selectedBranchList[i]['id'])
              .isEmpty) {
            _selectedBranchIdList.add(_selectedBranchList[i]['id']);
          }
        }
      }
    }
  }

  List<Map<String, dynamic>> getBranchList(String query) {
    _filterBranches.clear();
    for (int i = 0; i <= _assignedBranches.length - 1; i++) {
      String name = _assignedBranches[i]['name'];
      if (_selectedBranchList
          .where((element) => element['name'] == name)
          .isEmpty) {
        if (query.isEmpty) {
          _filterBranches.add(_assignedBranches[i]);
        } else {
          if (name
              .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
              .toLowerCase()
              .startsWith(query
                  .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
                  .toLowerCase())) {
            _filterBranches.add(_assignedBranches[i]);
          }
        }
      }
    }
    return _filterBranches;
  }

  void _onSearch() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _formData = {
        'groupBy': _groupByList,
        'orderBy': _orderBy,
        'account': _selectedAccountIdList,
        'branch': _selectedBranchIdList,
        'branchList': _selectedBranchList,
        'accountList': _selectedAccountList,
        'accountTypes':
            _selectedAccountTypes == null || _selectedAccountTypes.isEmpty
                ? null
                : _selectedAccountTypes,
        'accountTypesList': _selectedAccountTypesList,
      };
      _groupByList = [];
      Navigator.of(context).pop(_formData);
    }
  }

  Widget _accountOutstandingGeneralInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'ACCOUNT TYPE INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Account Type',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: DropdownButton<dynamic>(
                      isExpanded: true,
                      value: _selectedAccountTypesList[0]['name'],
                      onChanged: (dynamic newValue) {
                        setState(
                          () {
                            _selectedAccountTypesList = [];
                            _selectedAccountTypes = [];
                            _accountTypesList.forEach(
                              (elm) {
                                if (newValue == 'All') {
                                  _selectedAccountTypesList.add(elm);
                                  _selectedAccountTypes.add(elm['defaultName']);
                                } else if (newValue == 'Payable') {
                                  if (elm['name']
                                      .toString()
                                      .contains('Payable')) {
                                    _selectedAccountTypesList.add(elm);
                                    _selectedAccountTypes
                                        .add(elm['defaultName']);
                                  }
                                } else if (newValue == 'Receivable') {
                                  if (elm['name']
                                      .toString()
                                      .contains('Receivable')) {
                                    _selectedAccountTypesList.add(elm);
                                    _selectedAccountTypes
                                        .add(elm['defaultName']);
                                  }
                                } else if (newValue != 'Payable' ||
                                    newValue != 'Receivable') {
                                  if (elm['name'] == newValue) {
                                    _selectedAccountTypesList.add(elm);
                                    _selectedAccountTypes
                                        .add(elm['defaultName']);
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                      items: _accountTypesList.map(
                        (dynamic accountType) {
                          return DropdownMenuItem<dynamic>(
                            value: accountType['name'],
                            child: Text(
                              accountType['name'],
                              style: TextStyle(
                                color: _selectedAccountTypes == null ||
                                        _selectedAccountTypes.isEmpty ||
                                        _selectedAccountTypes.contains(
                                            accountType['defaultName'])
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountOutstandingOrderByContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'ORDER BY INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(4),
                      title: Text(
                        'Branch',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      value: _isBranchOrderBy,
                      onChanged: (val) {
                        setState(() {
                          if (val) {
                            _isBranchOrderBy = true;
                            _orderBy = 'branch';
                            _isAccountOrderBy = false;
                            if (_groupByList.length != 2) {
                              _isBranchGroupBy = true;
                              _isAccountGroupBy = false;
                              _groupByList = [];
                              _groupByList.add('branch');
                            }
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(4),
                      title: Text(
                        'Account',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      value: _isAccountOrderBy,
                      onChanged: (val) {
                        setState(() {
                          if (val) {
                            _isAccountOrderBy = true;
                            _orderBy = 'account';
                            _isBranchOrderBy = false;
                            if (_groupByList.length != 2) {
                              _isAccountGroupBy = true;
                              _isBranchGroupBy = false;
                              _groupByList = [];
                              _groupByList.add('account');
                            }
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountOutstandingGroupByContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'GROUP BY INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(4),
                      title: Text(
                        'Branch',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      value: _isBranchGroupBy,
                      onChanged: (val) {
                        setState(() {
                          _isBranchGroupBy = val;
                          if (!_groupByList.contains('branch')) {
                            _groupByList.add('branch');
                          }
                          if (_isBranchGroupBy == false) {
                            _groupByList.remove('branch');
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(4),
                      title: Text(
                        'Account',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      value: _isAccountGroupBy,
                      onChanged: (val) {
                        setState(() {
                          _isAccountGroupBy = val;
                          if (!_groupByList.contains('account')) {
                            _groupByList.add('account');
                          }
                          if (_isAccountGroupBy == false) {
                            _groupByList.remove('account');
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountOutstandingAccountContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'ACCOUNT INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  AutocompleteFormField(
                    autoFocus: false,
                    focusNode: _accountFocusNode,
                    controller: _accountTextEditingController,
                    labelText: 'Account',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    validator: (value) {
                      if (value == null && _selectedAccountList.isEmpty) {
                        return 'Account should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (_) {
                      _getSelectedAccountList();
                    },
                    autocompleteCallback: (pattern) async {
                      _selectedAccountTypes = [];
                      if (_selectedAccountTypesList[0]['name'] == 'All') {
                        _accountTypesList.forEach((element) {
                          _selectedAccountTypes.add(element['defaultName']);
                        });
                      } else {
                        _selectedAccountTypesList.forEach(
                          (element) {
                            _selectedAccountTypes.add(
                              element['defaultName'],
                            );
                          },
                        );
                      }
                      List accountList =
                          await _accountProvider.accountAutocomplete(
                        searchText: pattern,
                        accountType: _selectedAccountTypes,
                      );
                      if (_selectedAccountList
                          .where((element) => element['id'] == '-1')
                          .isEmpty) {
                        if (_selectedAccountList.isNotEmpty) {
                          for (int i = 0;
                              i <= _selectedAccountList.length - 1;
                              i++) {
                            accountList.removeWhere(
                              (elm) =>
                                  elm['id'] == _selectedAccountList[i]['id'],
                            );
                          }
                        }
                      }
                      return accountList;
                    },
                    onSelected: (value) {
                      _accountTextEditingController.clear();
                      setState(() {
                        if (_selectedAccountList
                            .where((element) => element['id'] == '-1')
                            .isNotEmpty) {
                          _selectedAccountList = [];
                          _selectedAccountIdList = [];
                        }
                        _selectedAccountList.add(value);
                        arguments['branchList'] = '';
                        arguments['viewReport'] = '';
                        arguments['accountList'] = '';
                        arguments['groupBy'] = '';
                        arguments['branch'] = '';
                        arguments['account'] = '';
                        arguments['accountTypes'] = '';
                        _groupByList = [];
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _allAccountSelected = true;
                            if (_selectedAccountList
                                .where((element) => element['id'] == '-1')
                                .isEmpty) {
                              _selectedAccountList = [];
                              _selectedAccountIdList = [];
                              _selectedAccountList.add(_accountData);
                              arguments['branchList'] = '';
                              arguments['viewReport'] = '';
                              arguments['accountList'] = '';
                              arguments['groupBy'] = '';
                              arguments['branch'] = '';
                              arguments['account'] = '';
                              arguments['accountTypes'] = '';
                            }
                          });
                        },
                        child: Text(
                          'ALL',
                          style: _allAccountSelected == true
                              ? TextStyle(color: Theme.of(context).primaryColor)
                              : TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      ..._selectedAccountList
                          .map(
                            (e) => Chip(
                              label: Text(
                                e['name'],
                              ),
                              labelStyle: Theme.of(context).textTheme.button,
                              backgroundColor: Theme.of(context).primaryColor,
                              deleteIcon: Icon(Icons.clear),
                              deleteIconColor:
                                  Theme.of(context).textTheme.button.color,
                              onDeleted: () {
                                setState(
                                  () {
                                    _selectedAccountList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedAccountIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedAccountList.isNotEmpty &&
                    _selectedAccountList
                        .where((element) => element['id'] == '-1')
                        .isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountOutstandingBranchContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'BRANCH INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  AutocompleteFormField(
                    autoFocus: false,
                    focusNode: _branchFocusNode,
                    controller: _branchTextEditingController,
                    labelText: 'Branch',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    validator: (value) {
                      if (value == null && _selectedBranchList.isEmpty) {
                        return 'Branch should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (_) {
                      _getSelectedBranchList();
                    },
                    autocompleteCallback: (pattern) async {
                      return getBranchList(pattern);
                    },
                    onSelected: (value) {
                      _branchTextEditingController.clear();
                      setState(() {
                        if (_selectedBranchList
                            .where((element) => element['id'] == '-1')
                            .isNotEmpty) {
                          _selectedBranchList = [];
                          _defaultBranchDeleted = true;
                          _selectedBranchIdList = [];
                        }
                        _selectedBranchList.add(value);
                        arguments['branchList'] = '';
                        arguments['viewReport'] = '';
                        arguments['accountList'] = '';
                        arguments['groupBy'] = '';
                        arguments['branch'] = '';
                        arguments['account'] = '';
                        arguments['accountTypes'] = '';
                        _groupByList = [];
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _allBranchSelected = true;
                            if (_selectedBranchList
                                .where((element) => element['id'] == '-1')
                                .isEmpty) {
                              _selectedBranchList = [];
                              _defaultBranchDeleted = true;
                              _selectedBranchIdList = [];
                              _selectedBranchList.add(_branchData);
                              arguments['branchList'] = '';
                              arguments['viewReport'] = '';
                              arguments['accountList'] = '';
                              arguments['groupBy'] = '';
                              arguments['branch'] = '';
                              arguments['account'] = '';
                              arguments['accountTypes'] = '';
                            }
                          });
                        },
                        child: Text(
                          'ALL',
                          style: _allBranchSelected == true
                              ? TextStyle(color: Theme.of(context).primaryColor)
                              : TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      ..._selectedBranchList
                          .map(
                            (e) => Chip(
                              label: Text(
                                e['name'],
                              ),
                              labelStyle: Theme.of(context).textTheme.button,
                              backgroundColor: Theme.of(context).primaryColor,
                              deleteIcon: Icon(Icons.clear),
                              deleteIconColor:
                                  Theme.of(context).textTheme.button.color,
                              onDeleted: () {
                                setState(
                                  () {
                                    if (e['id'] == _userSelectedBranch['id']) {
                                      _defaultBranchDeleted = true;
                                    }
                                    _selectedBranchList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedBranchIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedBranchList.isNotEmpty &&
                    _selectedBranchList
                        .where((element) => element['id'] == '-1')
                        .isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Outstanding',
        ),
        actions: [
          TextButton(
            onPressed: () => _onSearch(),
            child: Text(
              'SEARCH',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _accountOutstandingGeneralInfoContainer(),
                    _accountOutstandingOrderByContainer(),
                    _accountOutstandingGroupByContainer(),
                    _accountOutstandingAccountContainer(),
                    _accountOutstandingBranchContainer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
