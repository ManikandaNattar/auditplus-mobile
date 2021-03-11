import 'dart:io';

import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/vendor_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_consolidated_report.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_detail.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_header.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import './../../../../../utils.dart' as utils;

class VendorOutstandingScreen extends StatefulWidget {
  @override
  _VendorOutstandingScreenState createState() =>
      _VendorOutstandingScreenState();
}

class _VendorOutstandingScreenState extends State<VendorOutstandingScreen> {
  BuildContext _screenContext;
  VendorReportsProvider _vendorReportsProvider;
  TenantAuth _tenantAuth;
  List<Map<String, dynamic>> _consolidatedList = [];
  int _consolidateReportpageNo = 1;
  int _consolidateReportMaxPage = 0;
  double _consolidateReportTotalBalance = 0;
  bool _consolidateReportIsLoading = true;
  List<Map<String, dynamic>> _vendorOutstandingSummary = [];
  int _vendorOutstandingSummaryPageNo = 1;
  int _vendorOutstandingSummaryMaxPage = 0;
  double _vendorOutstandingSummaryTotalBalance = 0;
  bool _vendorOutstandingSummaryIsLoading = true;
  List<Map<String, dynamic>> _vendorOutstandingDetail = [];
  int _vendorOutstandingDetailPageNo = 1;
  int _vendorOutstandingDetailMaxPage = 0;
  double _vendorOutstandingDetailTotalBalance = 0;
  bool _vendorOutstandingDetailIsLoading = true;
  GroupByReport _groupByReport;
  String _groupBy = '';
  ViewReport _viewReport;
  String _viewRpt = '';
  Map _userSelectedBranch = {};
  bool _pdfLoading = false;
  Map _formData = {
    'group_by': '',
    'vendor': '',
    'branch': '',
    'viewReport': '',
    'branchList': '',
    'vendorList': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/vendor/vendor-outstanding/form',
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
      _getVendorOutstandingConsolidatedList();
    } else if (_viewRpt == 'Summary') {
      _vendorOutstandingSummary.clear();
      _vendorOutstandingSummaryIsLoading = true;
      _vendorOutstandingSummaryPageNo = 1;
      _getVendorOutstandingSummary();
    } else if (_viewRpt == 'Detail') {
      _vendorOutstandingDetail.clear();
      _vendorOutstandingDetailIsLoading = true;
      _vendorOutstandingDetailPageNo = 1;
      _getVendorOutstandingDetail();
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
    _tenantAuth = Provider.of<TenantAuth>(context);
    _vendorReportsProvider = Provider.of<VendorReportsProvider>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  void onConsolidateReportScrollEnd() {
    if (_consolidateReportMaxPage > _consolidateReportpageNo) {
      setState(() {
        _consolidateReportpageNo += 1;
        _getVendorOutstandingConsolidatedList();
      });
    }
  }

  Future<void> _getVendorOutstandingConsolidatedList() async {
    try {
      Map response =
          await _vendorReportsProvider.getVendorOutstandingConsolidatedReport(
        _groupBy.toLowerCase(),
        _formData['vendor'],
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
      return _consolidatedList;
    } on HttpException catch (error) {
      setState(() {
        _consolidateReportIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    } on SocketException catch (_) {
      setState(() {
        _consolidateReportIsLoading = false;
      });
      utils.handleErrorResponse(
          _screenContext, 'Please check your internet connection!', 'tenant');
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

  void onVendorOutstandingSummaryScrollEnd() {
    if (_vendorOutstandingSummaryMaxPage > _vendorOutstandingSummaryPageNo) {
      setState(() {
        _vendorOutstandingSummaryPageNo += 1;
        _getVendorOutstandingSummary();
      });
    }
  }

  Future<void> _getVendorOutstandingSummary() async {
    try {
      Map response = await _vendorReportsProvider.getVendorOutstandingSummary(
        _groupBy.toLowerCase(),
        _formData['vendor'],
        _formData['branch'],
        _vendorOutstandingSummaryPageNo,
      );
      _vendorOutstandingSummaryMaxPage = response['pageContext']['totalPages'];
      _vendorOutstandingSummaryTotalBalance =
          double.parse(response['total'].toString());
      List data = response['records'];
      setState(() {
        _vendorOutstandingSummaryIsLoading = false;
        addVendorOutstandingSummary(data);
      });
    } on HttpException catch (error) {
      setState(() {
        _vendorOutstandingSummaryIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    } on SocketException catch (error) {
      print(error.message);
      utils.handleErrorResponse(
          _screenContext, 'Please check your internet connection!', 'tenant');
    }
  }

  void addVendorOutstandingSummary(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _vendorOutstandingSummary.addAll(value.map(
        (e) {
          return {
            'vendorId': e['vendorId'],
            'vendorName': e['vendorName'],
            'branchId': e['branchId'],
            'branchName': e['branchName'],
            'closing': e['closing'],
          };
        },
      ).toList());
    }
  }

  void onVendorOutstandingDetailScrollEnd() {
    if (_vendorOutstandingDetailMaxPage > _vendorOutstandingDetailPageNo) {
      setState(() {
        _vendorOutstandingDetailPageNo += 1;
        _getVendorOutstandingDetail();
      });
    }
  }

  Future<void> _getVendorOutstandingDetail() async {
    try {
      Map response = await _vendorReportsProvider.getVendorOutstandingDetail(
        _groupBy.toLowerCase(),
        _formData['vendor'],
        _formData['branch'],
        _vendorOutstandingDetailPageNo,
      );
      _vendorOutstandingDetailMaxPage = response['pageContext']['totalPages'];
      _vendorOutstandingDetailTotalBalance =
          double.parse(response['total'].toString());
      List data = response['records'];
      setState(() {
        _vendorOutstandingDetailIsLoading = false;
        addVendorOutstandingDetail(data);
      });
    } catch (error) {
      setState(() {
        _vendorOutstandingDetailIsLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void addVendorOutstandingDetail(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _vendorOutstandingDetail.addAll(value.map(
        (e) {
          String refNo = e['refNo'].toString().replaceAll('null', '');
          String voucherNo = e['voucherNo'].toString().replaceAll('null', '');
          return {
            'vendorId': e['vendorId'],
            'vendorName': e['vendorName'],
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

  Future<void> _getVendorOutstandingPrintData() async {
    try {
      final response =
          await _vendorReportsProvider.getVendorOutstandingPrintData(
        {
          'branches': _formData['branch'],
          'vendors': _formData['vendor'],
          'groupBy': _groupBy.toLowerCase(),
        },
        _userSelectedBranch['id'],
        _viewRpt == 'Consolidate' ? 'consolidated' : _viewRpt.toLowerCase(),
      );
      utils.downloadFile(response, 'Vendor_Outstanding_$_viewRpt').then(
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
                'Vendor Outstanding',
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
                  _getVendorOutstandingPrintData();
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
                      VendorOutstandingHeader(
                        formData: _formData,
                      ),
                      _viewRpt == 'Consolidate'
                          ? Expanded(
                              child: VendorOutstandingConsolidatedReport(
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
                                  child: VendorOutstandingSummary(
                                    formData: {
                                      'groupBy': _groupBy.toLowerCase(),
                                      'pageNo': _vendorOutstandingSummaryPageNo,
                                      'totalBalance':
                                          _vendorOutstandingSummaryTotalBalance,
                                      'isLoading':
                                          _vendorOutstandingSummaryIsLoading,
                                      'maxPage':
                                          _vendorOutstandingSummaryMaxPage,
                                    },
                                    list: _vendorOutstandingSummary,
                                    onScrollEnd:
                                        onVendorOutstandingSummaryScrollEnd,
                                  ),
                                )
                              : _viewRpt == 'Detail'
                                  ? Expanded(
                                      child: VendorOutstandingDetail(
                                        formData: {
                                          'groupBy': _groupBy.toLowerCase(),
                                          'pageNo':
                                              _vendorOutstandingDetailPageNo,
                                          'totalBalance':
                                              _vendorOutstandingDetailTotalBalance,
                                          'isLoading':
                                              _vendorOutstandingDetailIsLoading,
                                          'maxPage':
                                              _vendorOutstandingDetailMaxPage,
                                        },
                                        list: _vendorOutstandingDetail,
                                        onScrollEnd:
                                            onVendorOutstandingDetailScrollEnd,
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
