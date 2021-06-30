import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/account_reports_provider.dart';
import 'package:auditplusmobile/providers/reports/inventory_reports_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'autocomplete_form_field.dart';
import 'date_picker_form_field.dart';
import './../../utils.dart' as utils;
import './../../constants.dart' as constants;
import 'progress_loader.dart';

Future<dynamic> showGenerationReportForm({
  BuildContext context,
  String menuName,
  List reportBranchList,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: GenerateReportForm(
          menuName,
          reportBranchList,
        ),
      );
    },
  );
}

class GenerateReportForm extends StatefulWidget {
  final String menuName;
  final List reportBranchList;
  GenerateReportForm(
    this.menuName,
    this.reportBranchList,
  );
  @override
  _GenerateReportFormState createState() => _GenerateReportFormState();
}

class _GenerateReportFormState extends State<GenerateReportForm> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _asOnDateFieldController = TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  TenantAuth _tenantAuth;
  AccountReportsProvider _accountReportsProvider;
  InventoryReportsProvider _inventoryReportsProvider;
  List _selectedBranchList = [];
  List _selectedBranchIdList = [];
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  Map _userSelectedBranch = {};
  Map<String, dynamic> _generateData = {};
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _inventoryReportsProvider = Provider.of<InventoryReportsProvider>(context);
    _accountReportsProvider = Provider.of<AccountReportsProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    _assignedBranches = _tenantAuth.assignedBranches;
    _selectedBranchList = widget.reportBranchList == null
        ? [_userSelectedBranch]
        : widget.reportBranchList;
    _asOnDateFieldController.text = _asOnDateFieldController.text.isEmpty
        ? constants.defaultDate.format(DateTime.now())
        : _asOnDateFieldController.text;
    super.didChangeDependencies();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> responseData = {};
      try {
        if (widget.menuName.contains('STOCK ANALYSIS')) {
          _generateData.addAll(
            {
              'branches': _selectedBranchIdList,
            },
          );
          await _inventoryReportsProvider
              .generateStockAnalysisReport(_generateData);
        } else {
          responseData = await _accountReportsProvider
              .generateAccountOutstandingReport(_generateData);
        }
        _isLoading = false;
        Navigator.of(_screenContext).pop(responseData);
      } catch (error) {
        _isLoading = false;
        Navigator.of(_screenContext).pop();
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  void _getSelectedBranchList() {
    if (_selectedBranchList.isNotEmpty) {
      for (int i = 0; i <= _selectedBranchList.length - 1; i++) {
        if (_selectedBranchIdList
            .where((element) => element == _selectedBranchList[i]['id'])
            .isEmpty) {
          _selectedBranchIdList.add(_selectedBranchList[i]['id']);
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

  Widget _generateReportFormContainer() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            DatePickerFormField(
              title: 'AsOn',
              controller: _asOnDateFieldController,
              onSaved: (value) {
                _generateData.addAll(
                  {
                    'date': constants.isoDateFormat.format(
                      constants.defaultDate.parse(
                        value,
                      ),
                    ),
                  },
                );
              },
            ),
            Visibility(
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  _branchContainer(),
                ],
              ),
              visible: widget.menuName.contains(
                'STOCK ANALYSIS',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
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
                _selectedBranchList.add(value);
              });
            },
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
            visible: _selectedBranchList.isNotEmpty,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        _screenContext = context;
        return Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      'GENERATE ${widget.menuName}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.save,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _onSubmit();
                      },
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  _generateReportFormContainer(),
                ],
              ),
              Visibility(
                child: ProgressLoader(
                  message: 'Generating Report.please wait...',
                ),
                visible: _isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
