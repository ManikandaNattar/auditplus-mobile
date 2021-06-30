import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/accounting/cost_category_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class AccountsFilterForm extends StatefulWidget {
  @override
  _AccountsFilterFormState createState() => _AccountsFilterFormState();
}

class _AccountsFilterFormState extends State<AccountsFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AccountProvider _accountProvider;
  CostCategoryProvider _costCategoryProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasNameController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _parentAccountController =
      TextEditingController();
  final TextEditingController _costCategoryController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aliasNameFocusNode = FocusNode();
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _parentAccountFocusNode = FocusNode();
  final FocusNode _costCategoryFocusNode = FocusNode();
  String nameFilterKey;
  String aliasNameFilterKey;
  Map _formData = Map();
  List _accountTypeList = [];
  List _filterAccountTypeList = [];

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _accountTypeFocusNode.dispose();
    _parentAccountFocusNode.dispose();
    _costCategoryFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    _costCategoryProvider = Provider.of<CostCategoryProvider>(context);
    _formData = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _nameController.text = _formData['name'];
    _aliasNameController.text = _formData['aliasName'];
    _accountTypeController.text =
        _formData['type'] == '' || _formData['type'] == null
            ? ''
            : _formData['type']['name'];
    _parentAccountController.text =
        _formData['parentAccount'] == '' || _formData['parentAccount'] == null
            ? ''
            : _formData['parentAccount']['name'];
    _costCategoryController.text =
        _formData['category'] == '' || _formData['category'] == null
            ? ''
            : _formData['category']['name'];
    nameFilterKey = _formData['nameFilterKey'];
    aliasNameFilterKey = _formData['aliasNameFilterKey'];
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
            .contains(query.toLowerCase())) {
          _filterAccountTypeList.add(_accountTypeList[i]);
        }
      }
    } else {
      _filterAccountTypeList = _accountTypeList;
    }
    return _filterAccountTypeList;
  }

  Widget _buildFilterForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'Name',
                filterType: 'text',
                autoFocus: true,
                filterKey: nameFilterKey,
                textEditingController: _nameController,
                focusNode: _nameFocusNode,
                nextFocusNode: _aliasNameFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['name'] = val;
                },
                buttonOnPressed: (val) {
                  nameFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'AliasName',
                filterType: 'text',
                autoFocus: false,
                filterKey: aliasNameFilterKey,
                textEditingController: _aliasNameController,
                focusNode: _aliasNameFocusNode,
                nextFocusNode: _formData['filterFormName'] == 'Cost Category'
                    ? null
                    : _formData['filterFormName'] == 'Cost Centre'
                        ? _costCategoryFocusNode
                        : _accountTypeFocusNode,
                textInputAction: _formData['filterFormName'] == 'Cost Category'
                    ? TextInputAction.done
                    : TextInputAction.next,
                onChanged: (val) {
                  _formData['aliasName'] = val;
                },
                buttonOnPressed: (val) {
                  aliasNameFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: Column(
                  children: [
                    AutocompleteFormField(
                      initialValue:
                          utils.cast<Map<String, dynamic>>(_formData['type']),
                      focusNode: _accountTypeFocusNode,
                      controller: _accountTypeController,
                      autocompleteCallback: (pattern) {
                        return _getAccountTypeList(
                          pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Account Type',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['type'] =
                              _accountTypeController.text.isEmpty
                                  ? _formData['type'] = ''
                                  : val;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Account',
              ),
              Visibility(
                child: Column(
                  children: [
                    AutocompleteFormField(
                      initialValue: utils.cast<Map<String, dynamic>>(
                          _formData['parentAccount']),
                      focusNode: _parentAccountFocusNode,
                      controller: _parentAccountController,
                      autocompleteCallback: (pattern) {
                        return _accountProvider.accountAutocomplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Parent Account',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['parentAccount'] =
                              _parentAccountController.text.isEmpty
                                  ? _formData['parentAccount'] = ''
                                  : val;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Account',
              ),
              Visibility(
                child: AutocompleteFormField(
                  initialValue:
                      utils.cast<Map<String, dynamic>>(_formData['category']),
                  focusNode: _costCategoryFocusNode,
                  controller: _costCategoryController,
                  autocompleteCallback: (pattern) {
                    return _costCategoryProvider.costCategoryAutocomplete(
                      searchText: pattern,
                    );
                  },
                  validator: null,
                  labelText: 'Cost Category',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  onSaved: (val) {
                    if (val != null) {
                      _formData['category'] =
                          _costCategoryController.text.isEmpty
                              ? _formData['category'] = ''
                              : val;
                    }
                  },
                ),
                visible: _formData['filterFormName'] == 'Cost Centre',
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
        title: Text(_formData['filterFormName']),
        actions: [
          TextButton(
            onPressed: () {
              _formKey.currentState.save();
              _formData['nameFilterKey'] = nameFilterKey;
              _formData['aliasNameFilterKey'] = aliasNameFilterKey;
              _formData['isAdvancedFilter'] = 'true';
              Navigator.of(context).pop(_formData);
            },
            child: Text(
              'SEARCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: _buildFilterForm(context),
    );
  }
}
