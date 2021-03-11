import 'dart:io';

import 'package:auditplusmobile/providers/auth/cloud_auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class CloudLoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  Map<String, String> _authData = {'email': '', 'password': ''};
  bool _passwordObscureText = true;
  String email = '';

  void _passwordVisibilityToggle() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await Provider.of<CloudAuth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        Navigator.of(context).pushNamed('/cloud/dashboard');
      } on HttpException catch (error) {
        utils.handleErrorResponse(context, error.message, 'cloud');
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
      email = args['email'];
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: email,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.subtitle1,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              node.nextFocus();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Email should not be empty!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['email'] = value.trim();
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
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
          SizedBox(
            height: 35.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Create an account?',
                  style: Theme.of(context).textTheme.headline1,
                ),
                TextSpan(
                  text: 'Register here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context)
                        .pushReplacementNamed('/cloud/register'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
