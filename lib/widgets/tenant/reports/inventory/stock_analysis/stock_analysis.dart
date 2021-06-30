import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_footer.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../utils.dart' as utils;
import 'stock_analysis_header.dart';

class StockAnalysis extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  StockAnalysis({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  Widget _showStockAnalysis(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: formData['hasMorePages'] == true
                    ? list.length + 1
                    : list.length,
                itemBuilder: (_, index) {
                  if (index == list.length) {
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
                                      list[index]['name'],
                                      style: list[index]['name'] ==
                                              'Not Applicable'
                                          ? Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                letterSpacing: 0.5,
                                                color: Colors.red,
                                              )
                                          : Theme.of(context)
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
                                      list[index]['stock'].toString(),
                                      style: list[index]['stock'] < 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                                color: Colors.red,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                                color: Colors.green,
                                              ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Visibility(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        double.parse(
                                                list[index]['value'].toString())
                                            .toStringAsFixed(2),
                                        style: list[index]['value'] < 0
                                            ? Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                  letterSpacing: 0.5,
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                )
                                            : Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                  letterSpacing: 0.5,
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    visible: utils.checkMenuWiseAccess(
                                      context,
                                      [
                                        'rpt.inv.stkvalsum',
                                      ],
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
                      if (formData['filterFormName'] == 'report' &&
                          formData['stockAnalysisGroupBy'] !=
                              StockAnalysisGroupBy.Branch) {
                        Navigator.of(context).pushNamed(
                          '/reports/inventory/stock-analysis/summary',
                          arguments: {
                            'data': list[index],
                            'stockAnalysisGroupBy':
                                formData['stockAnalysisGroupBy'],
                            'filterFormName': 'summary',
                            'asOnDate': formData['headerData']['asOnDate'],
                            'rptBranchList': formData['headerData']
                                ['rptBranchList'],
                          },
                        );
                      } else if (formData['filterFormName'] == 'summary' &&
                          formData['stockAnalysisGroupBy'] !=
                              StockAnalysisGroupBy.Branch &&
                          formData['stockAnalysisGroupBy'] !=
                              StockAnalysisGroupBy.Inventory) {
                        Navigator.of(context).pushNamed(
                          '/reports/inventory/stock-analysis/detail',
                          arguments: {
                            'summaryData': list[index],
                            'reportData': arguments['data'],
                            'stockAnalysisGroupBy':
                                formData['stockAnalysisGroupBy'],
                            'filterFormName': 'detail',
                            'asOnDate': formData['headerData']['asOnDate'],
                            'rptBranchList': formData['headerData']
                                ['rptBranchList'],
                          },
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _showStockAnalysisHeader(BuildContext context) {
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
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Text(
                      'PARTICULARS',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      'STOCK',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        'VALUE',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                    visible: utils.checkMenuWiseAccess(
                      context,
                      [
                        'rpt.inv.stkvalsum',
                      ],
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

  @override
  Widget build(BuildContext context) {
    addScrollListener();
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StockAnalysisHeader(
                formData: formData['headerData'],
              ),
              SizedBox(
                height: 5.0,
              ),
              _showStockAnalysisHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showStockAnalysis(context),
              StockAnalysisFooter(
                formData: {
                  'totalStock': formData['totalStock'],
                  'totalValues': formData['totalValue'],
                },
              ),
            ],
          );
  }
}
