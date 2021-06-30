import 'package:auditplusmobile/providers/reports/purchase_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/purchase/purchase_register/purchase_register.dart';
import 'package:auditplusmobile/widgets/tenant/reports/purchase/purchase_register/purchase_register_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class PurchaseRegisterScreen extends StatefulWidget {
  @override
  _PurchaseRegisterScreenState createState() => _PurchaseRegisterScreenState();
}

class _PurchaseRegisterScreenState extends State<PurchaseRegisterScreen> {
  BuildContext _screenContext;
  PurchaseReportsProvider _purchaseReportsProvider;
  List<Map<String, dynamic>> _purchaseRegisterList = [];
  int _pageNo = 1;
  double _creditAmount = 0;
  double _cashAmount = 0;
  double _bankAmount = 0;
  double _totalAmount = 0;
  bool _isLoading = true;
  bool _hasMorePages = false;
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'branchList': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/purchases/purchase-register/form',
            arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _purchaseRegisterList.clear();
          _isLoading = true;
        });
        _getSaleRegisterList();
      }
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _routeToForm();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _purchaseReportsProvider = Provider.of<PurchaseReportsProvider>(context);
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_hasMorePages == true) {
      setState(() {
        _pageNo += 1;
        _getSaleRegisterList();
      });
    }
  }

  bool _hasFormData() {
    return _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '' ||
        _formData['branchList'] != '';
  }

  Future<List<Map<String, dynamic>>> _getSaleRegisterList() async {
    try {
      Map response = await _purchaseReportsProvider.getPurchaseRegister(
        constants.isoDateFormat.format(
          constants.defaultDate.parse(
            _formData['fromDate'],
          ),
        ),
        constants.isoDateFormat.format(
          constants.defaultDate.parse(
            _formData['toDate'],
          ),
        ),
        _formData['branch'],
        _pageNo,
      );
      _creditAmount =
          double.parse(response['summary']['creditAmount'].toString());
      _cashAmount = double.parse(response['summary']['cashAmount'].toString());
      _bankAmount = double.parse(response['summary']['bankAmount'].toString());
      _totalAmount = double.parse(response['summary']['billAmount'].toString());
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addSaleRegister(data);
      });
      return _purchaseRegisterList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addSaleRegister(List data) {
    _purchaseRegisterList.addAll(
      data.map(
        (elm) {
          return {
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'particulars': elm['particulars'].toString().replaceAll('null', ''),
            'voucherType': elm['voucherName'],
            'refNo': elm['refNo'].toString().replaceAll('null', ''),
            'amount': elm['amount'],
          };
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purchase Register',
              ),
              AppBarBranchSelection(
                selectedBranch: (_) {
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.picture_as_pdf,
                size: 24.0,
              ),
              onPressed: () => null,
            ),
            IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () => _routeToForm(),
            ),
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            _screenContext = context;
            return Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      PurchaseRegisterHeader(
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: PurchaseRegister(
                                formData: {
                                  'pageNo': _pageNo,
                                  'creditAmount': _creditAmount,
                                  'cashAmount': _cashAmount,
                                  'bankAmount': _bankAmount,
                                  'totalAmount': _totalAmount,
                                  'isLoading': _isLoading,
                                  'hasMorePages': _hasMorePages,
                                },
                                list: _purchaseRegisterList,
                                onScrollEnd: () => onScrollEnd(),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/reports');
        return true;
      },
    );
  }
}
