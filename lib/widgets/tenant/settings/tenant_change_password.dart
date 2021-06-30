import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class TenantChangePassword extends StatefulWidget {
  @override
  _TenantChangePasswordState createState() => _TenantChangePasswordState();
}

class _TenantChangePasswordState extends State<TenantChangePassword> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  bool _currentPasswordObscureText = true;
  bool _newPasswordObscureText = true;
  bool _confirmNewPasswordObscureText = true;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isLoading = false;
  Map _changePasswordData = {};
  TenantAuth _tenantAuth = TenantAuth();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tenantAuth = Provider.of<TenantAuth>(context);
  }

  Future<void> _onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _tenantAuth.changePassword(_changePasswordData);
        await _tenantAuth.logout();
        Navigator.of(_screenContext).pushReplacementNamed(
          '/login',
          arguments: {
            'organization': _tenantAuth.organizationName,
          },
        );
      } catch (error) {
        utils.handleErrorResponse(context, error.message, 'tenant');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _changePasswordForm() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _currentPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentPasswordObscureText =
                                !_currentPasswordObscureText;
                          });
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _currentPasswordObscureText,
                    controller: _currentPasswordController,
                    style: Theme.of(context).textTheme.subtitle1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Current Password should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _changePasswordData['currentPassword'] = value.trim();
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _newPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _newPasswordObscureText = !_newPasswordObscureText;
                          });
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _newPasswordObscureText,
                    controller: _newPasswordController,
                    style: Theme.of(context).textTheme.subtitle1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'New Password should not be empty!';
                      }
                      if (value.length < 8) {
                        return 'New Password should be 8 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _changePasswordData['newPassword'] = value.trim();
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmNewPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmNewPasswordObscureText =
                                !_confirmNewPasswordObscureText;
                          });
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _confirmNewPasswordObscureText,
                    controller: _confirmNewPasswordController,
                    style: Theme.of(context).textTheme.subtitle1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Confirm New Password should not be empty!';
                      }
                      if (value.length < 8) {
                        return 'Confirm New should be 8 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Require at least one:',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            'Uppercase and lowercase letter (A, z)',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: true,
                          onChanged: (_) {},
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            'Numeric character (0–9)',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: true,
                          onChanged: (_) {},
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            'Special character (any character your environment will accept that is not an uppercase or a lowercase letter or a numeric character — for example, !, %, @, #, and so on)',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: true,
                          onChanged: (_) {},
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            'Be a minimum of eight (8) characters in length',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          value: true,
                          onChanged: (_) {},
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
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
                    _isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _changePasswordForm(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
