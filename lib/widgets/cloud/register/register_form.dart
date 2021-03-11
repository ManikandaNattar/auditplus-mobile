import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CloudRegisterForm extends StatefulWidget {
  @override
  _CloudRegisterFormState createState() => _CloudRegisterFormState();
}

class _CloudRegisterFormState extends State<CloudRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'confirmPassword': ''
  };
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  void _passwordVisibilityToggle() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  void _confirmPasswordVisibilityToggle() {
    setState(() {
      _confirmPasswordObscureText = !_confirmPasswordObscureText;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            focusNode: _emailFocusNode,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.subtitle1,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _emailFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocusNode);
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
            focusNode: _passwordFocusNode,
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
            style: Theme.of(context).textTheme.subtitle1,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _passwordFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
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
          TextFormField(
            focusNode: _confirmPasswordFocusNode,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                icon: Icon(_confirmPasswordObscureText
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () => _confirmPasswordVisibilityToggle(),
                color: Theme.of(context).primaryColor,
              ),
            ),
            keyboardType: TextInputType.text,
            obscureText: _confirmPasswordObscureText,
            style: Theme.of(context).textTheme.subtitle1,
            validator: (value) {
              if (value.isEmpty) {
                return 'Confirm Password should not be empty!';
              }
              if (value.length < 8) {
                return 'Confirm Password should be 8 characters';
              }
              return null;
            },
            onSaved: (value) {
              _authData['confirmPassword'] = value.trim();
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
                  'Register',
                ),
                onPressed: () {},
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
                  text: 'Already have an account?',
                  style: Theme.of(context).textTheme.headline1,
                ),
                TextSpan(
                  text: 'Login here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context)
                          .pushReplacementNamed('/cloud/login');
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
