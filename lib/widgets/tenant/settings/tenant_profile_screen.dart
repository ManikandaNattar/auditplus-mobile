import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TenantProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
      ),
      body: Container(
        child: Center(
          child: ShowDataEmptyImage(),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () =>
            Navigator.of(context).pushNamed('tenant-profile/change-password'),
        icon: Icon(
          Icons.vpn_key,
        ),
        label: Text(
          'Change Password',
        ),
      ),
    );
  }
}
