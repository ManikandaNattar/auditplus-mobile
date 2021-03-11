import 'package:auditplusmobile/providers/auth/cloud_auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../tenant/main_drawer/drawer_item.dart';
import './../../../utils.dart' as utils;

class CloudMainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = Provider.of<CloudAuth>(context).email;
    Future<void> _routeToTenant() async {
      final cloudAuth = Provider.of<CloudAuth>(context);
      await cloudAuth.logout();
      Navigator.of(context).pushReplacementNamed('/organization');
    }

    Future<void> _logout() async {
      final cloudAuth = Provider.of<CloudAuth>(context);
      await cloudAuth.logout();
      Navigator.of(context).pushReplacementNamed('/cloud/login');
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: Text(
                email.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          DrawerItem(
            title: 'Organization',
            icon: Icons.apartment,
            onTap: () => Navigator.of(context).pushNamed('/cloud/dashboard'),
          ),
          DrawerItem(
            title: 'Billing',
            icon: Icons.receipt,
            onTap: null,
          ),
          DrawerItem(
            title: 'Profile',
            icon: Icons.account_circle,
            onTap: null,
          ),
          DrawerItem(
            title: 'Switch Tenant',
            icon: Icons.supervised_user_circle,
            onTap: () => utils.showAlertDialog(
              context,
              _routeToTenant,
              'Switch Tenant?',
              'Do you want to continue',
            ),
          ),
          DrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () => utils.showAlertDialog(
              context,
              _logout,
              'Logout?',
              'Do you want to continue',
            ),
          ),
        ],
      ),
    );
  }
}
