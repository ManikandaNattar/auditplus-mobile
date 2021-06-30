import 'package:auditplusmobile/providers/reports/account_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/generate_report_form.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/account/account_outstanding/account_outstanding_detail.dart';
import 'package:auditplusmobile/widgets/tenant/reports/account/account_outstanding/account_outstanding_header.dart';
import 'package:auditplusmobile/widgets/tenant/reports/account/account_outstanding/account_outstanding_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import './account_outstanding_consolidated_report.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class AccountOutstandingScreen extends StatefulWidget {
  @override
  _AccountOutstandingScreenState createState() =>
      _AccountOutstandingScreenState();
}

class _AccountOutstandingScreenState extends State<AccountOutstandingScreen> {
  BuildContext _screenContext;
  AccountReportsProvider _accountReportsProvider;
  List<Map<String, dynamic>> _consolidatedList = [];
  int _consolidateReportpageNo = 1;
  double _consolidateReportTotalBalance = 0;
  bool _consolidateReportIsLoading = true;
  bool _consolidateReportHasMorePages = false;
  List<Map<String, dynamic>> _accountOutstandingSummary = [];
  int _accountOutstandingSummaryPageNo = 1;
  bool _accountOutstandingSummaryHasMorePages = false;
  double _accountOutstandingSummaryTotalBalance = 0;
  bool _accountOutstandingSummaryIsLoading = true;
  List<Map<String, dynamic>> _accountOutstandingDetail = [];
  int _accountOutstandingDetailPageNo = 1;
  bool _accountOutstandingDetailHasMorePages = false;
  double _accountOutstandingDetailTotalBalance = 0;
  bool _accountOutstandingDetailIsLoading = true;
  bool _pdfLoading = false;
  List _groupByList = [];
  String _groupBy = '';
  String orderBy = '';
  Map _formData = {
    'groupBy': '',
    'orderBy': '',
    'account': '',
    'branch': '',
    'viewReport': '',
    'branchList': '',
    'accountList': '',
    'accountTypes': '',
    'accountTypesList': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/account/account-outstanding/form',
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
    _groupByList = _formData['groupBy'];
    orderBy = _formData['orderBy'];
    if (_groupByList.length == 1) {
      _groupBy = _groupByList[0];
      _consolidatedList.clear();
      _consolidateReportIsLoading = true;
      _consolidateReportpageNo = 1;
      _getAccountOutstandingConsolidatedList();
    } else if (_groupByList.length == 2) {
      _groupBy = orderBy.toLowerCase();
      _accountOutstandingSummary.clear();
      _accountOutstandingSummaryIsLoading = true;
      _accountOutstandingSummaryPageNo = 1;
      _getAccountOutstandingSummary();
    } else if (_groupByList.length == 0) {
      _groupBy = orderBy.toLowerCase();
      _accountOutstandingDetail.clear();
      _accountOutstandingDetailIsLoading = true;
      _accountOutstandingDetailPageNo = 1;
      _getAccountOutstandingDetail();
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
    _accountReportsProvider = Provider.of<AccountReportsProvider>(context);
    super.didChangeDependencies();
  }

  void onConsolidateReportScrollEnd() {
    if (_consolidateReportHasMorePages == true) {
      setState(() {
        _consolidateReportpageNo += 1;
        _getAccountOutstandingConsolidatedList();
      });
    }
  }

  Future<void> _getAccountOutstandingConsolidatedList() async {
    try {
      List accountList = _formData['account'];
      List branchList = _formData['branch'];
      Map response = await _accountReportsProvider.getAccountOutstandingReport(
        _formData['accountTypes'],
        _groupByList.isEmpty ? null : _groupByList,
        _consolidateReportpageNo,
        orderBy,
        {
          'account': accountList.isEmpty ? null : accountList,
          'branch': branchList.isEmpty ? null : branchList,
        },
      );

      _consolidateReportHasMorePages = utils.checkHasMorePages(
        response['pageContext'],
        _consolidateReportpageNo,
      );
      _consolidateReportTotalBalance =
          double.parse(response['summary']['closing'].toString());
      List data = response['records'];
      setState(() {
        _consolidateReportIsLoading = false;
        addConsolidatedReport(data);
      });
    } catch (error) {
      setState(() {
        _consolidateReportIsLoading = false;
      });
      if (error.message.contains('Bad Request')) {
        showGenerationReportForm(
          context: _screenContext,
          menuName: 'ACCOUNT OUTSTANDING',
        ).then(
          (value) {
            if (value != null) {
              _checkReportVisibleToUser();
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
    }
  }

  void addConsolidatedReport(List data) {
    _consolidatedList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm[_groupBy + 'Id'],
            'particulars':
                elm[_groupBy + 'Name'] == null ? '' : elm[_groupBy + 'Name'],
            'closing': elm['closing'],
          };
        },
      ).toList(),
    );
  }

  void onAccountOutstandingSummaryScrollEnd() {
    if (_accountOutstandingSummaryHasMorePages == true) {
      setState(() {
        _accountOutstandingSummaryPageNo += 1;
        _getAccountOutstandingSummary();
      });
    }
  }

  Future<void> _getAccountOutstandingSummary() async {
    try {
      List accountList = _formData['account'];
      List branchList = _formData['branch'];
      Map response = await _accountReportsProvider.getAccountOutstandingReport(
        _formData['accountTypes'],
        _groupByList.isEmpty ? null : _groupByList,
        _accountOutstandingSummaryPageNo,
        orderBy,
        {
          'account': accountList.isEmpty ? null : accountList,
          'branch': branchList.isEmpty ? null : branchList,
        },
      );
      _accountOutstandingSummaryHasMorePages = utils.checkHasMorePages(
        response['pageContext'],
        _accountOutstandingSummaryPageNo,
      );

      _accountOutstandingSummaryTotalBalance =
          double.parse(response['summary']['closing'].toString());
      List data = response['records'];
      setState(() {
        _accountOutstandingSummaryIsLoading = false;
        addAccountOutstandingSummary(data);
      });
    } catch (error) {
      setState(() {
        _accountOutstandingSummaryIsLoading = false;
      });
      if (error.message.contains('Bad Request')) {
        showGenerationReportForm(
          context: _screenContext,
          menuName: 'ACCOUNT OUTSTANDING',
        ).then(
          (value) {
            if (value != null) {
              _checkReportVisibleToUser();
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
    }
  }

  void addAccountOutstandingSummary(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _accountOutstandingSummary.addAll(value.map(
        (e) {
          return {
            'accountId': e['accountId'],
            'accountName': e['accountName'] == null ? '' : e['accountName'],
            'branchId': e['branchId'],
            'branchName': e['branchName'] == null ? '' : e['branchName'],
            'closing': e['closing'],
          };
        },
      ).toList());
    }
  }

  void onAccountOutstandingDetailScrollEnd() {
    if (_accountOutstandingDetailHasMorePages == true) {
      setState(() {
        _accountOutstandingDetailPageNo += 1;
        _getAccountOutstandingDetail();
      });
    }
  }

  Future<void> _getAccountOutstandingDetail() async {
    try {
      List accountList = _formData['account'];
      List branchList = _formData['branch'];
      Map response = await _accountReportsProvider.getAccountOutstandingReport(
        _formData['accountTypes'],
        _groupByList.isEmpty ? null : _groupByList,
        _accountOutstandingDetailPageNo,
        orderBy,
        {
          'account': accountList.isEmpty ? null : accountList,
          'branch': branchList.isEmpty ? null : branchList,
        },
      );
      _accountOutstandingDetailHasMorePages = utils.checkHasMorePages(
        response['pageContext'],
        _accountOutstandingDetailPageNo,
      );
      _accountOutstandingDetailTotalBalance =
          double.parse(response['summary']['closing'].toString());
      List data = response['records'];
      setState(() {
        _accountOutstandingDetailIsLoading = false;
        addAccountOutstandingDetail(data);
      });
    } catch (error) {
      setState(() {
        _accountOutstandingDetailIsLoading = false;
      });
      if (error.message.contains('Bad Request')) {
        showGenerationReportForm(
          context: _screenContext,
          menuName: 'ACCOUNT OUTSTANDING',
        ).then(
          (value) {
            if (value != null) {
              _checkReportVisibleToUser();
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
    }
  }

  void addAccountOutstandingDetail(List data) {
    var groupByData =
        groupBy(data, (obj) => obj[_groupBy.toLowerCase() + 'Id']);
    for (final query in groupByData.entries) {
      final value = query.value;
      _accountOutstandingDetail.addAll(value.map(
        (e) {
          return {
            'accountId': e['accountId'],
            'accountName': e['accountName'],
            'branchId': e['branchId'],
            'branchName': e['branchName'],
            'closing': e['closing'],
            'opening': e['billAmount'],
            'effDate':
                constants.defaultDate.format(DateTime.parse(e['effDate'])),
            'days': e['days'] == null ? 0 : e['days'],
            'voucherType': e['voucherType'].toString().replaceAll('null', ''),
            'refNo': e['refNo'].toString().replaceAll('null', ''),
          };
        },
      ).toList());
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
                'Account Outstanding',
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
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Generate Account Outstanding') {
                  showGenerationReportForm(
                    context: _screenContext,
                    menuName: 'ACCOUNT OUTSTANDING',
                  ).then(
                    (value) {
                      if (value != null) {
                        _checkReportVisibleToUser();
                      }
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  'Generate Account Outstanding',
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
                      AccountOutstandingHeader(
                        formData: _formData,
                      ),
                      _formData['groupBy'] == ''
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : _groupByList.length == 1
                              ? Expanded(
                                  child: AccountOutstandingConsolidatedReport(
                                    formData: {
                                      'groupBy': _groupBy,
                                      'pageNo': _consolidateReportpageNo,
                                      'totalBalance':
                                          _consolidateReportTotalBalance,
                                      'isLoading': _consolidateReportIsLoading,
                                      'hasMorePages':
                                          _consolidateReportHasMorePages,
                                    },
                                    list: _consolidatedList,
                                    onScrollEnd: onConsolidateReportScrollEnd,
                                  ),
                                )
                              : _groupByList.length == 2
                                  ? Expanded(
                                      child: AccountOutstandingSummary(
                                        formData: {
                                          'groupBy': _groupBy.toLowerCase(),
                                          'pageNo':
                                              _accountOutstandingSummaryPageNo,
                                          'totalBalance':
                                              _accountOutstandingSummaryTotalBalance,
                                          'isLoading':
                                              _accountOutstandingSummaryIsLoading,
                                          'hasMorePages':
                                              _accountOutstandingSummaryHasMorePages,
                                        },
                                        list: _accountOutstandingSummary,
                                        onScrollEnd:
                                            onAccountOutstandingSummaryScrollEnd,
                                      ),
                                    )
                                  : Expanded(
                                      child: AccountOutstandingDetail(
                                        formData: {
                                          'groupBy': _groupBy.toLowerCase(),
                                          'pageNo':
                                              _accountOutstandingDetailPageNo,
                                          'totalBalance':
                                              _accountOutstandingDetailTotalBalance,
                                          'isLoading':
                                              _accountOutstandingDetailIsLoading,
                                          'hasMorePages':
                                              _accountOutstandingDetailHasMorePages,
                                        },
                                        list: _accountOutstandingDetail,
                                        onScrollEnd:
                                            onAccountOutstandingDetailScrollEnd,
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
