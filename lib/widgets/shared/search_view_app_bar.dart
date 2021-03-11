import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_bar_branch_selection.dart';

class SearchViewAppBar extends StatefulWidget with PreferredSizeWidget {
  final TextEditingController searchQueryController;
  final title;
  final Function searchFunction;
  final Function getSelectedBranch;
  SearchViewAppBar({
    @required this.title,
    @required this.searchFunction,
    @required this.getSelectedBranch,
    @required this.searchQueryController,
  });
  @override
  _SearchViewAppBarState createState() => _SearchViewAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchViewAppBarState extends State<SearchViewAppBar> {
  bool _isSearching = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Icon _appBarActionIcon(BuildContext context) {
    if (this._isSearching == false) {
      return Icon(
        Icons.search,
      );
    } else {
      return Icon(
        Icons.close,
      );
    }
  }

  Widget _appBarTitle(BuildContext context) {
    if (this._isSearching == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
          ),
          AppBarBranchSelection(
            selectedBranch: (value) {
              if (value != null) {
                setState(() {
                  widget.getSelectedBranch(value['branchInfo']);
                });
              }
            },
          ),
        ],
      );
    } else {
      return TextFormField(
        key: _formKey,
        autofocus: true,
        validator: (value) {
          if (value.isEmpty) {
            return 'Name should not be empty';
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        cursorColor: Colors.white,
        controller: widget.searchQueryController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search here...',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        onFieldSubmitted: (_) => widget.searchFunction(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle(context),
      actions: [
        IconButton(
          icon: _appBarActionIcon(context),
          onPressed: () {
            setState(() {
              if (_appBarActionIcon(context).icon == Icons.search) {
                _isSearching = true;
                _appBarActionIcon(context);
                _appBarTitle(context);
              } else {
                _isSearching = false;
                _appBarActionIcon(context);
                _appBarTitle(context);
                if (widget.searchQueryController.text.isNotEmpty) {
                  widget.searchQueryController.clear();
                  widget.searchFunction();
                }
              }
            });
          },
        ),
      ],
    );
  }
}
