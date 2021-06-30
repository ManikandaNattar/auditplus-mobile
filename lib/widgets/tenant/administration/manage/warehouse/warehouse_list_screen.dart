import 'package:auditplusmobile/providers/administration/warehouse_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class WarehouseListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _WarehouseListScreenState createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  List<Map<String, dynamic>> _warehouseList = [];
  WarehouseProvider _warehouseProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Warehouse',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getWarehouseList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _warehouseProvider = Provider.of<WarehouseProvider>(context);
    _getWarehouseList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getWarehouseList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
      });
      Map response = await _warehouseProvider.getWarehouseList(
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
        addWarehouse(data);
      });
      return _warehouseList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addWarehouse(List data) {
    _warehouseList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['name'],
            'title': elm['name'],
            'subtitle': elm['contactInfo'] == null
                ? ''
                : elm['contactInfo']['mobile'] == null
                    ? ''
                    : elm['contactInfo']['mobile'],
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
      'nameFilterKey': '.a.',
      'filterFormName': 'Warehouse',
      'aliasNameFilterKey': 'a..',
    };
    _warehouseList.clear();
    _getWarehouseList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/administration/manage/administration-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _warehouseList.clear();
          _getWarehouseList();
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
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'filterFormName': 'Warehouse',
    };
    _warehouseList.clear();
    _getWarehouseList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Warehouse',
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
          routeName: '/administration/manage/warehouse/detail',
          list: _warehouseList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Warehouse',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/warehouse/form',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/administration');
        return true;
      },
    );
  }
}
