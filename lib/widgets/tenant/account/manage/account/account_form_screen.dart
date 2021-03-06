import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/inventory/customer_provider.dart';
import 'package:auditplusmobile/providers/inventory/vendor_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountFormScreen extends StatefulWidget {
  @override
  _AccountFormScreenState createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  AccountProvider _accountProvider;
  VendorProvider _vendorProvider;
  CustomerProvider _customerProvider;
  String accountId = '';
  String accountName = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _parentAccountFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _typeFocusNode = FocusNode();
  FocusNode _vendorFocusNode = FocusNode();
  FocusNode _customerFocusNode = FocusNode();
  TextEditingController _parentAccountTextEditingController =
      TextEditingController();
  TextEditingController _typeTextEditingController = TextEditingController();
  TextEditingController _vendorTextEditingController = TextEditingController();
  TextEditingController _customerTextEditingController =
      TextEditingController();
  Map<String, dynamic> _accountDetail = {};
  Map arguments = {};
  Map<String, dynamic> _accountData = {};
  List _accountTypeList = [];
  List _filterAccountTypeList = [];
  List<String> _selectedAccountTypes = [];
  String name = '';

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _parentAccountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _parentAccountTextEditingController.dispose();
    _typeTextEditingController.dispose();
    _typeFocusNode.dispose();
    _customerFocusNode.dispose();
    _vendorFocusNode.dispose();
    _customerTextEditingController.dispose();
    _vendorTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    _vendorProvider = Provider.of<VendorProvider>(context);
    _customerProvider = Provider.of<CustomerProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        accountId = arguments['id'];
        accountName = arguments['displayName'];
        _getAccount();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getAccount() {
    _accountDetail = arguments['detail'];
    _parentAccountTextEditingController.text =
        _accountDetail['parentAccount'] == null
            ? ''
            : _accountDetail['parentAccount']['name'];
    _typeTextEditingController.text = _accountDetail['accountType'] == null
        ? ''
        : _accountDetail['accountType']['name'];
    _selectedAccountTypes.add(_accountDetail['accountType']['defaultName']);
    return _accountDetail;
  }

  Future<List> _getAccountTypeList(String query) async {
    _filterAccountTypeList.clear();
    if (_accountTypeList.isEmpty) {
      _accountTypeList = await _accountProvider.getAccountType();
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _accountTypeList.length - 1; i++) {
        String name = _accountTypeList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .startsWith(query.toLowerCase())) {
          _filterAccountTypeList.add(_accountTypeList[i]);
        }
      }
    } else {
      _filterAccountTypeList = _accountTypeList;
    }
    return _filterAccountTypeList;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _accountData.addAll({'tdsApplicable': false});
      Map<String, dynamic> responseData = {};
      try {
        if (accountId.isEmpty) {
          responseData = await _accountProvider.createAccount(_accountData);
          utils.showSuccessSnackbar(
              _screenContext, 'Account Created Successfully');
        } else {
          await _accountProvider.updateAccount(accountId, _accountData);
          utils.showSuccessSnackbar(
              _screenContext, 'Account updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Navigator.of(_screenContext)
              .pushReplacementNamed('/accounts/manage/account');
        } else {
          arguments['routeFormArguments'] = responseData;
          Navigator.of(_screenContext).pop(
            arguments,
          );
        }
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _accountFormGeneralInfoContainer() {
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
                  accountId.isEmpty
                      ? AutocompleteFormField(
                          initialValue: utils.cast<Map<String, dynamic>>(
                            _accountDetail['accountType'],
                          ),
                          autoFocus: false,
                          focusNode: _typeFocusNode,
                          controller: _typeTextEditingController,
                          autocompleteCallback: (pattern) {
                            return _getAccountTypeList(
                              pattern,
                            );
                          },
                          validator: (val) {
                            if (val == null) {
                              return 'Type should not be empty!';
                            }
                            return null;
                          },
                          labelText: 'Account Type',
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          onSaved: (val) {
                            _accountData.addAll(
                              {
                                'accountType':
                                    val == null ? null : val['defaultName']
                              },
                            );
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedAccountTypes.clear();
                              _selectedAccountTypes.add(value['defaultName']);
                            });
                          },
                          labelStyle: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        )
                      : TextFormField(
                          readOnly: true,
                          initialValue: _typeTextEditingController.text,
                          decoration: InputDecoration(
                            labelText: 'Type',
                            labelStyle: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.grey),
                          onSaved: (val) {
                            _accountData.addAll(
                              {
                                'accountType': _accountDetail['accountType']
                                    ['defaultName']
                              },
                            );
                          },
                        ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: name.isEmpty ? _accountDetail['name'] : name,
                    focusNode: _nameFocusNode,
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
                      FocusScope.of(context).requestFocus(_aliasNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _accountData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _accountDetail['aliasName']
                        .toString()
                        .replaceAll('null', ''),
                    focusNode: _aliasNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Alias Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _aliasNameFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _accountData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _accountDetail['displayName'],
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
                      FocusScope.of(context)
                          .requestFocus(_parentAccountFocusNode);
                    },
                    onSaved: (val) {
                      _accountData.addAll({
                        'displayName': val.isEmpty ? _accountData['name'] : val
                      });
                    },
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        AutocompleteFormField(
                          initialValue: utils.cast<Map<String, dynamic>>(
                            _accountDetail['parentAccount'],
                          ),
                          autoFocus: false,
                          focusNode: _parentAccountFocusNode,
                          controller: _parentAccountTextEditingController,
                          autocompleteCallback: (pattern) {
                            return _accountProvider.accountAutocomplete(
                              searchText: pattern,
                              accountType: _selectedAccountTypes,
                            );
                          },
                          validator: null,
                          labelText: 'Parent Account',
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          onSaved: (val) {
                            _accountData.addAll(
                              {
                                'parentAccount': val == null
                                    ? null
                                    : _parentAccountTextEditingController
                                            .text.isEmpty
                                        ? null
                                        : val['id']
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    visible: !_selectedAccountTypes.contains('TRADE_PAYABLE') &&
                        !_selectedAccountTypes.contains('TRADE_RECEIVABLE'),
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        AutocompleteFormField(
                          initialValue: utils.cast<Map<String, dynamic>>(
                            _accountDetail['party'],
                          ),
                          focusNode: _vendorFocusNode,
                          controller: _vendorTextEditingController,
                          autocompleteCallback: (pattern) {
                            return _vendorProvider.vendorAutoComplete(
                              searchText: pattern,
                            );
                          },
                          validator: null,
                          labelText: 'Vendor',
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          onSaved: (val) {
                            _accountData.addAll(
                              {
                                'party': val == null
                                    ? null
                                    : _vendorTextEditingController.text.isEmpty
                                        ? null
                                        : val['id']
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    visible: _selectedAccountTypes.contains('TRADE_PAYABLE'),
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        AutocompleteFormField(
                          initialValue: utils.cast<Map<String, dynamic>>(
                            _accountDetail['party'],
                          ),
                          focusNode: _customerFocusNode,
                          controller: _customerTextEditingController,
                          autocompleteCallback: (pattern) {
                            return _customerProvider.customerAutoComplete(
                              searchText: pattern,
                            );
                          },
                          validator: null,
                          labelText: 'Customer',
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          onSaved: (val) {
                            _accountData.addAll(
                              {
                                'party': val == null
                                    ? null
                                    : _customerTextEditingController
                                            .text.isEmpty
                                        ? null
                                        : val['id']
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    visible: _selectedAccountTypes.contains('TRADE_RECEIVABLE'),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _accountDetail['description']
                        .toString()
                        .replaceAll('null', ''),
                    focusNode: _descriptionFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _accountData.addAll({'description': val});
                      }
                    },
                    maxLines: null,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            accountName.isEmpty ? 'Add Account' : accountName,
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
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _accountFormGeneralInfoContainer(),
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
