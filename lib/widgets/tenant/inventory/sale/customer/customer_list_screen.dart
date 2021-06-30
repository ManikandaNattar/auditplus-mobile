import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../main_drawer/main_drawer.dart';
import './../../../../shared/list_view_app_bar.dart';
import '../../../../../providers/inventory/customer_provider.dart';
import './../../../../../utils.dart' as utils;
import '../../../../shared/general_list_view.dart';

class CustomerListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> _customerList = [];
  CustomerProvider _customerProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'email': '',
    'mobile': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'emailFilterKey': 'a..',
    'mobileFilterKey': 'a..',
    'filterFormName': 'Customer',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getCustomerList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _getCustomerList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getCustomerList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
        {'mobile': _formData['mobileFilterKey']}: _formData['mobile'],
        {'email': _formData['emailFilterKey']}: _formData['email'],
      });
      Map response = await _customerProvider.getCustomerList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addCustomer(data);
      });
      return _customerList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addCustomer(List data) {
    _customerList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'title': elm['name'],
            'subtitle': elm['mobile'].toString().replaceAll('null', ''),
          };
        },
      ).toList(),
    );
  }

  void _appbarSearchFuntion() {
    setState(() {
      pageNo = 1;
      _isLoading = true;
    });
    _formData = {
      'name': widget._appbarSearchEditingController.text,
      'aliasName': '',
      'email': '',
      'mobile': '',
      'nameFilterKey': '.a.',
      'aliasNameFilterKey': 'a..',
      'emailFilterKey': 'a..',
      'mobileFilterKey': 'a..',
      'filterFormName': 'Customer',
    };
    _customerList.clear();
    _getCustomerList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/inventory/sale-purchase-filter-form', arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _customerList.clear();
          _getCustomerList();
        }
      },
    );
  }

  void _clearFilterPressed() {
    setState(() {
      _isLoading = true;
      pageNo = 1;
    });
    _formData = {
      'name': '',
      'aliasName': '',
      'email': '',
      'mobile': '',
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'emailFilterKey': 'a..',
      'mobileFilterKey': 'a..',
      'filterFormName': 'Customer',
    };
    _customerList.clear();
    _getCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Customer',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {});
            }
          },
        ),
        drawer: MainDrawer(),
        body: GeneralListView(
          hasMorePages: hasMorePages,
          isLoading: _isLoading,
          routeName: '/inventory/sale/customer/detail',
          list: _customerList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Customer',
            onPressed: () => Navigator.of(context)
                .pushNamed('/inventory/sale/customer/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inv.cus.cr',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/inventory');
        return true;
      },
    );
  }
}
