import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/reports/account_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/report/report_book.dart';
import 'package:auditplusmobile/widgets/shared/report/report_book_header.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class AccountBookScreen extends StatefulWidget {
  @override
  _AccountBookScreenState createState() => _AccountBookScreenState();
}

class _AccountBookScreenState extends State<AccountBookScreen> {
  BuildContext _screenContext;
  AccountReportsProvider _accountReportsProvider;
  TenantAuth _tenantAuth;
  List<Map<String, dynamic>> _accountBookList = [];
  int _pageNo = 1;
  double _totalCredit = 0;
  double _totaldebit = 0;
  double _opening = 0;
  double _closing = 0;
  bool _isLoading = true;
  bool _pdfLoading = false;
  Map _userSelectedBranch = {};
  bool _hasMorePages = false;
  var inputFromDate;
  var outputFromDate;
  var inputToDate;
  var outputToDate;
  Map _formData = {
    'account': '',
    'fromDate': '',
    'toDate': '',
    'branchList': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/account/account-book/form', arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _accountBookList.clear();
          _isLoading = true;
        });
        _getAccountBookList();
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
    _accountReportsProvider = Provider.of<AccountReportsProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_hasMorePages == true) {
      setState(() {
        _pageNo += 1;
        _getAccountBookList();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getAccountBookList() async {
    try {
      inputFromDate = constants.defaultDate.parse(_formData['fromDate']);
      outputFromDate = constants.isoDateFormat.format(inputFromDate);
      inputToDate = constants.defaultDate.parse(_formData['toDate']);
      outputToDate = constants.isoDateFormat.format(inputToDate);
      Map response = await _accountReportsProvider.getAccountBook(
        outputFromDate,
        outputToDate,
        _formData['account']['id'],
        _formData['branch'],
        _pageNo,
      );
      _totalCredit = double.parse(response['balance']['credit'].toString());
      _totaldebit = double.parse(response['balance']['debit'].toString());
      _opening = double.parse(response['balance']['opening'].toString());
      _closing = double.parse(response['balance']['closing'].toString());
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addAccountBook(data);
      });
      return _accountBookList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addAccountBook(List data) {
    _accountBookList.addAll(
      data.map(
        (elm) {
          return {
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'particulars': elm['particulars'].toString().replaceAll('null', ''),
            'voucherType': elm['voucherName'],
            'refNo': elm['refNo'].toString().replaceAll('null', ''),
            'credit': elm['credit'],
            'debit': elm['debit'],
          };
        },
      ).toList(),
    );
  }

  bool _hasFormData() {
    return _formData['account'] != '' ||
        _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '' ||
        _formData['branchList'] != '';
  }

  Future<void> _getAccountBookPrintData() async {
    try {
      final response = await _accountReportsProvider.getAccountBookPrintData(
        outputFromDate,
        outputToDate,
        _formData['account']['id'],
        _formData['branch'],
        _userSelectedBranch['id'],
      );
      utils.downloadFile(response, 'Account_Book_Report').then(
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
                'Account Book',
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
                  _getAccountBookPrintData();
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
                        reportName: 'account',
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: ReportBook(
                                formData: {
                                  'pageNo': _pageNo,
                                  'credit': _totalCredit,
                                  'debit': _totaldebit,
                                  'opening': _opening,
                                  'closing': _closing,
                                  'isLoading': _isLoading,
                                  'hasMorePages': _hasMorePages,
                                  'reportName': 'Account',
                                },
                                list: _accountBookList,
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
