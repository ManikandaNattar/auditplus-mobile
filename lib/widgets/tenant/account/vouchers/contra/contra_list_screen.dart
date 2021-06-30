import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class ContraListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _ContraListScreenState createState() => _ContraListScreenState();
}

class _ContraListScreenState extends State<ContraListScreen> {
  VoucherProvider _voucherProvider;
  List<Map<String, dynamic>> _contraList = [];
  ScrollController _scrollController = ScrollController();
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  List _menuList = [];
  Map args = {};
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'voucherNo': '',
    'refNo': '',
    'account': '',
    'amount': '',
    'voucherNoFilterKey': 'a..',
    'refNoFilterKey': 'a..',
    'amountFilterKey': '=',
    'isAdvancedFilter': 'true',
    'filterFormName': 'Contra',
  };

  @override
  void initState() {
    addScrollListener();
    _checkVisibility();
    super.initState();
  }

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getContraList();
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

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(context, ['ac.ctra.cr'])) {
      _menuList = [
        'Add Cash Deposit Voucher',
        'Add Cash Withdrawal Voucher',
      ];
    }
  }

  void _menuAction(String menu) {
    if (menu == 'Add Cash Deposit Voucher') {
      Navigator.of(context).pushNamed(
        '/accounts/vouchers/contra/form',
        arguments: {
          'formName': 'CD',
          'filterData': _formData,
        },
      );
    } else if (menu == 'Add Cash Withdrawal Voucher') {
      Navigator.of(context).pushNamed(
        '/accounts/vouchers/contra/form',
        arguments: {
          'formName': 'CW',
          'filterData': _formData,
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _formData = args;
    }
    _getContraList();
    super.didChangeDependencies();
  }

  Future<void> _getContraList() async {
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
        {'account': 'eq'}: _formData['account'],
      });
      final response = await _voucherProvider.getVoucherList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
        'CONTRA',
        _selectedBranch['id'],
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addContra(data);
      });
      return _contraList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addContra(List data) {
    _contraList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'voucherNo': elm['voucherNo'],
            'amount': elm['amount'],
            'toAccount': elm['drAccount'] == 'Cash'
                ? elm['crAccount']
                : elm['drAccount'],
            'refNo': elm['refNo'] == null ? '' : elm['refNo'],
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
      'account': '',
      'amount': '',
      'voucherNoFilterKey': '.a.',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'Contra',
    };
    _contraList = [];
    _getContraList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/accounts/vouchers/accounts-vouchers-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _contraList.clear();
          _getContraList();
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
      'account': '',
      'amount': '',
      'voucherNoFilterKey': 'a..',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'Contra',
    };
    _contraList.clear();
    _getContraList();
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
                      'DATE_REF.NO',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'VOU.NO',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'BANK',
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
        child: _contraList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: hasMorePages == true
                    ? _contraList.length + 1
                    : _contraList.length,
                itemBuilder: (_, index) {
                  if (index == _contraList.length) {
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      _contraList[index]['refNo'] == ''
                                          ? _contraList[index]['date']
                                          : '${_contraList[index]['date']}_${_contraList[index]['refNo']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      _contraList[index]['voucherNo'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      _contraList[index]['toAccount'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      double.parse(_contraList[index]['amount']
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
                      Navigator.of(context).pushNamed(
                        '/accounts/vouchers/contra/detail',
                        arguments: {
                          'detail': _contraList[index],
                          'filterData': _formData,
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _popupMenu() => PopupMenuButton<String>(
        onSelected: (value) => _menuAction(value),
        itemBuilder: (BuildContext context) {
          return _menuList.map(
            (menu) {
              return PopupMenuItem<String>(
                value: menu,
                child: Text(
                  menu,
                ),
              );
            },
          ).toList();
        },
        icon: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.blue,
            shape: StadiumBorder(
              side: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Contra',
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
              _contraList = [];
              _getContraList();
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
                        Visibility(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              child: _popupMenu(),
                            ),
                          ),
                          visible: utils.checkMenuWiseAccess(
                            context,
                            [
                              'ac.ctra.cr',
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/accounts');
        return true;
      },
    );
  }
}
