import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../main_drawer/main_drawer.dart';
import './../../../../shared/list_view_app_bar.dart';
import '../../../../../providers/inventory/vendor_provider.dart';
import './../../../../../utils.dart' as utils;
import '../../../../shared/general_list_view.dart';

class VendorListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<Map<String, dynamic>> _vendorList = [];
  VendorProvider _vendorProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'email': '',
    'mobile': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'emailFilterKey': 'a..',
    'mobileFilterKey': 'a..',
    'filterFormName': 'Vendor',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getvendorList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _vendorProvider = Provider.of<VendorProvider>(context);
    _getvendorList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getvendorList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
        {'email': _formData['emailFilterKey']}: _formData['email'],
        {'mobile': _formData['mobileFilterKey']}: _formData['mobile'],
      });
      Map response = await _vendorProvider.getVendorList(
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
        addVendor(data);
      });
      return _vendorList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addVendor(List data) {
    _vendorList.addAll(
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
      'filterFormName': 'Vendor',
    };
    _vendorList.clear();
    _getvendorList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed(
      '/inventory/sale-purchase-filter-form',
      arguments: _formData,
    )
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _vendorList.clear();
          _getvendorList();
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
      'filterFormName': 'Vendor',
    };
    _vendorList.clear();
    _getvendorList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Vendor',
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
          routeName: '/inventory/purchase/vendor/detail',
          list: _vendorList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Vendor',
            onPressed: () => Navigator.of(context)
                .pushNamed('/inventory/purchase/vendor/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inv.vend.cr',
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
