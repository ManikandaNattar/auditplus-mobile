import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class DesktopClientAssignBranchesScreen extends StatefulWidget {
  @override
  _DesktopClientAssignBranchesScreenState createState() =>
      _DesktopClientAssignBranchesScreenState();
}

class _DesktopClientAssignBranchesScreenState
    extends State<DesktopClientAssignBranchesScreen> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _branchTextEditingController = TextEditingController();
  FocusNode _branchFocusNode = FocusNode();
  DesktopClientProvider _desktopClientProvider;
  BranchProvider _branchProvider;
  Map arguments = {};
  String desktopClientId = '';
  String desktopClientName = '';
  List _desktopClientAssignbranchesList = [];
  List<String> _assignBranches = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _branchFocusNode.dispose();
    _branchTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    _branchProvider = Provider.of<BranchProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getDesktopClientAssignBranchesList();
    super.didChangeDependencies();
  }

  Future<List> _getDesktopClientAssignBranchesList() async {
    desktopClientId = arguments['id'];
    desktopClientName = arguments['displayName'];
    if (_desktopClientAssignbranchesList.isEmpty) {
      _desktopClientAssignbranchesList = await _desktopClientProvider
          .getClientAssignedBranches(desktopClientId);
    }
    setState(() {
      _isLoading = false;
    });
    return _desktopClientAssignbranchesList;
  }

  Future<void> _onSubmit() async {
    try {
      if (_desktopClientAssignbranchesList.isNotEmpty) {
        for (int i = 0; i <= _desktopClientAssignbranchesList.length - 1; i++) {
          _assignBranches.add(_desktopClientAssignbranchesList[i]['id']);
        }
      }
      await _desktopClientProvider.assignBranches(
        desktopClientId,
        _assignBranches,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Branches Assigned Successfully');
      Navigator.of(context).pop(arguments);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _showAssignBranches() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Wrap(
              spacing: 5.0,
              children: [
                ..._desktopClientAssignbranchesList
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
                              _desktopClientAssignbranchesList.removeWhere(
                                  (element) => e['id'] == element['id']);
                            },
                          );
                        },
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showBranchForm() {
    return Form(
      key: _formKey,
      child: AutocompleteFormField(
        focusNode: _branchFocusNode,
        controller: _branchTextEditingController,
        labelText: 'Branch',
        suggestionFormatter: (suggestion) => suggestion['name'],
        textFormatter: (selection) => selection['name'],
        autocompleteCallback: (pattern) async {
          List data = await _branchProvider.branchAutoComplete(
            searchText: pattern,
          );
          if (_desktopClientAssignbranchesList.isNotEmpty) {
            for (int i = 0;
                i <= _desktopClientAssignbranchesList.length - 1;
                i++) {
              data.removeWhere((elm) =>
                  elm['id'] == _desktopClientAssignbranchesList[i]['id']);
            }
          }
          return data;
        },
        onSaved: () {},
        validator: null,
        onSelected: (val) {
          setState(
            () {
              _desktopClientAssignbranchesList.add(val);
            },
          );
          _branchTextEditingController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Branches'),
        actions: [
          TextButton(
            onPressed: () {
              _onSubmit();
            },
            child: Text(
              'SAVE',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          _screenContext = context;
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: _isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            desktopClientName.toUpperCase(),
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 10.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 0.0,
                                  ),
                                  child: Text(
                                    'BRANCH INFO',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: Column(
                                    children: [
                                      _showBranchForm(),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      _showAssignBranches(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
