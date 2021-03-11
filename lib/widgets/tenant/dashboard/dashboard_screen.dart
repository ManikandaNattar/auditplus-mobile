import 'dart:io';

import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/material.dart';

import './../main_drawer/main_drawer.dart';
import './../reports/dashboard/sale_summary.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
              ),
              AppBarBranchSelection(
                selectedBranch: (value) {
                  if (value != null) {
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
        drawer: MainDrawer(),
        body: Column(
          children: [
            SaleSummary(),
          ],
        ),
      ),
      onWillPop: () async {
        exit(0);
      },
    );
  }
}
