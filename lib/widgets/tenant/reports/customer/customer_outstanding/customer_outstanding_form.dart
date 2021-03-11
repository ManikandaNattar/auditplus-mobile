import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/customer_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOutstandingFormScreen extends StatefulWidget {
  @override
  _CustomerOutstandingFormScreenState createState() =>
      _CustomerOutstandingFormScreenState();
}

enum ViewReport {
  Consolidate,
  Summary,
  Detail,
}

enum GroupByReport {
  Branch,
  Customer,
}

class _CustomerOutstandingFormScreenState
    extends State<CustomerOutstandingFormScreen> {
  ViewReport _viewReport = ViewReport.Consolidate;
  GroupByReport _groupByReport = GroupByReport.Branch;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TenantAuth _tenantAuth;
  CustomerProvider _customerProvider;
  FocusNode _customerFocusNode = FocusNode();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _customerTextEditingController =
      TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  List _selectedCustomerList = [];
  List<String> _selectedCustomerIdList = [];
  List<Map<String, dynamic>> _selectedBranchList = [];
  List<String> _selectedBranchIdList = [];
  Map _userSelectedBranch = {};
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  Map arguments = {};
  bool _allBranchSelected = false;
  bool _allCustomerSelected = false;
  Map<String, dynamic> _branchData = {
    'id': '-1',
    'name': 'All Branch',
    'displayName': 'All Branch',
  };
  Map<String, dynamic> _customerData = {
    'id': '-1',
    'name': 'All Customer',
    'displayName': 'All Customer',
  };
  bool _defaultBranchDeleted = false;

  @override
  void initState() {
    _selectedCustomerList.add(_customerData);
    super.initState();
  }

  @override
  void dispose() {
    _customerFocusNode.dispose();
    _branchFocusNode.dispose();
    _branchTextEditingController.dispose();
    _customerTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _tenantAuth = Provider.of<TenantAuth>(context);
    _customerProvider = Provider.of<CustomerProvider>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    _assignedBranches = _tenantAuth.assignedBranches;
    arguments = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _defaultBranchDeleted = arguments['branchList'] == ''
        ? _defaultBranchDeleted
        : _selectedBranchList
            .where((element) => element == _userSelectedBranch)
            .isEmpty;
    _viewReport =
        arguments['viewReport'] == '' ? _viewReport : arguments['viewReport'];
    _selectedBranchList = arguments['branchList'] == ''
        ? _selectedBranchList
        : arguments['branchList'];
    _selectedCustomerList = arguments['customerList'] == ''
        ? _selectedCustomerList
        : arguments['customerList'];
    _groupByReport =
        arguments['group_by'] == '' ? _groupByReport : arguments['group_by'];
    _selectedBranchIdList =
        arguments['branch'] == '' ? _selectedBranchIdList : arguments['branch'];
    _selectedCustomerIdList = arguments['customer'] == ''
        ? _selectedCustomerIdList
        : arguments['customer'];
    var checkSelectedBranchAdded =
        _selectedBranchList.where((element) => element == _userSelectedBranch);
    _allBranchSelected = _selectedBranchList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    _allCustomerSelected = _selectedCustomerList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    if (_userSelectedBranch['id'] != '-1' &&
        checkSelectedBranchAdded.isEmpty &&
        _defaultBranchDeleted == false) {
      _selectedBranchList.add(_userSelectedBranch);
    }
  }

  void _getSelectedCustomerList() {
    if (_selectedCustomerList.isNotEmpty) {
      for (int i = 0; i <= _selectedCustomerList.length - 1; i++) {
        if (_selectedCustomerList[i]['id'] != '-1') {
          if (_selectedCustomerIdList
              .where((element) => element == _selectedCustomerList[i]['id'])
              .isEmpty) {
            _selectedCustomerIdList.add(_selectedCustomerList[i]['id']);
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
        'group_by': _groupByReport,
        'customer': _selectedCustomerIdList,
        'branch': _selectedBranchIdList,
        'viewReport': _viewReport,
        'branchList': _selectedBranchList,
        'customerList': _selectedCustomerList,
      };
      Navigator.of(context).pop(_formData);
    }
  }

  Widget _customerOutstandingGeneralInfoContainer() {
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
                'GENERAL INFO',
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
                      'View',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: DropdownButton<ViewReport>(
                      isExpanded: true,
                      value: _viewReport,
                      onChanged: (ViewReport newValue) {
                        setState(() {
                          _viewReport = newValue;
                        });
                      },
                      items: ViewReport.values.map(
                        (ViewReport viewReport) {
                          return DropdownMenuItem<ViewReport>(
                            value: viewReport,
                            child: Text(
                              viewReport.toString().split('.').last,
                              style: TextStyle(
                                color: viewReport == _viewReport
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Group By',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: DropdownButton<GroupByReport>(
                      isExpanded: true,
                      value: _groupByReport,
                      onChanged: (GroupByReport newValue) {
                        setState(() {
                          _groupByReport = newValue;
                        });
                      },
                      items: GroupByReport.values.map(
                        (GroupByReport groupByReport) {
                          return DropdownMenuItem<GroupByReport>(
                            value: groupByReport,
                            child: Text(
                              groupByReport.toString().split('.').last,
                              style: TextStyle(
                                color: groupByReport == _groupByReport
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

  Widget _customerOutstandingCustomerContainer() {
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
                'CUSTOMER INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  AutocompleteFormField(
                    autoFocus: false,
                    focusNode: _customerFocusNode,
                    controller: _customerTextEditingController,
                    labelText: 'Customer',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    validator: (value) {
                      if (value == null && _selectedCustomerList.isEmpty) {
                        return 'Customer should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (_) {
                      _getSelectedCustomerList();
                    },
                    autocompleteCallback: (pattern) async {
                      List customerList =
                          await _customerProvider.customerAutoComplete(
                        searchText: pattern,
                      );
                      if (_selectedCustomerList
                          .where((element) => element['id'] == '-1')
                          .isEmpty) {
                        if (_selectedCustomerList.isNotEmpty) {
                          for (int i = 0;
                              i <= _selectedCustomerList.length - 1;
                              i++) {
                            customerList.removeWhere(
                              (elm) =>
                                  elm['id'] == _selectedCustomerList[i]['id'],
                            );
                          }
                        }
                      }
                      return customerList;
                    },
                    onSelected: (value) {
                      _customerTextEditingController.clear();
                      setState(() {
                        if (_selectedCustomerList
                            .where((element) => element['id'] == '-1')
                            .isNotEmpty) {
                          _selectedCustomerList = [];
                          _selectedCustomerIdList = [];
                        }
                        _selectedCustomerList.add(value);
                        arguments['branchList'] = '';
                        arguments['viewReport'] = '';
                        arguments['customerList'] = '';
                        arguments['group_by'] = '';
                        arguments['branch'] = '';
                        arguments['customer'] = '';
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
                            _allCustomerSelected = true;
                            if (_selectedCustomerList
                                .where((element) => element['id'] == '-1')
                                .isEmpty) {
                              _selectedCustomerList = [];
                              _selectedCustomerIdList = [];
                              _selectedCustomerList.add(_customerData);
                              arguments['branchList'] = '';
                              arguments['viewReport'] = '';
                              arguments['customerList'] = '';
                              arguments['group_by'] = '';
                              arguments['branch'] = '';
                              arguments['customer'] = '';
                            }
                          });
                        },
                        child: Text(
                          'ALL',
                          style: _allCustomerSelected == true
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
                      ..._selectedCustomerList
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
                                    _selectedCustomerList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedCustomerIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedCustomerList.isNotEmpty &&
                    _selectedCustomerList
                        .where((element) => element['id'] == '-1')
                        .isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customerOutstandingBranchContainer() {
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
                        arguments['customerList'] = '';
                        arguments['group_by'] = '';
                        arguments['branch'] = '';
                        arguments['customer'] = '';
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
                              arguments['customerList'] = '';
                              arguments['group_by'] = '';
                              arguments['branch'] = '';
                              arguments['customer'] = '';
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
          'Customer Outstanding',
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customerOutstandingGeneralInfoContainer(),
                _customerOutstandingCustomerContainer(),
                _customerOutstandingBranchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
