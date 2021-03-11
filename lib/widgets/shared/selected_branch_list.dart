import 'package:flutter/material.dart';

import './branch_selection.dart';

class SelectedBranchList extends StatefulWidget {
  final Function onSelected;
  final BuildContext screenContext;
  final List<dynamic> initialValues;

  SelectedBranchList({
    @required this.onSelected,
    @required this.screenContext,
    this.initialValues = const [],
  });

  @override
  _SelectedBranchListState createState() =>
      _SelectedBranchListState(branches: initialValues);
}

class _SelectedBranchListState extends State<SelectedBranchList> {
  List<dynamic> branches = [];

  _SelectedBranchListState({this.branches = const []});
  void _selectBranch() {
    showModalBranchSelection(
      context: widget.screenContext,
      previousValues: branches.map((elm) => elm['id']).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          branches = value;
        });
        widget.onSelected(branches);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Branch',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            GestureDetector(
              child: Text(
                'Choose..',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: _selectBranch,
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: [
            Container(
              width: 300.0,
              child: Wrap(spacing: 5.0, children: [
                ...branches
                    .map((elm) => Chip(
                          label: Text(
                            elm['displayName'],
                          ),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              branches.removeWhere(
                                  (item) => item['id'] == elm['id']);
                            });
                          },
                        ))
                    .toList(),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
