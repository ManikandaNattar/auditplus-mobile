import 'package:auditplusmobile/providers/reports/sale_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sales_by_incharge/sales_by_incharge.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sales_by_incharge/sales_by_incharge_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class SalesByInchargeScreen extends StatefulWidget {
  @override
  _SalesByInchargeScreenState createState() => _SalesByInchargeScreenState();
}

class _SalesByInchargeScreenState extends State<SalesByInchargeScreen> {
  BuildContext _screenContext;
  SaleReportsProvider _saleReportsProvider;
  List<Map<String, dynamic>> _salesByInchargeList = [];
  int _pageNo = 1;
  bool _isLoading = true;
  bool _pdfLoading = false;
  bool _hasMorePages = false;
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'branchList': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/sales/sales-by-incharge/form',
            arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _salesByInchargeList.clear();
          _isLoading = true;
        });
        _getSalesByInchargeList();
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
    _saleReportsProvider = Provider.of<SaleReportsProvider>(context);
    super.didChangeDependencies();
  }

  void onScrollEnd() {
    if (_hasMorePages == true) {
      setState(() {
        _pageNo += 1;
        _getSalesByInchargeList();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getSalesByInchargeList() async {
    try {
      Map response = await _saleReportsProvider.getSalesByIncharge(
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
        _formData['branch'],
        _pageNo,
      );
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addSalesByIncharge(data);
      });
      return _salesByInchargeList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addSalesByIncharge(List data) {
    _salesByInchargeList.addAll(
      data.map(
        (elm) {
          return {
            'incharge': elm['incharge'],
            'amount': elm['amount'],
            'taxableAmount': elm['taxableAmount'],
          };
        },
      ).toList(),
    );
  }

  bool _hasFormData() {
    return _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '' ||
        _formData['branchList'] != '';
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
                'Sale By Incharge',
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
              onPressed: () async {},
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
                      SalesByInchargeHeader(
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: SalesByIncharge(
                                formData: {
                                  'isLoading': _isLoading,
                                  'hasMorePages': _hasMorePages,
                                },
                                list: _salesByInchargeList,
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
