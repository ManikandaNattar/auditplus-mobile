import 'dart:io';

import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/widgets/shared/search_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountantListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _AccountantListScreenState createState() => _AccountantListScreenState();
}

class _AccountantListScreenState extends State<AccountantListScreen> {
  BuildContext _screenContext;
  UserProvider _userProvider;
  List _accountantList = [];
  List _filterAccountantList = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _getAccountantList();
    super.didChangeDependencies();
  }

  Future<List> _getAccountantList() async {
    try {
      _accountantList = widget._appbarSearchEditingController.text.isEmpty
          ? await _userProvider.getAccountantList()
          : _filterAccountantList;
      setState(() {
        _isLoading = false;
      });
      return _accountantList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  Future<void> _removeAccountant(int accountantCode) async {
    try {
      await _userProvider.removeAccountant(accountantCode);
      utils.showSuccessSnackbar(
          _screenContext, 'Accountant Deleted Successfully');
      Future.delayed(Duration(seconds: 1)).then((value) {
        setState(() {
          _isLoading = true;
          _accountantList.clear();
        });
        _getAccountantList();
      });
    } on HttpException catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _appbarSearchFuntion() {
    if (widget._appbarSearchEditingController.text.toString().isNotEmpty) {
      for (int i = 0; i <= _accountantList.length - 1; i++) {
        String email = _accountantList[i]['email'];
        if (email.contains(widget._appbarSearchEditingController.text)) {
          _filterAccountantList.add(_accountantList[i]);
        }
      }
    } else {
      _filterAccountantList = _accountantList;
    }
    setState(() {
      _isLoading = true;
      _accountantList.clear();
    });
    _getAccountantList();
  }

  Widget _showAccountantList() {
    return _isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _accountantList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView(
                children: [
                  ..._accountantList.map(
                    (e) {
                      return Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ListTileTheme(
                              dense: true,
                              child: ExpansionTile(
                                maintainState: true,
                                tilePadding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                                childrenPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 4.0,
                                ),
                                title: Text(
                                  e['email'].toString(),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    e['actCode'].toString(),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _removeAccountant(
                                          e['actCode'],
                                        ),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.75,
                          ),
                        ],
                      );
                    },
                  ).toList()
                ],
              );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: SearchViewAppBar(
          title: 'Accountant',
          searchFunction: _appbarSearchFuntion,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {});
            }
          },
          searchQueryController: widget._appbarSearchEditingController,
        ),
        drawer: MainDrawer(),
        body: Builder(
          builder: (BuildContext context) {
            _screenContext = context;
            return _showAccountantList();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Accountant',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/accountant/form',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/administration');
        return true;
      },
    );
  }
}
