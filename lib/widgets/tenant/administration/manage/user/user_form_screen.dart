import 'package:auditplusmobile/providers/administration/role_provider.dart';
import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_regenerate_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  UserProvider _userProvider;
  RoleProvider _roleProvider;
  String userId = '';
  String userName = '';
  bool _enableRemoteAccess = false;
  bool _isAccountant = false;
  TextEditingController _roleTextEditingController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _roleFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  Map<String, dynamic> _userDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _userData = {};

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _roleFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _roleProvider = Provider.of<RoleProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      userId = arguments['id'];
      userName = arguments['displayName'];
      _getUser();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getUser() {
    _userDetail = arguments['detail'];
    _roleTextEditingController.text =
        _userDetail.keys.contains('role') ? _userDetail['role']['name'] : '';
    _enableRemoteAccess = _userDetail['allowRemoteAccess'];
    _isAccountant = _userDetail['isAccountant'];
    return _userDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _userData['allowRemoteAccess'] = _enableRemoteAccess;
      _userData['isAccountant'] = _isAccountant;
      Map<String, dynamic> responseData = {};
      try {
        if (userId.isEmpty) {
          responseData = await _userProvider.createUser(_userData);
          utils.showSuccessSnackbar(
              _screenContext, 'User Created Successfully');
        } else {
          await _userProvider.updateUser(userId, _userData);
          utils.showSuccessSnackbar(
              _screenContext, 'User Updated Successfully');
        }
        userId.isEmpty
            ? showUserRegeneratePasswordBottomSheet(
                screenContext: _screenContext,
                detail: _userDetail.isEmpty ? responseData : _userDetail,
              ).then((value) => Navigator.of(_screenContext)
                .pushReplacementNamed('/administration/manage/user'))
            : Navigator.of(_screenContext)
                .pushReplacementNamed('/administration/manage/user');
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _userFormGeneralInfoContainer() {
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
                  TextFormField(
                    readOnly: userId.isNotEmpty,
                    initialValue: _userDetail['username'],
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
                    style: userId.isEmpty
                        ? Theme.of(context).textTheme.subtitle1
                        : TextStyle(color: Colors.grey),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _nameFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _userData.addAll({'username': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _userDetail['displayName'],
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
                      FocusScope.of(context).requestFocus(_roleFocusNode);
                    },
                    onSaved: (val) {
                      _userData.addAll({
                        'displayName': val.isEmpty ? _userData['username'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue:
                        utils.cast<Map<String, dynamic>>(_userDetail['role']),
                    focusNode: _roleFocusNode,
                    controller: _roleTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _roleProvider.roleAutoComplete(
                          searchText: pattern);
                    },
                    validator: (val) {
                      if (val == null) {
                        return 'Role should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Role',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _userData
                          .addAll({'role': val == null ? null : val['id']});
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(4),
                          title: Text(
                            'Remote Access',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: _enableRemoteAccess,
                          onChanged: (val) {
                            setState(() {
                              _enableRemoteAccess = val;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(4),
                          title: Text(
                            'Is Accountant',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: _isAccountant,
                          onChanged: (val) {
                            setState(() {
                              _isAccountant = val;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userFormContactInfoContainer() {
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
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              title: Text(
                'CONTACT INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                TextFormField(
                  initialValue:
                      _userDetail['email'].toString().replaceAll('null', ''),
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_mobileFocusNode);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value) ==
                          false) {
                        return 'Email address should be valid address!';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _userData.addAll({'email': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue:
                      _userDetail['mobile'].toString().replaceAll('null', ''),
                  focusNode: _mobileFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _mobileFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_addressFocusNode);
                  },
                  onSaved: (val) {
                    _userData.addAll({'mobile': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue:
                      _userDetail['address'].toString().replaceAll('null', ''),
                  focusNode: _addressFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  onSaved: (val) {
                    _userData.addAll({'address': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 20.0,
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
            userName.isEmpty ? 'Add User' : userName,
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
                      _userFormGeneralInfoContainer(),
                      _userFormContactInfoContainer(),
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
