import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final List<String> privileges;
  final String features;

  MenuItem({
    @required this.title,
    @required this.icon,
    @required this.onTap,
    @required this.privileges,
    this.features,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.5,
          vertical: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
