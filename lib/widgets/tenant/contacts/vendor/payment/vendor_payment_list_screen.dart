import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/vendor_payment_provider.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/vendor/payment/vendor_payment_list.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class VendorPaymentListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _VendorPaymentListScreenState createState() =>
      _VendorPaymentListScreenState();
}

class _VendorPaymentListScreenState extends State<VendorPaymentListScreen> {
  VendorPaymentProvider _vendorPaymentProvider;
  List<Map<String, dynamic>> _vendorPaymentList = [];
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'voucherNo': '',
    'refNo': '',
    'byAccount': '',
    'toAccount': '',
    'amount': '',
    'voucherNoFilterKey': 'a..',
    'refNoFilterKey': 'a..',
    'amountFilterKey': '=',
    'filterFormName': 'VendorPayment',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;
  var inputFromDate;
  var outputFromDate;
  var inputToDate;
  var outputToDate;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getVendorPaymentList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _vendorPaymentProvider = Provider.of<VendorPaymentProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    _getVendorPaymentList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getVendorPaymentList() async {
    try {
      String currentDate = constants.defaultDate.format(DateTime.now());
      inputFromDate = constants.defaultDate.parse(
        _formData['fromDate'] == '' ? currentDate : _formData['fromDate'],
      );
      outputFromDate = constants.isoDateFormat.format(inputFromDate);
      inputToDate = constants.defaultDate.parse(
        _formData['toDate'] == '' ? currentDate : _formData['toDate'],
      );
      outputToDate = constants.isoDateFormat.format(inputToDate);
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'fromDate': 'gte'}: outputFromDate,
        {'toDate': 'lte'}: outputToDate,
        {'voucherNo': _formData['voucherNoFilterKey']}: _formData['voucherNo'],
        {'refNo': _formData['refNoFilterKey']}: _formData['refNo'],
        {'amount': _formData['amountFilterKey']}: _formData['amount'],
        {'byAccount': 'eq'}: _formData['byAccount'],
        {'toAccount': 'eq'}: _formData['toAccount'],
      });
      Map response = await _vendorPaymentProvider.getVendorPaymentList(
        searchQuery,
        pageNo,
        1000,
        '',
        '',
        _selectedBranch['id'],
      );
      hasMorePages = response['hasMorePages'];
      List data = response['results'];
      setState(() {
        _isLoading = false;
        addVendorPayment(data);
      });
      return _vendorPaymentList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addVendorPayment(List data) {
    _vendorPaymentList.addAll(
      data.map(
        (elm) {
          String refNo = elm['refNo'].toString().replaceAll('null', '');
          String voucherNo = elm['voucherNo'].toString().replaceAll('null', '');
          return {
            'id': elm['id'],
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'toAccount': elm['toAccount'],
            'byAccount': elm['byAccount'],
            'amount': elm['amount'],
            'reviewStatus': elm['reviewStatus'],
            'refNo': refNo.isNotEmpty && voucherNo.isNotEmpty
                ? '$refNo/$voucherNo'
                : refNo.isEmpty
                    ? voucherNo
                    : refNo,
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
      'fromDate': '',
      'toDate': '',
      'voucherNo': widget._appbarSearchEditingController.text,
      'refNo': '',
      'byAccount': '',
      'toAccount': '',
      'amount': '',
      'voucherNoFilterKey': '.a.',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'VendorPayment',
    };
    _vendorPaymentList.clear();
    _getVendorPaymentList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/contacts/payment-receipt-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _vendorPaymentList.clear();
          _getVendorPaymentList();
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
      'fromDate': '',
      'toDate': '',
      'voucherNo': '',
      'refNo': '',
      'byAccount': '',
      'toAccount': '',
      'amount': '',
      'voucherNoFilterKey': 'a..',
      'refNoFilterKey': 'a..',
      'amountFilterKey': '=',
      'filterFormName': 'VendorPayment',
    };
    _vendorPaymentList.clear();
    _getVendorPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Vendor Payment',
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
                pageNo = 1;
              });
              _formData = {
                'fromDate': '',
                'toDate': '',
                'voucherNo': '',
                'refNo': '',
                'byAccount': '',
                'toAccount': '',
                'amount': '',
                'voucherNoFilterKey': 'a..',
                'refNoFilterKey': 'a..',
                'amountFilterKey': '=',
                'filterFormName': 'VendorPayment',
              };
              _vendorPaymentList.clear();
              _getVendorPaymentList();
            }
          },
        ),
        drawer: MainDrawer(),
        body: VendorPaymentList(
          formData: {
            'isLoading': _isLoading,
            'hasMorePages': hasMorePages,
          },
          list: _vendorPaymentList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Vendor Payment',
          onPressed: () =>
              Navigator.of(context).pushNamed('/contacts/vendor/payment/form'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/contacts');
        return true;
      },
    );
  }
}
