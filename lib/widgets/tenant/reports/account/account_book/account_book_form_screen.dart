import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../../../providers/accounting/account_provider.dart';
import './../../../../shared/date_picker_form_field.dart';
import './../../../../shared/autocomplete_form_field.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class AccountBookFormScreen extends StatefulWidget {
  @override
  _AccountBookFormScreenState createState() => _AccountBookFormScreenState();
}

class _AccountBookFormScreenState extends State<AccountBookFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _fromDateFieldController = TextEditingController();
  TextEditingController _toDateFieldController = TextEditingController();
  TextEditingController _accountTextEditingController = TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  TenantAuth _tenantAuth;
  AccountProvider _accountProvider;
  List<Map<String, dynamic>> _selectedBranchList = [];
  List _selectedBranchIdList = [];
  Map _userSelectedBranch = {};
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  bool _defaultBranchDeleted = false;
  Map arguments = {};
  Map accountData = {};
  String fromDate = '';
  String toDate = '';
  bool _allBranchSelected = false;
  List<String> accountTypes = [];
  Map<String, dynamic> _branchData = {
    'id': '-1',
    'name': 'All Branch',
    'displayName': 'All Branch',
  };

  @override
  void initState() {
    _checkMenuAccess();
    super.initState();
  }

  @override
  void dispose() {
    _branchTextEditingController.dispose();
    _branchFocusNode.dispose();
    super.dispose();
  }

  void _checkMenuAccess() {
    if (utils.checkMenuWiseAccess(
      context,
      [
        'rpt.ac.acbk',
        'rpt.ac.eftacbk',
        'rpt.cus.cusbk',
        'rpt.vend.vendbk',
      ],
    )) {
      accountTypes = null;
    } else {
      if (utils.checkMenuWiseAccess(
        context,
        [
          'rpt.ac.eftacbk',
        ],
      )) {
        accountTypes.add(
          'EFT_ACCOUNT',
        );
      }
      if (utils.checkMenuWiseAccess(
        context,
        [
          'rpt.cus.cusbk',
        ],
      )) {
        accountTypes.add(
          'TRADE_RECEIVABLE',
        );
      }
      if (utils.checkMenuWiseAccess(
        context,
        [
          'rpt.vend.vendbk',
        ],
      )) {
        accountTypes.add(
          'TRADE_PAYABLE',
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accountProvider = Provider.of<AccountProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    _assignedBranches = _tenantAuth.assignedBranches;
    arguments = ModalRoute.of(context).settings.arguments;
    _getFormData();
  }

  void _getFormData() {
    _fromDateFieldController.text = _fromDateFieldController.text.isEmpty
        ? arguments['fromDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : arguments['fromDate']
        : _fromDateFieldController.text;
    _toDateFieldController.text = _toDateFieldController.text.isEmpty
        ? arguments['toDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : arguments['toDate']
        : _toDateFieldController.text;
    _accountTextEditingController.text = arguments['account'] == ''
        ? _accountTextEditingController.text
        : arguments['account']['name'];
    _accountTextEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _accountTextEditingController.text.length,
      ),
    );
    _defaultBranchDeleted = arguments['branchList'] == ''
        ? _defaultBranchDeleted
        : _selectedBranchList
            .where((element) => element == _userSelectedBranch)
            .isEmpty;
    _selectedBranchList = arguments['branchList'] == ''
        ? _selectedBranchList
        : arguments['branchList'];
    _selectedBranchIdList =
        arguments['branch'] == '' ? _selectedBranchIdList : arguments['branch'];
    var checkSelectedBranchAdded =
        _selectedBranchList.where((element) => element == _userSelectedBranch);
    _allBranchSelected = _selectedBranchList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    if (_userSelectedBranch['id'] != '-1' &&
        checkSelectedBranchAdded.isEmpty &&
        _defaultBranchDeleted == false) {
      _selectedBranchList.add(_userSelectedBranch);
    }
  }

  void _onSearch() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _formData = {
        'account': accountData,
        'fromDate': fromDate,
        'toDate': toDate,
        'branchList': _selectedBranchList,
        'branch': _selectedBranchIdList,
      };
      Navigator.of(context).pop(_formData);
    }
  }

  void _getSelectedBranchList() {
    if (_selectedBranchList.isNotEmpty) {
      if (_selectedBranchList[0]['id'] == '-1') {
        _selectedBranchIdList = _assignedBranches
            .where((elm) => true)
            .map((item) => item['id'])
            .toList();
      } else {
        for (int i = 0; i <= _selectedBranchList.length - 1; i++) {
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

  Widget _accountBookFormDateContainer() {
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
                'DATE INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              DatePickerFormField(
                title: 'From Date',
                controller: _fromDateFieldController,
                onSaved: (value) {
                  fromDate = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              DatePickerFormField(
                title: 'To Date',
                controller: _toDateFieldController,
                onSaved: (value) {
                  toDate = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountBookFormAccountContainer() {
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
              AutocompleteFormField(
                initialValue:
                    utils.cast<Map<String, dynamic>>(arguments['account']),
                autoFocus: false,
                controller: _accountTextEditingController,
                labelText: 'Account',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['displayName'],
                autocompleteCallback: (pattern) async {
                  return await _accountProvider.accountAutocomplete(
                    searchText: pattern,
                    accountType: accountTypes,
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'Account should not be empty!';
                  }
                  return null;
                },
                onSaved: (selection) {
                  accountData = selection;
                },
                onSelected: (val) {
                  if (val != null) {
                    arguments['account'] = '';
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountBookFormBranchContainer() {
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
                        arguments['account'] = '';
                        arguments['fromDate'] = '';
                        arguments['toDate'] = '';
                        arguments['branchList'] = '';
                        arguments['branch'] = '';
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
                              arguments['account'] = '';
                              arguments['fromDate'] = '';
                              arguments['toDate'] = '';
                              arguments['branchList'] = '';
                              arguments['branch'] = '';
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
          'Account Book',
        ),
        actions: [
          TextButton(
            onPressed: () => _onSearch(),
            child: Text(
              'SEARCH',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _accountBookFormDateContainer(),
                _accountBookFormAccountContainer(),
                _accountBookFormBranchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
