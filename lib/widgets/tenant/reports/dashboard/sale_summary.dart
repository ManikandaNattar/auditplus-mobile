import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../../providers/reports/dashboard_provider.dart';
import './../../../../utils.dart' as utils;

class SaleSummary extends StatefulWidget {
  @override
  _SaleSummaryState createState() => _SaleSummaryState();
}

class _SaleSummaryState extends State<SaleSummary> {
  List _summary = [];
  bool _isLoading = false;
  DashboardProvider _dashboardProvider;

  @override
  void initState() {
    utils.checkPermission();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dashboardProvider = Provider.of<DashboardProvider>(context);
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> saleSummary = await _dashboardProvider
          .loadSaleSummary(DateTime.now(), DateTime.now());
      setState(() {
        _summary = saleSummary['records'];
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _summary = [];
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
    }
  }

  double _getTotal() {
    double total = 0.0;
    if (_summary.isNotEmpty) {
      for (int i = 0; i <= _summary.length - 1; i++) {
        total += _summary[i]['total'];
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TODAY SALE SUMMARY',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _loadSummary,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : _summary.isEmpty
                      ? ShowDataEmptyImage()
                      : Column(
                          children: [
                            ..._summary
                                .map(
                                  (elm) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                      horizontal: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          elm['branch'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        Text(
                                          '\u{20B9}${elm['total'].toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            Divider(
                              height: 1.0,
                              thickness: 1.0,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TOTAL',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          fontSize: 14.0,
                                        ),
                                  ),
                                  Text(
                                    '\u{20B9}${_getTotal().toStringAsFixed(2)}',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
