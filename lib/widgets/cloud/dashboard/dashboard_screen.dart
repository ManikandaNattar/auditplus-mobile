import 'dart:io';

import 'package:auditplusmobile/widgets/cloud/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloudDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Organization'),
        ),
        drawer: CloudMainDrawer(),
        body: Center(
          child: Text('organization'),
        ),
      ),
      onWillPop: () async {
        exit(0);
      },
    );
  }
}
