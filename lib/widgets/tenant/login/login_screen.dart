import 'package:auditplusmobile/models/organization.dart';
import 'package:flutter/material.dart';

import './login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final _organizationName = routeArgs['organization'];

    return WillPopScope(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/organization'),
                    ),
                    Image(
                      image: AssetImage('assets/images/a.png'),
                      width: 32.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        Organization(_organizationName).avatar,
                        style: TextStyle(fontSize: 30),
                      ),
                      radius: 35.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Welcome to $_organizationName',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: LoginForm(_organizationName),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushNamed('/organization');
        return true;
      },
    );
  }
}
