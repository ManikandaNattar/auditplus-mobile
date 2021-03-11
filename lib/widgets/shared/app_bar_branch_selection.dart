import 'dart:convert';

import 'package:auditplusmobile/widgets/shared/user_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarBranchSelection extends StatelessWidget {
  final Function selectedBranch;
  final String inventoryHead;
  AppBarBranchSelection({
    this.selectedBranch,
    this.inventoryHead,
  });

  Future<Map<String, dynamic>> getSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    var branch = prefs.getString('selected_branch_info');
    if (branch != null) {
      return json.decode(branch);
    } else {
      return {
        'id': '-1',
        'name': 'Select Branch',
        'displayName': 'Select Branch'
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSelectedBranch(),
      builder: (_, value) {
        return value.connectionState == ConnectionState.waiting
            ? CupertinoActivityIndicator()
            : GestureDetector(
                child: Row(
                  children: [
                    Text(
                      value.data['name'],
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                    ),
                  ],
                ),
                onTap: () => showModalUserBranchSelection(
                  context: context,
                  selectedBranch: value.data['name'],
                  inventoryHead: inventoryHead == null ? '' : inventoryHead,
                ).then(
                  (value) {
                    if (selectedBranch != null) {
                      selectedBranch(value);
                    }
                  },
                ),
              );
      },
    );
  }
}
