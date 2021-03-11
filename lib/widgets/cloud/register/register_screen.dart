import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'register_form.dart';

class CloudRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/apluslogo.png'),
                      width: 250.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Register',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: CloudRegisterForm(),
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
