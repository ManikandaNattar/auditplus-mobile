import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class BranchAssignDesktopClientsScreen extends StatefulWidget {
  @override
  _BranchAssignDesktopClientsScreenState createState() =>
      _BranchAssignDesktopClientsScreenState();
}

class _BranchAssignDesktopClientsScreenState
    extends State<BranchAssignDesktopClientsScreen> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _desktopClientTextEditingController =
      TextEditingController();
  FocusNode _desktopClientFocusNode = FocusNode();
  DesktopClientProvider _desktopClientProvider;
  BranchProvider _branchProvider;
  Map arguments = {};
  Map branchDetail = {};
  String branchId = '';
  String branchName = '';
  List _branchAssignClientsList = [];
  List<String> _assignClients = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _desktopClientFocusNode.dispose();
    _desktopClientTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    _branchProvider = Provider.of<BranchProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getBranchAssignClientsList();
    super.didChangeDependencies();
  }

  Future<List> _getBranchAssignClientsList() async {
    branchId = arguments['id'];
    branchName = arguments['displayName'];
    branchDetail = arguments['detail'];
    if (_branchAssignClientsList.isEmpty) {
      _branchAssignClientsList = branchDetail['desktopClients'];
    }
    setState(() {
      _isLoading = false;
    });
    return _branchAssignClientsList;
  }

  Future<void> _onSubmit() async {
    try {
      if (_branchAssignClientsList.isNotEmpty) {
        for (int i = 0; i <= _branchAssignClientsList.length - 1; i++) {
          _assignClients.add(_branchAssignClientsList[i]['id']);
        }
      }
      await _branchProvider.assignDesktopClients(branchId, _assignClients);
      utils.showSuccessSnackbar(
          _screenContext, 'Clients Assigned Successfully');
      Navigator.of(context).pop(arguments);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _showAssignClients() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Wrap(
              spacing: 5.0,
              children: [
                ..._branchAssignClientsList
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
                              _branchAssignClientsList.removeWhere(
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

  Widget _showClientForm() {
    return Form(
      key: _formKey,
      child: AutocompleteFormField(
        autoFocus: false,
        focusNode: _desktopClientFocusNode,
        controller: _desktopClientTextEditingController,
        labelText: 'Desktop Client',
        suggestionFormatter: (suggestion) => suggestion['name'],
        textFormatter: (selection) => selection['name'],
        autocompleteCallback: (pattern) async {
          List data = await _desktopClientProvider.desktopClientAutoComplete(
              searchText: pattern);
          if (_branchAssignClientsList.isNotEmpty) {
            for (int i = 0; i <= _branchAssignClientsList.length - 1; i++) {
              data.removeWhere(
                (elm) => elm['id'] == _branchAssignClientsList[i]['id'],
              );
            }
          }
          return data;
        },
        onSaved: () {},
        validator: null,
        onSelected: (val) {
          setState(
            () {
              _branchAssignClientsList.add(val);
            },
          );
          _desktopClientTextEditingController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Clients'),
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
                            branchName.toUpperCase(),
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
                                    'DESKTOP CLIENT INFO',
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
                                      _showClientForm(),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      _showAssignClients(),
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
