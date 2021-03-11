import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:auditplusmobile/providers/administration/role_provider.dart';
import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class AdministrationFilterFormScreen extends StatefulWidget {
  @override
  _AdministrationFilterFormScreenState createState() =>
      _AdministrationFilterFormScreenState();
}

class _AdministrationFilterFormScreenState
    extends State<AdministrationFilterFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  UserProvider _userProvider;
  DesktopClientProvider _desktopClientProvider;
  RoleProvider _roleProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasNameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _desktopClientController =
      TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aliasNameFocusNode = FocusNode();
  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _desktopClientFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  String nameFilterKey;
  String aliasNameFilterKey;
  String emailFilterKey;
  Map _formData = Map();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _userFocusNode.dispose();
    _desktopClientFocusNode.dispose();
    _roleFocusNode.dispose();
    _emailFocusNode.dispose();
    _nameController.dispose();
    _aliasNameController.dispose();
    _userController.dispose();
    _desktopClientController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    _roleProvider = Provider.of<RoleProvider>(context);
    _formData = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _nameController.text = _formData['name'];
    _aliasNameController.text = _formData['aliasName'];
    _emailController.text = _formData['email'];
    _userController.text =
        _formData['users'] == '' || _formData['users'] == null
            ? ''
            : _formData['users']['username'];
    _desktopClientController.text =
        _formData['desktopClients'] == '' || _formData['desktopClients'] == null
            ? ''
            : _formData['desktopClients']['name'];
    _roleController.text = _formData['role'] == '' || _formData['role'] == null
        ? ''
        : _formData['role']['name'];
    nameFilterKey = _formData['nameFilterKey'];
    aliasNameFilterKey = _formData['aliasNameFilterKey'];
    emailFilterKey = _formData['emailFilterKey'];
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
                autoFocus: true,
                labelName: 'Name',
                filterType: 'text',
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
              Visibility(
                child: Column(
                  children: [
                    FilterKeyFormField(
                      autoFocus: false,
                      labelName: 'AliasName',
                      filterType: 'text',
                      filterKey: aliasNameFilterKey,
                      textEditingController: _aliasNameController,
                      focusNode: _aliasNameFocusNode,
                      nextFocusNode: _formData['filterFormName'] == 'Branch'
                          ? _userFocusNode
                          : null,
                      textInputAction: _formData['filterFormName'] == 'Branch'
                          ? TextInputAction.next
                          : TextInputAction.done,
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
                  ],
                ),
                visible: _formData['filterFormName'] != 'Desktop Client' &&
                    _formData['filterFormName'] != 'Role' &&
                    _formData['filterFormName'] != 'User',
              ),
              Visibility(
                child: Column(
                  children: [
                    AutocompleteFormField(
                      initialValue:
                          utils.cast<Map<String, dynamic>>(_formData['users']),
                      focusNode: _userFocusNode,
                      controller: _userController,
                      autocompleteCallback: (pattern) {
                        return _userProvider.userAutoComplete(
                            searchText: pattern);
                      },
                      validator: null,
                      labelText: 'User',
                      suggestionFormatter: (suggestion) =>
                          suggestion['username'],
                      textFormatter: (selection) => selection['username'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['users'] = _userController.text.isEmpty
                              ? _formData['users'] = ''
                              : val;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Branch',
              ),
              Visibility(
                child: Column(
                  children: [
                    AutocompleteFormField(
                      initialValue: utils.cast<Map<String, dynamic>>(
                          _formData['desktopClients']),
                      focusNode: _desktopClientFocusNode,
                      controller: _desktopClientController,
                      autocompleteCallback: (pattern) {
                        return _desktopClientProvider.desktopClientAutoComplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Desktop Client',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['desktopClients'] =
                              _desktopClientController.text.isEmpty
                                  ? _formData['desktopClients'] = ''
                                  : val;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Branch',
              ),
              Visibility(
                child: Column(
                  children: [
                    FilterKeyFormField(
                      autoFocus: false,
                      labelName: 'Email',
                      filterType: 'text',
                      filterKey: emailFilterKey,
                      textEditingController: _emailController,
                      focusNode: _emailFocusNode,
                      nextFocusNode: _roleFocusNode,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        _formData['email'] = val;
                      },
                      buttonOnPressed: (val) {
                        aliasNameFilterKey = val;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'User',
              ),
              Visibility(
                child: Column(
                  children: [
                    AutocompleteFormField(
                      initialValue:
                          utils.cast<Map<String, dynamic>>(_formData['role']),
                      focusNode: _roleFocusNode,
                      controller: _roleController,
                      autocompleteCallback: (pattern) {
                        return _roleProvider.roleAutoComplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Role',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['role'] = _roleController.text.isEmpty
                              ? _formData['role'] = ''
                              : val;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'User',
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
              _formData['emailFilterKey'] = emailFilterKey;
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
