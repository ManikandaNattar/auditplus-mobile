import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CashRegisterFormScreen extends StatefulWidget {
  @override
  _CashRegisterFormScreenState createState() => _CashRegisterFormScreenState();
}

class _CashRegisterFormScreenState extends State<CashRegisterFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  CashRegisterProvider _cashRegisterProvider;
  String cashRegisterId = '';
  String cashRegisterName = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _openingFocusNode = FocusNode();
  FocusNode _branchFocusNode = FocusNode();
  FocusNode _userFocusNode = FocusNode();
  TextEditingController _branchTextEditingController = TextEditingController();
  TextEditingController _userTextEditingController = TextEditingController();
  Map<String, dynamic> _cashRegisterDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _cashRegisterData = {};
  Map<String, dynamic> _cashRegisterPage = {};
  List _branchList = [];
  List _filterBranchList = [];
  List _userList = [];
  List _filterUserList = [];
  List _selectedUsersList = [];
  List<String> _selectedUserIdList = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _openingFocusNode.dispose();
    _branchFocusNode.dispose();
    _userFocusNode.dispose();
    _branchTextEditingController.dispose();
    _userTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _cashRegisterProvider = Provider.of<CashRegisterProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      cashRegisterId = arguments['id'];
      cashRegisterName = arguments['displayName'];
      _getCashRegister();
    }
    _getCashRegisterPage();
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getCashRegister() {
    _cashRegisterDetail = arguments['detail'];
    _branchTextEditingController.text = _cashRegisterDetail['branch']['name'];
    _selectedUsersList = _cashRegisterDetail['users'];
    return _cashRegisterDetail;
  }

  Future<void> _getCashRegisterPage() async {
    if (_cashRegisterPage.isEmpty) {
      _cashRegisterPage = await _cashRegisterProvider.getCashRegisterPage();
      setState(() {
        _isLoading = false;
      });
    }
  }

  List _getBranchList(String query) {
    _filterBranchList = [];
    if (_branchList.isEmpty) {
      _branchList = _cashRegisterPage['branches'];
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _branchList.length - 1; i++) {
        String name = _branchList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterBranchList.add(_branchList[i]);
        }
      }
    } else {
      _filterBranchList = _branchList;
    }
    return _filterBranchList;
  }

  List _getUserList(String query) {
    _filterUserList = [];
    if (_userList.isEmpty) {
      _userList = _cashRegisterPage['users'];
    }
    if (query.isNotEmpty) {
      for (int i = 0; i <= _userList.length - 1; i++) {
        String name = _userList[i]['username'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterUserList.add(_userList[i]);
        }
      }
    } else {
      _filterUserList = _userList;
    }
    return _filterUserList;
  }

  void _getSelectedUserList() {
    if (_selectedUsersList.isNotEmpty) {
      for (int i = 0; i <= _selectedUsersList.length - 1; i++) {
        _selectedUserIdList.add(_selectedUsersList[i]['id']);
      }
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _cashRegisterData.addAll({'users': _selectedUserIdList});
      try {
        if (cashRegisterId.isEmpty) {
          await _cashRegisterProvider.createCashRegister(_cashRegisterData);
          utils.showSuccessSnackbar(
              _screenContext, 'Cash Register Created Successfully');
        } else {
          await _cashRegisterProvider.updateCashRegister(
            cashRegisterId,
            _cashRegisterData,
          );
          utils.showSuccessSnackbar(
              _screenContext, 'Cash Register updated Successfully');
        }
        Navigator.of(_screenContext)
            .pushReplacementNamed('/administration/manage/cash-register');
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _cashRegisterFormGeneralInfoContainer() {
    return Container(
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
                'GENERAL INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _cashRegisterDetail['name'],
                          focusNode: _nameFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.subtitle1,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            _nameFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_openingFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name should not be empty!';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            if (val.isNotEmpty) {
                              _cashRegisterData.addAll({'name': val});
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: _cashRegisterDetail['opening'] == null
                              ? '0.00'
                              : double.parse(
                                      _cashRegisterDetail['opening'].toString())
                                  .abs()
                                  .toStringAsFixed(2),
                          textAlign: TextAlign.end,
                          focusNode: _openingFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Opening',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.subtitle1,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            _openingFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_displayNameFocusNode);
                          },
                          onSaved: (val) {
                            if (val.isNotEmpty) {
                              _cashRegisterData
                                  .addAll({'opening': double.parse(val)});
                            }
                          },
                          validator: (value) {
                            if (double.parse(value).isNegative) {
                              utils.handleErrorResponse(
                                _screenContext,
                                'opening should not be lesser than 0',
                                'tenant',
                              );
                              return '';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _cashRegisterDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _displayNameFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_branchFocusNode);
                    },
                    onSaved: (val) {
                      _cashRegisterData.addAll({
                        'displayName':
                            val.isEmpty ? _cashRegisterData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  cashRegisterId.isEmpty
                      ? AutocompleteFormField(
                          initialValue: utils.cast<Map<String, dynamic>>(
                              _cashRegisterDetail['branch']),
                          focusNode: _branchFocusNode,
                          controller: _branchTextEditingController,
                          labelText: 'Branch',
                          labelStyle: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          autocompleteCallback: (pattern) async {
                            return _getBranchList(pattern);
                          },
                          onSaved: (val) {
                            _cashRegisterData.addAll(
                                {'branch': val == null ? null : val['id']});
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Branch should not be empty!';
                            }
                            return null;
                          },
                        )
                      : TextFormField(
                          readOnly: true,
                          initialValue: _branchTextEditingController.text,
                          decoration: InputDecoration(
                            labelText: 'Branch',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.grey),
                          onSaved: (val) {
                            _cashRegisterData.addAll(
                              {
                                'branch': _cashRegisterDetail['branch']['id'],
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cashRegisterFormUserInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTileTheme(
            dense: true,
            child: ExpansionTile(
              maintainState: true,
              title: Text(
                'USER INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              children: [
                AutocompleteFormField(
                  focusNode: _userFocusNode,
                  controller: _userTextEditingController,
                  labelText: 'User',
                  suggestionFormatter: (suggestion) => suggestion['username'],
                  textFormatter: (selection) => selection['username'],
                  validator: null,
                  onSaved: (_) {
                    _getSelectedUserList();
                  },
                  autocompleteCallback: (pattern) async {
                    return _getUserList(pattern);
                  },
                  onSelected: (value) {
                    _userTextEditingController.clear();
                    setState(() {
                      _selectedUsersList.removeWhere(
                          (element) => element['id'] == value['id']);
                      _selectedUsersList.add(value);
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Wrap(
                      spacing: 5.0,
                      children: [
                        ..._selectedUsersList
                            .map(
                              (e) => Chip(
                                label: Text(
                                  e['displayName'],
                                ),
                                labelStyle: Theme.of(context).textTheme.button,
                                backgroundColor: Theme.of(context).primaryColor,
                                deleteIcon: Icon(Icons.clear),
                                deleteIconColor:
                                    Theme.of(context).textTheme.button.color,
                                onDeleted: () {
                                  setState(
                                    () {
                                      _selectedUsersList.removeWhere(
                                          (element) =>
                                              element['id'] == e['id']);
                                      _selectedUserIdList.remove(e['id']);
                                    },
                                  );
                                },
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  visible: _selectedUsersList.isNotEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            cashRegisterName.isEmpty ? 'Add Cash Register' : cashRegisterName,
          ),
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
          builder: (context) {
            _screenContext = context;
            return _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _cashRegisterFormGeneralInfoContainer(),
                            _cashRegisterFormUserInfoContainer(),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
      onWillPop: () async {
        utils.showAlertDialog(
          context,
          () => Navigator.of(context).pop(),
          'Discard Changes?',
          'Changes will be discarded once you leave this page',
        );
        return true;
      },
    );
  }
}
