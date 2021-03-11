import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _InventoryItemListScreenState createState() =>
      _InventoryItemListScreenState();
}

class _InventoryItemListScreenState extends State<InventoryItemListScreen> {
  List<Map<String, dynamic>> _inventoryItemList = [];
  InventoryItemProvider _inventoryItemProvider;
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  Map _formData = {
    'name': '',
    'barcode': '',
    'hsnCode': '',
    'section': '',
    'manufacturer': '',
    'tax': '',
    'nameFilterKey': 'a..',
    'barcodeFilterKey': 'a..',
    'hsnCodeFilterKey': 'a..',
    'filterFormName': 'Inventory',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getInventoryItemList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    _getInventoryItemList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getInventoryItemList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'barcode': _formData['barcodeFilterKey']}: _formData['barcode'],
        {'hsnCode': _formData['hsnCodeFilterKey']}: _formData['hsnCode'],
        {'section': 'eq'}: _formData['section'],
        {'manufacturer': 'eq'}: _formData['manufacturer'],
        {'tax': 'eq'}: _formData['tax'],
        {'head': 'eq'}: _selectedBranch['inventoryHead'],
      });
      Map response = await _inventoryItemProvider.getInventoryList(
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
        addInventoryItem(data);
      });
      return _inventoryItemList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addInventoryItem(List data) {
    _inventoryItemList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['unit']['name'],
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
      'filterFormName': 'Inventory',
      'barcode': '',
      'hsnCode': '',
      'section': '',
      'manufacturer': '',
      'tax': '',
      'barcodeFilterKey': 'a..',
      'hsnCodeFilterKey': 'a..',
    };
    _inventoryItemList.clear();
    _getInventoryItemList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/inventory/manage/inventory-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _inventoryItemList.clear();
          _getInventoryItemList();
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
      'barcode': '',
      'hsnCode': '',
      'section': '',
      'manufacturer': '',
      'tax': '',
      'nameFilterKey': 'a..',
      'barcodeFilterKey': 'a..',
      'hsnCodeFilterKey': 'a..',
      'filterFormName': 'Inventory',
    };
    _inventoryItemList.clear();
    _getInventoryItemList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Inventory',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {
                _selectedBranch = val;
                _isLoading = true;
              });
              _inventoryItemList.clear();
              _getInventoryItemList();
            }
          },
        ),
        drawer: MainDrawer(),
        body: GeneralListView(
          hasMorePages: hasMorePages,
          isLoading: _isLoading,
          routeName: '/inventory/manage/inventory-item/detail',
          list: _inventoryItemList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Inventory',
            onPressed: () => Navigator.of(context).pushNamed(
              '/inventory/manage/inventory-item/form',
            ),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inventory.inventory.create',
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
