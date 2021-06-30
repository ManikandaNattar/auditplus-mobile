import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './../../providers/auth/tenant_auth_provider.dart';

Future<dynamic> showModalUserBranchSelection({
  BuildContext context,
  String selectedBranch,
  String inventoryHead,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: UserBranchSelection(
          selectedBranch,
          inventoryHead,
        ),
      );
    },
  );
}

class UserBranchSelection extends StatefulWidget {
  final String selectedBranch;
  final String inventoryHead;
  @override
  _UserBranchSelectionState createState() => _UserBranchSelectionState();
  UserBranchSelection(
    this.selectedBranch,
    this.inventoryHead,
  );
}

class _UserBranchSelectionState extends State<UserBranchSelection> {
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  final TextEditingController _searchQueryController = TextEditingController();
  TenantAuth _authProvider;
  bool _isSearching = false;
  String _searchQuery = '';
  Map _branchObject = {};
  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<TenantAuth>(context);
    _assignedBranches = _authProvider.assignedBranches;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _searchQueryController.addListener(() {
      if (_searchQueryController.text.isEmpty) {
        setState(() {
          _searchQuery = '';
        });
      } else {
        setState(() {
          _searchQuery = _searchQueryController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  Icon _bottomSheetTitleBarActionIcon(BuildContext context) {
    if (this._isSearching == false) {
      return Icon(
        Icons.search,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return Icon(
        Icons.close,
        color: Theme.of(context).primaryColor,
      );
    }
  }

  Widget _bottomSheetTitleBar(BuildContext context) {
    if (this._isSearching == false) {
      return Text(
        'SELECT BRANCH',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          color: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return Container(
        width: 300,
        child: TextFormField(
          autofocus: true,
          controller: _searchQueryController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search here...',
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }
  }

  List<Map<String, dynamic>> getBranchList() {
    _filterBranches.clear();
    if (_searchQuery.isEmpty && widget.inventoryHead.isEmpty) {
      return _assignedBranches;
    } else {
      for (int i = 0; i <= _assignedBranches.length - 1; i++) {
        String name = _assignedBranches[i]['name'];
        if (widget.inventoryHead.isNotEmpty) {
          if (name
                  .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) &&
              _assignedBranches[i]['inventoryHead'] == widget.inventoryHead) {
            _filterBranches.add(_assignedBranches[i]);
          }
        } else {
          if (name
              .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase())) {
            _filterBranches.add(_assignedBranches[i]);
          }
        }
      }
      return _filterBranches;
    }
  }

  Widget _showBranchList() {
    List<Map<String, dynamic>> _branchData = getBranchList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ..._branchData
            .map(
              (brn) => ListTile(
                title: Text(brn['displayName']),
                onTap: () async {
                  SharedPreferences.getInstance().then((value) {
                    final branchData = {
                      'id': brn['id'],
                      'name': brn['name'],
                      'inventoryHead': brn['inventoryHead'],
                      'features': brn['features'],
                    };
                    value.setString(
                        'selected_branch_info', json.encode(branchData));
                    _branchObject.addAll({'branchInfo': branchData});
                  });
                  _authProvider.getselectedBranch();
                  Navigator.of(context).pop(_branchObject);
                },
                trailing: Visibility(
                  child: Icon(
                    Icons.done,
                    color: Theme.of(context).primaryColor,
                  ),
                  visible: brn.containsValue(widget.selectedBranch),
                ),
              ),
            )
            .toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      _bottomSheetTitleBar(context),
                    ],
                  ),
                  IconButton(
                    icon: _bottomSheetTitleBarActionIcon(context),
                    onPressed: () {
                      setState(
                        () {
                          if (_bottomSheetTitleBarActionIcon(context).icon ==
                              Icons.search) {
                            this._isSearching = true;
                            _bottomSheetTitleBar(context);
                            _bottomSheetTitleBarActionIcon(context);
                          } else {
                            this._isSearching = false;
                            this._searchQueryController.clear();
                            this._filterBranches.clear();
                            _bottomSheetTitleBarActionIcon(context);
                            _bottomSheetTitleBar(context);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 0.0,
              ),
              child: _showBranchList(),
            ),
          ],
        ),
      ),
    );
  }
}
