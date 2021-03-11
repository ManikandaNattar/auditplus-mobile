import 'package:flutter/material.dart';

class OrganizationHeader extends StatelessWidget {
  void routeToLogin(BuildContext context, String tag) {
    if (tag == 'login') {
      Navigator.of(context).pushNamed(
        '/cloud/login',
      );
    } else {
      Navigator.of(context).pushNamed(
        '/cloud/register',
      );
    }
  }

  @override
  build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 180.0,
      decoration: BoxDecoration(color: Colors.blue),
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              'assets/images/apluslogo.png',
            ),
            width: 280,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => routeToLogin(context, 'login'),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: Colors.white,
                  endIndent: 10,
                  indent: 10,
                ),
                TextButton(
                  onPressed: () => routeToLogin(context, 'register'),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
