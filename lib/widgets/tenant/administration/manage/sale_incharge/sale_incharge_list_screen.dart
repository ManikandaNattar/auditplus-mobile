import 'dart:io';

import 'package:auditplusmobile/providers/administration/sale_incharge_provider.dart';
import 'package:auditplusmobile/widgets/shared/search_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class SaleInchargeListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _SaleInchargeListScreenState createState() => _SaleInchargeListScreenState();
}

class _SaleInchargeListScreenState extends State<SaleInchargeListScreen> {
  BuildContext _screenContext;
  SaleInchargeProvider _saleInchargeProvider;
  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _salesInchargeList = [];
  bool _isLoading = true;
  int pageNo = 1;
  Map _formData = {
    'name': '',
    'nameFilterKey': 'a..',
  };
  bool hasMorePages;

  @override
  void initState() {
    addScrollListener();
    super.initState();
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getSalesInchargeList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _saleInchargeProvider = Provider.of<SaleInchargeProvider>(context);
    _getSalesInchargeList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getSalesInchargeList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
      });
      Map response = await _saleInchargeProvider.getSaleInchargesList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      hasMorePages = response['hasMorePages'];
      List data = response['results'];
      setState(() {
        _isLoading = false;
        addSaleIncharge(data);
      });
      return _salesInchargeList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addSaleIncharge(List data) {
    _salesInchargeList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'name': elm['name'],
            'code': elm['code'],
          };
        },
      ).toList(),
    );
  }

  void _appbarSearchFuntion() {
    setState(() {
      pageNo = 1;
      _isLoading = true;
    });
    _formData = {
      'name': widget._appbarSearchEditingController.text,
      'nameFilterKey': '.a.',
    };
    _salesInchargeList.clear();
    _getSalesInchargeList();
  }

  Future<void> _deleteSaleIncharge(String saleInchargeId) async {
    try {
      await _saleInchargeProvider.deleteSalesIncharge(saleInchargeId);
      utils.showSuccessSnackbar(
          _screenContext, 'Sales Incharge Deleted Successfully');
      Future.delayed(Duration(seconds: 1)).then((value) {
        setState(() {
          _isLoading = true;
          _salesInchargeList.clear();
        });
        _getSalesInchargeList();
      });
    } on HttpException catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _showSaleInchargeList() {
    return _isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _salesInchargeList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: hasMorePages == true
                    ? _salesInchargeList.length + 1
                    : _salesInchargeList.length,
                itemBuilder: (BuildContext context, index) {
                  _screenContext = context;
                  if (index == _salesInchargeList.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ListTileTheme(
                          dense: true,
                          child: ExpansionTile(
                            maintainState: true,
                            tilePadding: EdgeInsets.symmetric(horizontal: 12.0),
                            childrenPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            title: Text(
                              _salesInchargeList[index]['name'],
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Text(
                                _salesInchargeList[index]['code'],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                      '/administration/manage/sale-incharge/form',
                                      arguments: {
                                        'detail': _salesInchargeList[index]
                                      },
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    label: Text(
                                      'Edit',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _deleteSaleIncharge(
                                      _salesInchargeList[index]['id'],
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).errorColor,
                                    ),
                                    label: Text(
                                      'Delete',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
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
              );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: SearchViewAppBar(
          title: 'Sale Incharge',
          searchFunction: _appbarSearchFuntion,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {});
            }
          },
          searchQueryController: widget._appbarSearchEditingController,
        ),
        drawer: MainDrawer(),
        body: _showSaleInchargeList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Sale Incharge',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/sale-incharge/form',
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
