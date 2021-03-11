import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/vendor_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_book/vendor_book.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_book/vendor_book_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class VendorBookScreen extends StatefulWidget {
  @override
  _VendorBookScreenState createState() => _VendorBookScreenState();
}

class _VendorBookScreenState extends State<VendorBookScreen> {
  BuildContext _screenContext;
  VendorReportsProvider _vendorReportsProvider;
  TenantAuth _tenantAuth;
  List<Map<String, dynamic>> _vendorBookList = [];
  Map _userSelectedBranch = {};
  int _pageNo = 1;
  int _maxPage = 0;
  double _totalCredit = 0;
  double _totaldebit = 0;
  double _opening = 0;
  double _closing = 0;
  bool _isLoading = true;
  bool _pdfLoading = false;
  var inputFromDate;
  var outputFromDate;
  var inputToDate;
  var outputToDate;
  Map _formData = {
    'vendor': '',
    'fromDate': '',
    'toDate': '',
    'branchList': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed(
      '/reports/vendor/vendor-book-form',
      arguments: _formData,
    )
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _vendorBookList.clear();
          _isLoading = true;
        });
        _getVendorBookList();
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
    _tenantAuth = Provider.of<TenantAuth>(context);
    _vendorReportsProvider = Provider.of<VendorReportsProvider>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_maxPage > _pageNo) {
      setState(() {
        _pageNo += 1;
        _getVendorBookList();
      });
    }
  }

  bool _hasFormData() {
    return _formData['vendor'] != '' ||
        _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '' ||
        _formData['branchList'] != '';
  }

  Future<List<Map<String, dynamic>>> _getVendorBookList() async {
    try {
      inputFromDate = constants.defaultDate.parse(_formData['fromDate']);
      outputFromDate = constants.isoDateFormat.format(inputFromDate);
      inputToDate = constants.defaultDate.parse(_formData['toDate']);
      outputToDate = constants.isoDateFormat.format(inputToDate);
      Map response = await _vendorReportsProvider.getVendorBook(
        outputFromDate,
        outputToDate,
        _formData['vendor']['id'],
        _formData['branch'],
        _pageNo,
      );
      _maxPage = response['pageContext']['maxPage'];
      _totalCredit = double.parse(response['credit'].toString());
      _totaldebit = double.parse(response['debit'].toString());
      _opening = double.parse(response['opening'].toString());
      _closing = double.parse(response['closing'].toString());
      List data = response['records'];
      setState(() {
        _isLoading = false;
        addVendorBook(data);
      });
      return _vendorBookList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addVendorBook(List data) {
    _vendorBookList.addAll(
      data.map(
        (elm) {
          return {
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'particulars': elm['particulars'],
            'voucherType': elm['voucherType'],
            'refNo': elm['refNo'],
            'credit': elm['credit'],
            'debit': elm['debit'],
          };
        },
      ).toList(),
    );
  }

  Future<void> _getVendorBookPrintData() async {
    try {
      final response = await _vendorReportsProvider.getVendorBookPrintData(
        _userSelectedBranch['id'],
        outputFromDate,
        outputToDate,
        _formData['vendor']['id'],
        _formData['branch'],
      );
      utils.downloadFile(response, 'Vendor_Book_Report').then(
        (value) {
          OpenFile.open(value.path);
          setState(() {
            _pdfLoading = false;
          });
        },
      );
      if (!mounted) return;
    } catch (error) {
      setState(() {
        _pdfLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
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
                'Vendor Book',
              ),
              AppBarBranchSelection(
                selectedBranch: (value) {
                  setState(() {
                    _userSelectedBranch = value['branchInfo'];
                  });
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
              onPressed: () async {
                setState(() {
                  _pdfLoading = true;
                });
                if (await utils.checkPermission() == true) {
                  _getVendorBookPrintData();
                }
              },
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
                      VendorBookHeader(
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: VendorBook(
                                formData: {
                                  'pageNo': _pageNo,
                                  'credit': _totalCredit,
                                  'debit': _totaldebit,
                                  'opening': _opening,
                                  'closing': _closing,
                                  'isLoading': _isLoading,
                                  'maxPage': _maxPage,
                                },
                                list: _vendorBookList,
                                onScrollEnd: () => onScrollEnd(),
                              ),
                            ),
                    ],
                  ),
                ),
                ProgressLoader(
                  pdfLoading: _pdfLoading,
                  message: 'Generating PDF.please wait...',
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
