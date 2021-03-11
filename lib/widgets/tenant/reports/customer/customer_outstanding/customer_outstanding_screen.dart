import 'dart:io';

import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/customer_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_consolidated_report.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_detail.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_header.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import 'package:collection/collection.dart';

class CustomerOutstandingScreen extends StatefulWidget {
  @override
  _CustomerOutstandingScreenState createState() =>
      _CustomerOutstandingScreenState();
}

class _CustomerOutstandingScreenState extends State<CustomerOutstandingScreen> {
  BuildContext _screenContext;
  CustomerReportsProvider _customerReportsProvider;
  TenantAuth _tenantAuth;
  List<Map<String, dynamic>> _consolidatedList = [];
  int _consolidateReportpageNo = 1;
  int _consolidateReportMaxPage = 0;
  double _consolidateReportTotalBalance = 0;
  bool _consolidateReportIsLoading = true;
  List<Map<String, dynamic>> _customerOutstandingSummary = [];
  int _customerOutstandingSummaryPageNo = 1;
  int _customerOutstandingSummaryMaxPage = 0;
  double _customerOutstandingSummaryTotalBalance = 0;
  bool _customerOutstandingSummaryIsLoading = true;
  List<Map<String, dynamic>> _customerOutstandingDetail = [];
  int _customerOutstandingDetailPageNo = 1;
  int _customerOutstandingDetailMaxPage = 0;
  double _customerOutstandingDetailTotalBalance = 0;
  bool _customerOutstandingDetailIsLoading = true;
  bool _pdfLoading = false;
  GroupByReport _groupByReport;
  String _groupBy = '';
  ViewReport _viewReport;
  String _viewRpt = '';
  Map _userSelectedBranch = {};
  Map _formData = {
    'group_by': '',
    'customer': '',
    'branch': '',
    'viewReport': '',
    'branchList': '',
    'customerList': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/customer/customer-outstanding/form',
            arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _checkReportVisibleToUser();
        });
      }
    });
  }

  void _checkReportVisibleToUser() {
    _groupByReport = _formData['group_by'];
    _groupBy = _groupByReport.toString().split('.').last;
    _viewReport = _formData['viewReport'];
    _viewRpt = _viewReport.toString().split('.').last;
    if (_viewRpt == 'Consolidate') {
      _consolidatedList.clear();
      _consolidateReportIsLoading = true;
      _consolidateReportpageNo = 1;
      _getCustomerOutstandingConsolidatedList();
    } else if (_viewRpt == 'Summary') {
      _customerOutstandingSummary.clear();
      _customerOutstandingSummaryIsLoading = true;
      _customerOutstandingSummaryPageNo = 1;
      _getCustomerOutstandingSummary();
    } else if (_viewRpt == 'Detail') {
      _customerOutstandingDetail.clear();
      _customerOutstandingDetailIsLoading = true;
      _customerOutstandingDetailPageNo = 1;
      _getCustomerOutstandingDetail();
    }
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
    _customerReportsProvider = Provider.of<CustomerReportsProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  void onConsolidateReportScrollEnd() {
    if (_consolidateReportMaxPage > _consolidateReportpageNo) {
      setState(() {
        _consolidateReportpageNo += 1;
        _getCustomerOutstandingConsolidatedList();
      });
    }
  }

  Future<void> _getCustomerOutstandingConsolidatedList() async {
    try {
      Map response = await _customerReportsProvider
          .getCustomerOutstandingConsolidatedReport(
        _groupBy.toLowerCase(),
        _formData['customer'],
        _formData['branch'],
        _consolidateReportpageNo,
      );
      _consolidateReportMaxPage = response['pageContext']['totalPages'];
      _consolidateReportTotalBalance =
          double.parse(response['total'].toString());
      List data = response['records'];
      setState(() {
        _consolidateReportIsLoading = false;
        addConsolidatedReport(data);
      });
    } catch (error) {
      setState(() {
        _consolidateReportIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void addConsolidatedReport(List data) {
    _consolidatedList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm[_groupBy.toLowerCase() + 'Id'],
            'particulars': elm['particulars'],
            'closing': elm['closing'],
          };
        },
      ).toList(),
    );
  }

  void onCustomerOutstandingSummaryScrollEnd() {
    if (_customerOutstandingSummaryMaxPage >
        _customerOutstandingSummaryPageNo) {
      setState(() {
        _customerOutstandingSummaryPageNo += 1;
        _getCustomerOutstandingSummary();
      });
    }
  }

  Future<void> _getCustomerOutstandingSummary() async {
    try {
      Map response =
          await _customerReportsProvider.getCustomerOutstandingSummary(
        _groupBy.toLowerCase(),
        _formData['customer'],
        _formData['branch'],
        _customerOutstandingSummaryPageNo,
      );
      _customerOutstandingSummaryMaxPage =
          response['pageContext']['totalPages'];
      _customerOutstandingSummaryTotalBalance =
          double.parse(response['total'].toString());
      List data = response['records'];
      setState(() {
        _customerOutstandingSummaryIsLoading = false;
        addCustomerOutstandingSummary(data);
      });
    } on HttpException catch (error) {
      setState(() {
        _customerOutstandingSummaryIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    } on SocketException catch (_) {
      setState(() {
        _customerOutstandingSummaryIsLoading = false;
      });
      utils.handleErrorResponse(
          context, 'Please check your internet connection!', 'tenant');
    }
  }

  void addCustomerOutstandingSummary(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _customerOutstandingSummary.addAll(value.map(
        (e) {
          return {
            'customerId': e['customerId'],
            'customerName': e['customerName'],
            'branchId': e['branchId'],
            'branchName': e['branchName'],
            'closing': e['closing'],
          };
        },
      ).toList());
    }
  }

  void onCustomerOutstandingDetailScrollEnd() {
    if (_customerOutstandingDetailMaxPage > _customerOutstandingDetailPageNo) {
      setState(() {
        _customerOutstandingDetailPageNo += 1;
        _getCustomerOutstandingDetail();
      });
    }
  }

  Future<void> _getCustomerOutstandingDetail() async {
    try {
      Map response =
          await _customerReportsProvider.getCustomerOutstandingDetail(
        _groupBy.toLowerCase(),
        _formData['customer'],
        _formData['branch'],
        _customerOutstandingDetailPageNo,
      );
      _customerOutstandingDetailMaxPage = response['pageContext']['totalPages'];
      _customerOutstandingDetailTotalBalance =
          double.parse(response['total'].toString());
      List data = response['records'];
      setState(() {
        _customerOutstandingDetailIsLoading = false;
        addCustomerOutstandingDetail(data);
      });
    } catch (error) {
      setState(() {
        _customerOutstandingDetailIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void addCustomerOutstandingDetail(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _customerOutstandingDetail.addAll(value.map(
        (e) {
          String refNo = e['refNo'].toString().replaceAll('null', '');
          String voucherNo = e['voucherNo'].toString().replaceAll('null', '');
          return {
            'customerId': e['customerId'],
            'customerName': e['customerName'],
            'branchId': e['branchId'],
            'branchName': e['branchName'],
            'closing': e['closing'],
            'opening': e['opening'],
            'effDate': e['effDate'],
            'days': e['days'],
            'voucherType': e['voucherType'],
            'refNo': refNo.isNotEmpty && voucherNo.isNotEmpty
                ? '$refNo/$voucherNo'
                : refNo.isEmpty
                    ? voucherNo
                    : refNo
          };
        },
      ).toList());
    }
  }

  Future<void> _getCustomerOutstandingPrintData() async {
    try {
      final response =
          await _customerReportsProvider.getCustomerOutstandingPrintData(
        {
          'branches': _formData['branch'],
          'customers': _formData['customer'],
          'groupBy': _groupBy.toLowerCase(),
        },
        _userSelectedBranch['id'],
        _viewRpt == 'Consolidate' ? 'consolidated' : _viewRpt.toLowerCase(),
      );
      utils.downloadFile(response, 'Customer_Outstanding_$_viewRpt').then(
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
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Outstanding',
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
                  _getCustomerOutstandingPrintData();
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
                      CustomerOutstandingHeader(
                        formData: _formData,
                      ),
                      _viewRpt == 'Consolidate'
                          ? Expanded(
                              child: CustomerOutstandingConsolidatedReport(
                                formData: {
                                  'groupBy': _groupBy,
                                  'pageNo': _consolidateReportpageNo,
                                  'totalBalance':
                                      _consolidateReportTotalBalance,
                                  'isLoading': _consolidateReportIsLoading,
                                  'maxPage': _consolidateReportMaxPage,
                                },
                                list: _consolidatedList,
                                onScrollEnd: onConsolidateReportScrollEnd,
                              ),
                            )
                          : _viewRpt == 'Summary'
                              ? Expanded(
                                  child: CustomerOutstandingSummary(
                                    formData: {
                                      'groupBy': _groupBy.toLowerCase(),
                                      'pageNo':
                                          _customerOutstandingSummaryPageNo,
                                      'totalBalance':
                                          _customerOutstandingSummaryTotalBalance,
                                      'isLoading':
                                          _customerOutstandingSummaryIsLoading,
                                      'maxPage':
                                          _customerOutstandingSummaryMaxPage,
                                    },
                                    list: _customerOutstandingSummary,
                                    onScrollEnd:
                                        onCustomerOutstandingSummaryScrollEnd,
                                  ),
                                )
                              : _viewRpt == 'Detail'
                                  ? Expanded(
                                      child: CustomerOutstandingDetail(
                                        formData: {
                                          'groupBy': _groupBy.toLowerCase(),
                                          'pageNo':
                                              _customerOutstandingDetailPageNo,
                                          'totalBalance':
                                              _customerOutstandingDetailTotalBalance,
                                          'isLoading':
                                              _customerOutstandingDetailIsLoading,
                                          'maxPage':
                                              _customerOutstandingDetailMaxPage,
                                        },
                                        list: _customerOutstandingDetail,
                                        onScrollEnd:
                                            onCustomerOutstandingDetailScrollEnd,
                                      ),
                                    )
                                  : Expanded(
                                      child: Center(
                                        child: ShowDataEmptyImage(),
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
