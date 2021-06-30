import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/inventory_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/generate_report_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class StockAnalysisScreen extends StatefulWidget {
  @override
  _StockAnalysisScreenState createState() => _StockAnalysisScreenState();
}

class _StockAnalysisScreenState extends State<StockAnalysisScreen> {
  BuildContext _screenContext;
  TenantAuth _tenantAuth;
  InventoryReportsProvider _inventoryReportsProvider;
  List<Map<String, dynamic>> _stockAnalysisReport = [];
  List<Map<String, dynamic>> _assignedBranches = [];
  List rptBranchList = [];
  int _pageNo = 1;
  var _totalStock = 0.0;
  var _totalValue = 0.0;
  bool _isLoading = true;
  bool _hasMorePages = false;
  StockAnalysisGroupBy _stockAnalysisGroupBy = StockAnalysisGroupBy.Inventory;
  String _analysisGroupBy = '';
  Map _formData = {
    'stockAnalysisGroupBy': '',
    'inventory': '',
    'inventoryList': '',
    'manufacturerList': '',
    'manufacturer': '',
    'section': '',
    'sectionList': '',
    'branch': '',
    'branchList': '',
    'asOnDate': '',
    'rptBranchList': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/inventory/stock-analysis/form',
            arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _stockAnalysisReport.clear();
          _isLoading = true;
          _stockAnalysisGroupBy = _formData['stockAnalysisGroupBy'];
          _analysisGroupBy = _stockAnalysisGroupBy.toString().split('.').last;
        });
        _getStockAnalysisReport();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _inventoryReportsProvider = Provider.of<InventoryReportsProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _assignedBranches = _tenantAuth.assignedBranches;
    _getStockAnalysisReport();
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_hasMorePages == true) {
      setState(() {
        _pageNo += 1;
        _getStockAnalysisReport();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getStockAnalysisReport() async {
    try {
      List _idList = _formData['${_analysisGroupBy.toLowerCase()}'] == ''
          ? null
          : _formData['${_analysisGroupBy.toLowerCase()}'];
      Map<String, dynamic> response =
          await _inventoryReportsProvider.getStockAnalysisReport(
        _pageNo,
        _analysisGroupBy.toLowerCase(),
        _idList == null || _idList.isEmpty
            ? null
            : {
                _analysisGroupBy.toLowerCase():
                    _formData['${_analysisGroupBy.toLowerCase()}'],
              },
      );
      _totalStock = response['summary']['closing'];
      _totalValue = response['summary']['value'];
      _formData['asOnDate'] = response['wkSessionConfig']['asOnDate'];
      _formData['rptBranchList'] =
          getBranchList(response['wkSessionConfig']['branch']);
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addStockAnalysis(data);
      });
      return _stockAnalysisReport;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (error.message.contains('Bad Request')) {
        showGenerationReportForm(
          context: _screenContext,
          menuName: 'STOCK ANALYSIS',
          reportBranchList: rptBranchList,
        ).then(
          (value) {
            if (value != null) {
              _isLoading = true;
              _getStockAnalysisReport();
            }
          },
        );
      } else {
        utils.handleErrorResponse(
          _screenContext,
          error.message,
          'tenant',
        );
      }
      return [];
    }
  }

  List getBranchList(List reportIdList) {
    rptBranchList = [];
    for (int i = 0; i <= reportIdList.length - 1; i++) {
      rptBranchList.add(_assignedBranches
          .where((element) => element['id'] == reportIdList[i])
          .first);
    }
    return rptBranchList;
  }

  void addStockAnalysis(List data) {
    _stockAnalysisReport.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'name': elm['name'].toString().replaceAll(
                  'null',
                  'Not Applicable',
                ),
            'stock': elm['closing'],
            'value': elm['value'],
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
                'Stock Analysis',
              ),
              AppBarBranchSelection(
                selectedBranch: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () => _routeToForm(),
            ),
            Visibility(
              child: IconButton(
                icon: Icon(
                  Icons.search_off,
                ),
                onPressed: () {
                  setState(() {
                    _pageNo = 1;
                    _stockAnalysisReport.clear();
                    _isLoading = true;
                    _analysisGroupBy = '';
                    _formData['inventory'] = '';
                    _formData['inventoryList'] = '';
                    _formData['manufacturerList'] = '';
                    _formData['manufacturer'] = '';
                    _formData['section'] = '';
                    _formData['sectionList'] = '';
                    _formData['stockAnalysisGroupBy'] = '';
                  });
                  _getStockAnalysisReport();
                },
              ),
              visible: _analysisGroupBy.isNotEmpty,
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Generate Stock Analysis') {
                  showGenerationReportForm(
                    context: _screenContext,
                    menuName: 'STOCK ANALYSIS',
                    reportBranchList: rptBranchList,
                  ).then(
                    (value) {
                      if (value != null) {
                        _isLoading = true;
                        _getStockAnalysisReport();
                      }
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  'Generate Stock Analysis',
                  'Download PDF',
                ].map(
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
                      Expanded(
                        child: StockAnalysis(
                          formData: {
                            'pageNo': _pageNo,
                            'totalStock': _totalStock,
                            'totalValue': _totalValue,
                            'isLoading': _isLoading,
                            'hasMorePages': _hasMorePages,
                            'stockAnalysisGroupBy':
                                _stockAnalysisGroupBy == null
                                    ? StockAnalysisGroupBy.Inventory
                                    : _stockAnalysisGroupBy,
                            'filterFormName': 'report',
                            'headerData': _formData,
                          },
                          list: _stockAnalysisReport,
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
