import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/vendor_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorOutstandingForm extends StatefulWidget {
  @override
  _VendorOutstandingFormState createState() => _VendorOutstandingFormState();
}

enum ViewReport { Consolidate, Summary, Detail }

enum GroupByReport { Branch, Vendor }

class _VendorOutstandingFormState extends State<VendorOutstandingForm> {
  ViewReport _viewReport = ViewReport.Consolidate;
  GroupByReport _groupByReport = GroupByReport.Branch;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TenantAuth _tenantAuth;
  VendorProvider _vendorProvider;
  FocusNode _vendorFocusNode = FocusNode();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _vendorTextEditingController = TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  List _selectedvendorList = [];
  List<String> _selectedVendorIdList = [];
  List<Map<String, dynamic>> _selectedBranchList = [];
  List<String> _selectedBranchIdList = [];
  Map _userSelectedBranch = {};
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  Map arguments = {};
  bool _allBranchSelected = false;
  bool _allVendorSelected = false;
  Map<String, dynamic> _branchData = {
    'id': '-1',
    'name': 'All Branch',
    'displayName': 'All Branch',
  };
  Map<String, dynamic> _vendorData = {
    'id': '-1',
    'name': 'All Vendor',
    'displayName': 'All Vendor',
  };
  bool _defaultBranchDeleted = false;

  @override
  void initState() {
    _selectedvendorList.add(_vendorData);
    super.initState();
  }

  @override
  void dispose() {
    _vendorFocusNode.dispose();
    _branchFocusNode.dispose();
    _branchTextEditingController.dispose();
    _vendorTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _tenantAuth = Provider.of<TenantAuth>(context);
    _vendorProvider = Provider.of<VendorProvider>(context);
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
    _selectedvendorList = arguments['vendorList'] == ''
        ? _selectedvendorList
        : arguments['vendorList'];
    _groupByReport =
        arguments['group_by'] == '' ? _groupByReport : arguments['group_by'];
    _selectedBranchIdList =
        arguments['branch'] == '' ? _selectedBranchIdList : arguments['branch'];
    _selectedVendorIdList =
        arguments['vendor'] == '' ? _selectedVendorIdList : arguments['vendor'];
    var checkSelectedBranchAdded =
        _selectedBranchList.where((element) => element == _userSelectedBranch);
    _allBranchSelected = _selectedBranchList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    _allVendorSelected = _selectedvendorList
        .where((element) => element['id'] == '-1')
        .isNotEmpty;
    if (_userSelectedBranch['id'] != '-1' &&
        checkSelectedBranchAdded.isEmpty &&
        _defaultBranchDeleted == false) {
      _selectedBranchList.add(_userSelectedBranch);
    }
  }

  void _getSelectedVendorList() {
    if (_selectedvendorList.isNotEmpty) {
      for (int i = 0; i <= _selectedvendorList.length - 1; i++) {
        if (_selectedvendorList[i]['id'] != '-1') {
          if (_selectedVendorIdList
              .where((element) => element == _selectedvendorList[i]['id'])
              .isEmpty) {
            _selectedVendorIdList.add(_selectedvendorList[i]['id']);
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
        'vendor': _selectedVendorIdList,
        'branch': _selectedBranchIdList,
        'viewReport': _viewReport,
        'branchList': _selectedBranchList,
        'vendorList': _selectedvendorList,
      };
      Navigator.of(context).pop(_formData);
    }
  }

  Widget _vendorOutstandingGeneralInfoContainer() {
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

  Widget _vendorOutstandingVendorContainer() {
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
                'VENDOR INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  AutocompleteFormField(
                    autoFocus: false,
                    focusNode: _vendorFocusNode,
                    controller: _vendorTextEditingController,
                    labelText: 'Vendor',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    validator: (value) {
                      if (value == null && _selectedvendorList.isEmpty) {
                        return 'Vendor should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (_) {
                      _getSelectedVendorList();
                    },
                    autocompleteCallback: (pattern) async {
                      List vendorList =
                          await _vendorProvider.vendorAutoComplete(
                        searchText: pattern,
                      );
                      if (_selectedvendorList.isNotEmpty) {
                        for (int i = 0;
                            i <= _selectedvendorList.length - 1;
                            i++) {
                          vendorList.removeWhere(
                            (elm) => elm['id'] == _selectedvendorList[i]['id'],
                          );
                        }
                      }
                      vendorList.add(_vendorData);
                      return vendorList;
                    },
                    onSelected: (value) {
                      _vendorTextEditingController.clear();
                      setState(() {
                        if (_selectedvendorList
                            .where((element) => element['id'] == '-1')
                            .isNotEmpty) {
                          _selectedvendorList = [];
                          _selectedVendorIdList = [];
                        }
                        _selectedvendorList.add(value);
                        arguments['branchList'] = '';
                        arguments['viewReport'] = '';
                        arguments['vendorList'] = '';
                        arguments['group_by'] = '';
                        arguments['branch'] = '';
                        arguments['vendor'] = '';
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
                            _allVendorSelected = true;
                            if (_selectedvendorList
                                .where((element) => element['id'] == '-1')
                                .isEmpty) {
                              _selectedvendorList = [];
                              _selectedVendorIdList = [];
                              _selectedvendorList.add(_vendorData);
                              arguments['branchList'] = '';
                              arguments['viewReport'] = '';
                              arguments['vendorList'] = '';
                              arguments['group_by'] = '';
                              arguments['branch'] = '';
                              arguments['vendor'] = '';
                            }
                          });
                        },
                        child: Text(
                          'ALL',
                          style: _allVendorSelected == true
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
                      ..._selectedvendorList
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
                                    _selectedvendorList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedVendorIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedvendorList.isNotEmpty &&
                    _selectedvendorList
                        .where((element) => element['id'] == '-1')
                        .isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vendorOutstandingBranchContainer() {
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
                        arguments['vendorList'] = '';
                        arguments['group_by'] = '';
                        arguments['branch'] = '';
                        arguments['vendor'] = '';
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
                              arguments['vendorList'] = '';
                              arguments['group_by'] = '';
                              arguments['branch'] = '';
                              arguments['vendor'] = '';
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
          'Vendor Outstanding',
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
                _vendorOutstandingGeneralInfoContainer(),
                _vendorOutstandingVendorContainer(),
                _vendorOutstandingBranchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
