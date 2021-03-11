import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class BranchAssignUsersScreen extends StatefulWidget {
  @override
  _BranchAssignUsersScreenState createState() =>
      _BranchAssignUsersScreenState();
}

class _BranchAssignUsersScreenState extends State<BranchAssignUsersScreen> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTextEditingController = TextEditingController();
  FocusNode _userFocusNode = FocusNode();
  UserProvider _userProvider;
  BranchProvider _branchProvider;
  Map arguments = {};
  Map branchDetail = {};
  String branchId = '';
  String branchName = '';
  List _branchAssignUsersList = [];
  List<String> _assignUsers = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _userFocusNode.dispose();
    _userTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _branchProvider = Provider.of<BranchProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getBranchAssignUsersList();
    super.didChangeDependencies();
  }

  Future<List> _getBranchAssignUsersList() async {
    branchId = arguments['id'];
    branchName = arguments['displayName'];
    branchDetail = arguments['detail'];
    if (_branchAssignUsersList.isEmpty) {
      _branchAssignUsersList = branchDetail['users'];
    }
    setState(() {
      _isLoading = false;
    });
    return _branchAssignUsersList;
  }

  Future<void> _onSubmit() async {
    try {
      if (_branchAssignUsersList.isNotEmpty) {
        for (int i = 0; i <= _branchAssignUsersList.length - 1; i++) {
          _assignUsers.add(_branchAssignUsersList[i]['id']);
        }
      }
      await _branchProvider.assignUsers(branchId, _assignUsers);
      utils.showSuccessSnackbar(_screenContext, 'Users Assigned Successfully');
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).pop(arguments),
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _showAssignUsers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Wrap(
              spacing: 5.0,
              children: [
                ..._branchAssignUsersList
                    .map(
                      (e) => Chip(
                        label: Text(
                          e['username'],
                        ),
                        labelStyle: Theme.of(context).textTheme.button,
                        backgroundColor: Theme.of(context).primaryColor,
                        deleteIcon: Icon(Icons.clear),
                        deleteIconColor:
                            Theme.of(context).textTheme.button.color,
                        onDeleted: () {
                          setState(
                            () {
                              _branchAssignUsersList.removeWhere(
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

  Widget _showUserForm() {
    return Form(
      key: _formKey,
      child: AutocompleteFormField(
        focusNode: _userFocusNode,
        controller: _userTextEditingController,
        labelText: 'User',
        suggestionFormatter: (suggestion) => suggestion['username'],
        textFormatter: (selection) => selection['username'],
        autocompleteCallback: (pattern) async {
          List data = await _userProvider.userAutoComplete(searchText: pattern);
          if (_branchAssignUsersList.isNotEmpty) {
            for (int i = 0; i <= _branchAssignUsersList.length - 1; i++) {
              data.removeWhere(
                (elm) => elm['id'] == _branchAssignUsersList[i]['id'],
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
              _branchAssignUsersList.add(val);
            },
          );
          _userTextEditingController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Users'),
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
                                    'USER INFO',
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
                                      _showUserForm(),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      _showAssignUsers(),
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
