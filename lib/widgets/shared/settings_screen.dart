import 'package:auditplusmobile/widgets/shared/rating_dialog.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../utils.dart' as utils;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _userAccountContainer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Text(
                'ACCOUNT',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.supervisor_account,
                        size: 24.0,
                      ),
                      radius: 24.0,
                    ),
                    title: Text(
                      'Admin',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    subtitle: Text(
                      'Personal Info',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                    ),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/tenant-profile'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _settingsContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Text(
                'SETTINGS',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.security,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Privacy & Security',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () => utils.launchUrl(
                    'https://auditplus.io/policy.html',
                    context,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Appearance',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.update,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Upgrade',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () => utils.launchUrl(
                    'https://auditplus.io/pricing.html',
                    context,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Feedback',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () => utils.launchUrl(
                    'mailto:support@auditplus.io?subject=Reg:Feedback',
                    context,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.star_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Rate Our App',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () => showRatingDialog(context: context),
                ),
                ListTile(
                  leading: Icon(
                    Icons.live_help_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Help',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    '/help',
                  ),
                ),
              ],
            ),
          ],
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
            'Settings',
          ),
        ),
        drawer: MainDrawer(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userAccountContainer(),
              _settingsContainer(context),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/dashboard');
        return true;
      },
    );
  }
}
