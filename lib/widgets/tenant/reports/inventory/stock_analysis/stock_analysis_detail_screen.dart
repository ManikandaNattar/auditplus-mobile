import 'package:auditplusmobile/providers/reports/inventory_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'stock_analysis.dart';
import './../../../../../utils.dart' as utils;

class StockAnalysisDetailScreen extends StatefulWidget {
  @override
  _StockAnalysisDetailScreenState createState() =>
      _StockAnalysisDetailScreenState();
}

class _StockAnalysisDetailScreenState extends State<StockAnalysisDetailScreen> {
  BuildContext _screenContext;
  InventoryReportsProvider _inventoryReportsProvider;
  List<Map<String, dynamic>> _stockAnalysisList = [];
  int _pageNo = 1;
  var _totalStock = 0.0;
  var _totalValue = 0.0;
  bool _isLoading = true;
  bool _hasMorePages = false;
  Map arguments = {};
  String stockAnalysisGroupBy = '';

  @override
  void didChangeDependencies() {
    _inventoryReportsProvider = Provider.of<InventoryReportsProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
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
      stockAnalysisGroupBy = arguments['stockAnalysisGroupBy']
          .toString()
          .split('.')
          .last
          .toLowerCase();
      Map<String, dynamic> response =
          await _inventoryReportsProvider.getStockAnalysisReport(
        _pageNo,
        'inventory',
        {
          'branch': [arguments['summaryData']['id']],
          stockAnalysisGroupBy: [arguments['reportData']['id']]
        },
      );
      _totalStock = response['summary']['closing'];
      _totalValue = response['summary']['value'];
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addStockAnalysis(data);
      });
      return _stockAnalysisList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addStockAnalysis(List data) {
    _stockAnalysisList.addAll(
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
                'Stock Detail',
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
                Icons.picture_as_pdf,
                size: 24.0,
              ),
              onPressed: () => null,
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
                                arguments['stockAnalysisGroupBy'],
                            'filterFormName': 'detail',
                            'headerData': {
                              'stockAnalysisGroupBy':
                                  StockAnalysisGroupBy.Branch,
                              'branchList': [arguments['summaryData']],
                              'asOnDate': arguments['asOnDate'],
                              'rptBranchList': arguments['rptBranchList'],
                              'filterFormName': 'detail',
                            },
                          },
                          list: _stockAnalysisList,
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
        Navigator.of(context).pop();
        return true;
      },
    );
  }
}
