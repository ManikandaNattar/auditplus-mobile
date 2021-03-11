import 'dart:io';

import 'package:flutter/material.dart';

import './organization_header.dart';
import './organization_body.dart';

class OrganizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: [
            OrganizationHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OrganizationBody(context),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        exit(0);
      },
    );
  }
}
