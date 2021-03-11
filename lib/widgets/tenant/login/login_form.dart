import 'package:auditplusmobile/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../providers/auth/tenant_auth_provider.dart';
import './../../../utils.dart' as utils;

class LoginForm extends StatefulWidget {
  final String _organization;
  LoginForm(this._organization);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  Map<String, String> _authData = {'username': '', 'password': ''};
  bool _passwordObscureText = true;
  String username = '';
  TenantAuth _auth;

  void _passwordVisibilityToggle() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<TenantAuth>(context);
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _auth.login(
          _authData['username'],
          _authData['password'],
          widget._organization,
        );
        await getTenantAuth(_auth);
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } catch (error) {
        utils.handleErrorResponse(context, error.message, 'tenant');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      username = args['username'];
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: username,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.subtitle1,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              node.nextFocus();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Username should not be empty!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['username'] = value.trim();
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_passwordObscureText
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () => _passwordVisibilityToggle(),
                color: Theme.of(context).primaryColor,
              ),
            ),
            keyboardType: TextInputType.text,
            obscureText: _passwordObscureText,
            controller: _passwordController,
            style: Theme.of(context).textTheme.subtitle1,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password should not be empty!';
              }
              if (value.length < 8) {
                return 'Password should be 8 characters';
              }
              return null;
            },
            onSaved: (value) {
              _authData['password'] = value.trim();
            },
          ),
          SizedBox(
            height: 35.0,
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Container(
              height: 45.0,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'LOGIN',
                ),
                onPressed: _submit,
              ),
            ),
        ],
      ),
    );
  }
}
