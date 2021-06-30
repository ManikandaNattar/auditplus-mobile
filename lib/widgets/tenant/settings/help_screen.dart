import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../utils.dart' as utils;

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/a.png'),
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Version:1.0.0',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Accounting in auditplus provides features like payment remainders, expense management, GST filing, invoicing and many more in one solution to make your cash flow steady.Manage your bank statement and transactions and reconcile them easily from within our application.',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Reach out to us for assistance. feedback or any idea you may like to share with us.',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(
                Icons.open_in_browser,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'https://auditplus.io/',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              onTap: () => utils.launchUrl(
                'https://auditplus.io/',
                context,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'support@auditplus.io',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              onTap: () => utils.launchUrl(
                'mailto:support@auditplus.io?subject=Reg:Feedback',
                context,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                '0461 2335577',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              onTap: () => utils.launchUrl(
                'tel:+0461 2335577',
                context,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(
                Icons.open_in_browser,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                '+91 9629299929',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              onTap: () => utils.launchUrl(
                'tel:+91 9629299929',
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
