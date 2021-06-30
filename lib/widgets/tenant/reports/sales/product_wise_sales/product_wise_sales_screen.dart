import 'package:auditplusmobile/providers/reports/sale_reports_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/progress_loader.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/product_wise_sales/product_wise_sales.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/product_wise_sales/product_wise_sales_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class ProductWiseSalesScreen extends StatefulWidget {
  @override
  _ProductWiseSalesScreenState createState() => _ProductWiseSalesScreenState();
}

class _ProductWiseSalesScreenState extends State<ProductWiseSalesScreen> {
  BuildContext _screenContext;
  SaleReportsProvider _saleReportsProvider;
  List<Map<String, dynamic>> _productWiseSalesList = [];
  int _pageNo = 1;
  bool _isLoading = true;
  bool _pdfLoading = false;
  bool _hasMorePages = false;
  double assetValue = 0;
  double saleValue = 0;
  double profitValue = 0;
  double sold = 0;
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'branch': '',
  };

  void _routeToForm() {
    Navigator.of(context)
        .pushNamed('/reports/sales/product-wise-sales/form',
            arguments: _formData)
        .then((result) {
      if (result != null) {
        setState(() {
          _formData = result;
          _pageNo = 1;
          _productWiseSalesList.clear();
          _isLoading = true;
        });
        _getProductWiseSalesList();
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
        _getProductWiseSalesList();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getProductWiseSalesList() async {
    try {
      Map response = await _saleReportsProvider.getProductWiseSales(
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
        _formData['branch']['id'],
        _pageNo,
      );
      assetValue = double.parse(response['summary']['assetValue'].toString());
      saleValue = double.parse(response['summary']['saleValue'].toString());
      profitValue = double.parse(response['summary']['profitValue'].toString());
      sold = double.parse(response['summary']['sold'].toString());
      List data = response['records'];
      _hasMorePages = utils.checkHasMorePages(response['pageContext'], _pageNo);
      setState(() {
        _isLoading = false;
        addProductWiseSales(data);
      });
      return _productWiseSalesList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addProductWiseSales(List data) {
    _productWiseSalesList.addAll(
      data.map(
        (elm) {
          return {
            'inventory': elm['inventory'],
            'assetValue': elm['assetValue'],
            'sold': elm['sold'],
            'saleValue': elm['saleValue'],
            'profitValue': elm['profitValue'],
            'profitPercent': elm['profitPercent']
          };
        },
      ).toList(),
    );
  }

  bool _hasFormData() {
    return _formData['branch'] != '' ||
        _formData['fromDate'] != '' ||
        _formData['toDate'] != '';
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
                'Product wise Sales',
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
                      ProductWiseSalesHeader(
                        formData: _formData,
                      ),
                      _hasFormData() == false
                          ? Expanded(
                              child: Center(
                                child: ShowDataEmptyImage(),
                              ),
                            )
                          : Expanded(
                              child: ProductWiseSales(
                                formData: {
                                  'isLoading': _isLoading,
                                  'hasMorePages': _hasMorePages,
                                  'assetValue': assetValue,
                                  'saleValue': saleValue,
                                  'profitValue': profitValue,
                                  'sold': sold,
                                },
                                list: _productWiseSalesList,
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
