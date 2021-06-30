import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/sale_provider.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class SaleListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _SaleListScreenState createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  SaleProvider _saleProvider;
  List<Map<String, dynamic>> _saleList = [];
  ScrollController _scrollController = ScrollController();
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  Map args = {};
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'voucherNo': '',
    'refNo': '',
    'customer': '',
    'inventory': '',
    'amount': '',
    'voucherNoFilterKey': 'a..',
    'refNoFilterKey': 'a..',
    'amountFilterKey': '=',
    'isAdvancedFilter': 'true',
    'filterFormName': 'Sale',
  };

  @override
  void initState() {
    addScrollListener();
    super.initState();
  }

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getSaleList();
      });
    }
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _saleProvider = Provider.of<SaleProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _formData = args;
    }
    _getSaleList();
    super.didChangeDependencies();
  }

  Future<void> _getSaleList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'fromDate': 'gte'}: _formData['fromDate'] == null
            ? ''
            : constants.isoDateFormat.format(
                _formData['fromDate'] == ''
                    ? DateTime.now()
                    : constants.defaultDate.parse(
                        _formData['fromDate'],
                      ),
              ),
        {'toDate': 'lte'}: _formData['toDate'] == null
            ? ''
            : constants.isoDateFormat.format(
                _formData['toDate'] == ''
                    ? DateTime.now()
                    : constants.defaultDate.parse(
                        _formData['toDate'],
                      ),
              ),
        {'voucherNo': _formData['voucherNoFilterKey']}: _formData['voucherNo'],
        {'refNo': _formData['refNoFilterKey']}: _formData['refNo'],
        {'amount': _formData['amountFilterKey']}: _formData['amount'],
        {'customer': 'eq'}: _formData['customer'],
        {'inventory': 'eq'}: _formData['inventory'],
      });
      final response = await _saleProvider.getSaleList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
        _selectedBranch['id'],
        'SALE',
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addSale(data);
      });
      return _saleList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addSale(List data) {
    _saleList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'voucherNo': elm['voucherNo'],
            'amount': elm['amount'],
            'refNo': elm['refNo'] == null ? '' : elm['refNo'],
            'customer': elm['customer'] == null ? '' : elm['customer'],
            'voucherName': elm['voucherName'],
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
      'fromDate': null,
      'toDate': null,
      'voucherNo': widget._appbarSearchEditingController.text,
      'refNo': '',
      'customer': '',
      'inventory': '',
      'amount': '',
      'voucherNoFilterKey': 'a..',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'Sale',
    };
    _saleList = [];
    _getSaleList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/inventory/sale-purchase-vouchers-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _saleList = [];
          _getSaleList();
        }
      },
    );
  }

  void _clearFilterPressed() {
    setState(() {
      _isLoading = true;
      pageNo = 1;
    });
    _formData = {
      'fromDate': null,
      'toDate': null,
      'voucherNo': '',
      'refNo': '',
      'customer': '',
      'inventory': '',
      'amount': '',
      'account': '',
      'voucherNoFilterKey': 'a..',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'Sale',
    };
    _saleList.clear();
    _getSaleList();
  }

  Widget _listHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 0.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'PARTICULARS',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'VOUCHER NO',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      'AMOUNT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _voucherList(BuildContext context) {
    return Expanded(
      child: Container(
        child: _saleList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: hasMorePages == true
                    ? _saleList.length + 1
                    : _saleList.length,
                itemBuilder: (_, index) {
                  if (index == _saleList.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 0.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _saleList[index]['date'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        _saleList[index]['voucherName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                              fontSize: 12.5,
                                            ),
                                      ),
                                      Visibility(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              _saleList[index]['customer'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                    letterSpacing: 0.5,
                                                    fontSize: 11.0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        visible: _saleList[index]['customer']
                                            .toString()
                                            .isNotEmpty,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _saleList[index]['voucherNo'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      Visibility(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              _saleList[index]['refNo'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                    letterSpacing: 0.5,
                                                    fontSize: 12.0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        visible: _saleList[index]['refNo']
                                            .toString()
                                            .isNotEmpty,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      double.parse(_saleList[index]['amount']
                                              .toString())
                                          .toStringAsFixed(2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                            fontSize: 14.0,
                                          ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.75,
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      // Navigator.of(context).pushNamed(
                      //   '/inventory/sale/detail',
                      //   arguments: {
                      //     'detail': _saleList[index],
                      //     'filterData': _formData,
                      //   },
                      // );
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Sale',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {
                _selectedBranch = val;
                _isLoading = true;
              });
              _saleList = [];
              _getSaleList();
            }
          },
        ),
        drawer: MainDrawer(),
        body: Builder(
          builder: (BuildContext context) {
            return _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        _listHeader(context),
                        Divider(
                          thickness: 1.0,
                        ),
                        _voucherList(context),
                      ],
                    ),
                  );
          },
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Sale',
            onPressed: () => Navigator.of(context).pushNamed(
              '/inventory/sale/form',
            ),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inv.sal.cssalcr',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/inventory');
        return true;
      },
    );
  }
}
