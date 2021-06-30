import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/inventory_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/report/report_book_header.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class InventoryBookScreen extends StatefulWidget {
  @override
  _InventoryBookScreenState createState() => _InventoryBookScreenState();
}

class _InventoryBookScreenState extends State<InventoryBookScreen> {
  BuildContext _screenContext;
  InventoryReportsProvider _inventoryReportsProvider;
  TenantAuth _tenantAuth;
  List<Map<String, dynamic>> _inventoryBookList = [];
  int _pageNo = 1;
  var _totalInward = 0.0;
  var _totalOutward = 0.0;
  var _opening = 0.0;
  var _closing = 0.0;
  bool _isLoading = true;
  bool _pdfLoading = false;
  Map _userSelectedBranch = {};
  bool _hasMorePages = false;
  Map _formData = {
    'inventory': '',
    'fromDate': '',
    'toDate': '',
    'branchList': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed(
      '/reports/inventory/inventory-book/form',
      arguments: _formData,
    )
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _inventoryBookList.clear();
          _isLoading = true;
        });
        _getInventoryBookList();
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
    _inventoryReportsProvider = Provider.of<InventoryReportsProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_hasMorePages == true) {
      setState(() {
        _pageNo += 1;
        _getInventoryBookList();
      });
    }
  }

  bool _hasFormData() {
    return _formData['inventory'] != '' ||
        _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '' ||
        _formData['branchList'] != '';
  }

  Future<List<Map<String, dynamic>>> _getInventoryBookList() async {
    try {
      Map<String, dynamic> response =
          await _inventoryReportsProvider.getInventoryBook(
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
        _formData['inventory']['id'],
        _formData['branch'],
        _pageNo,
      );
      _totalInward = response['balance']['inward'];
      _totalOutward = response['balance']['outward'];
      _opening = response['balance']['opening'];
      _closing = response['balance']['closing'];
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addInventoryBook(data);
      });
      return _inventoryBookList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addInventoryBook(List data) {
    _inventoryBookList.addAll(
      data.map(
        (elm) {
          return {
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'particulars': elm['particulars'].toString().replaceAll('null', ''),
            'voucherType': elm['voucherName'],
            'refNo': elm['refNo'].toString().replaceAll('null', ''),
            'inward': elm['inward'],
            'outward': elm['outward'],
          };
        },
      ).toList(),
    );
  }

  Future<void> _getInventoryBookPrintData() async {
    try {
      final response =
          await _inventoryReportsProvider.getInventoryBookPrintData(
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
        _formData['inventory']['id'],
        _formData['branch'],
        _userSelectedBranch['id'],
      );
      utils.downloadFile(response, 'Inventory_Book_Report').then(
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
                'Inventory Book',
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
                  _getInventoryBookPrintData();
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
                      ReportBookHeader(
                        reportName: 'inventory',
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: InventoryBook(
                                formData: {
                                  'pageNo': _pageNo,
                                  'inward': _totalInward,
                                  'outward': _totalOutward,
                                  'opening': _opening,
                                  'closing': _closing,
                                  'isLoading': _isLoading,
                                  'hasMorePages': _hasMorePages,
                                  'reportName': 'Inventory',
                                },
                                list: _inventoryBookList,
                                onScrollEnd: () => onScrollEnd(),
                              ),
                            ),
                    ],
                  ),
                ),
                Visibility(
                  child: ProgressLoader(
                    message: 'Generating PDF.please wait...',
                  ),
                  visible: _pdfLoading,
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
