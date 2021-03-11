import 'package:flutter/material.dart';
import './app_bar_branch_selection.dart';

class ListViewAppBar extends StatefulWidget with PreferredSizeWidget {
  final TextEditingController searchQueryController;
  final title;
  final Function filterIconPressed;
  final Function searchFunction;
  final bool isAdvancedFilter;
  final Function clearFilterPressed;
  final Function getSelectedBranch;
  ListViewAppBar({
    @required this.title,
    @required this.searchQueryController,
    @required this.searchFunction,
    @required this.filterIconPressed,
    @required this.isAdvancedFilter,
    @required this.clearFilterPressed,
    this.getSelectedBranch,
  });
  @override
  _ListViewAppBarState createState() => _ListViewAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ListViewAppBarState extends State<ListViewAppBar> {
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
        Visibility(
          child: IconButton(
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
          visible: widget.isAdvancedFilter == true ? false : true,
        ),
        IconButton(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: Colors.white,
          ),
          onPressed: widget.filterIconPressed,
        ),
        Visibility(
          child: IconButton(
            icon: Icon(
              Icons.search_off,
              color: Colors.white,
            ),
            onPressed: widget.clearFilterPressed,
          ),
          visible: widget.isAdvancedFilter == true ? true : false,
        ),
      ],
    );
  }
}
