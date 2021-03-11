import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../main_drawer/main_drawer.dart';
import './../../../../shared/list_view_app_bar.dart';
import './../../../../../providers/contacts/vendor_provider.dart';
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
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'emailFilterKey': 'a..',
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
      });
      Map response = await _vendorProvider.getVendorList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      hasMorePages = response['hasMorePages'];
      List data = response['results'];
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
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['contactInfo']['mobile']
                    .toString()
                    .replaceAll('null', '')
                    .isEmpty
                ? elm['contactInfo']['alternateMobile']
                    .toString()
                    .replaceAll('null', '')
                : elm['contactInfo']['mobile']
                    .toString()
                    .replaceAll('null', ''),
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
      'nameFilterKey': '.a.',
      'aliasNameFilterKey': 'a..',
      'emailFilterKey': 'a..',
      'filterFormName': 'Vendor',
    };
    _vendorList.clear();
    _getvendorList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/contacts/manage/contacts-filter-form',
            arguments: _formData)
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
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'emailFilterKey': 'a..',
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
          routeName: '/contacts/manage/vendor/detail',
          list: _vendorList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Vendor',
            onPressed: () =>
                Navigator.of(context).pushNamed('/contacts/manage/vendor/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'contacts.vendor.create',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/contacts');
        return true;
      },
    );
  }
}
