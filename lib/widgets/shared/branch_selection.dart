import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/tenant_auth_provider.dart';

Future<dynamic> showModalBranchSelection({
  BuildContext context,
  List<dynamic> previousValues = const [],
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
      return BranchSelection(previousValues);
    },
  );
}

class BranchSelection extends StatefulWidget {
  final List<dynamic> previousValues;

  @override
  _BranchSelectionState createState() => _BranchSelectionState();

  BranchSelection(this.previousValues);
}

class _BranchSelectionState extends State<BranchSelection> {
  List<Map<String, dynamic>> _assignedBranches = [];
  List<dynamic> _selectedBranches = [];
  TenantAuth _authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<TenantAuth>(context);
    _assignedBranches = _authProvider.assignedBranches;
    _selectedBranches = _assignedBranches
        .where((elm) => widget.previousValues.contains(elm['id']))
        .map((item) => item['id'])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 14.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT BRANCH',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Checkbox(
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            _selectedBranches = _assignedBranches
                                .map((elm) => elm['id'])
                                .toList();
                          });
                        } else {
                          setState(() {
                            _selectedBranches = [];
                          });
                        }
                      },
                      value: (_selectedBranches.length ==
                          _assignedBranches.length),
                    ),
                  ],
                ),
              ),
              ..._assignedBranches
                  .map((elm) => CheckboxListTile(
                        title: Text(elm['displayName']),
                        onChanged: (value) {
                          if (value) {
                            setState(() {
                              _selectedBranches.add(elm['id']);
                            });
                          } else {
                            setState(() {
                              _selectedBranches.remove(elm['id']);
                            });
                          }
                        },
                        value: _selectedBranches.contains(elm['id']),
                      ))
                  .toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('SUBMIT'),
                    onPressed: () {
                      List<Map<String, dynamic>> selections = _assignedBranches
                          .where((elm) => _selectedBranches.contains(elm['id']))
                          .toList();
                      Navigator.of(context).pop(selections);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
