import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/voucher_list_view.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class PaymentListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _PaymentListScreenState createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  VoucherProvider _voucherProvider;
  List<Map<String, dynamic>> _accountPaymentList = [];
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
    'account': '',
    'amount': '',
    'voucherNoFilterKey': 'a..',
    'refNoFilterKey': 'a..',
    'amountFilterKey': '=',
    'isAdvancedFilter': 'true',
    'filterFormName': 'Payment',
  };

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getAccountPaymentList();
      });
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
    _getAccountPaymentList();
    super.didChangeDependencies();
  }

  Future<void> _getAccountPaymentList() async {
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
        'PAYMENT',
        _selectedBranch['id'],
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addPayment(data);
      });
      return _accountPaymentList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addPayment(List data) {
    _accountPaymentList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'voucherNo': elm['voucherNo'],
            'amount': elm['amount'],
            'toAccount': elm['drAccount'],
            'byAccount': elm['crAccount'],
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
      'filterFormName': 'Payment',
    };
    _accountPaymentList = [];
    _getAccountPaymentList();
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
          _accountPaymentList.clear();
          _getAccountPaymentList();
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
      'filterFormName': 'Payment',
    };
    _accountPaymentList.clear();
    _getAccountPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Payment',
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
              _accountPaymentList = [];
              _getAccountPaymentList();
            }
          },
        ),
        drawer: MainDrawer(),
        body: Builder(
          builder: (BuildContext context) {
            return VoucherListView(
              list: _accountPaymentList,
              formData: {
                'hasMorePages': hasMorePages,
                'isLoading': _isLoading,
                'title': 'PAYMENT.ACCT',
                'subtitle': 'BANK/CASH',
                'routeName': '/accounts/vouchers/payment/detail',
                'filterData': _formData,
              },
              onScrollEnd: onScrollEnd,
            );
          },
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Payment Voucher',
            onPressed: () => Navigator.of(context).pushNamed(
              '/accounts/vouchers/payment/form',
              arguments: {
                'filterData': _formData,
              },
            ),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'ac.pmt.cr',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/accounts');
        return true;
      },
    );
  }
}
