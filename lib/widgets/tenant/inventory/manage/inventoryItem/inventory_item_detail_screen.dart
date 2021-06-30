import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemDetailScreen extends StatefulWidget {
  @override
  _InventoryItemDetailScreenState createState() =>
      _InventoryItemDetailScreenState();
}

class _InventoryItemDetailScreenState extends State<InventoryItemDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _inventoryItemData = Map();
  InventoryItemProvider _inventoryItemProvider;
  String inventoryId;
  String inventoryName;
  List _menuList = [];

  @override
  void initState() {
    _checkVisibility();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getInventory() async {
    try {
      _inventoryItemData =
          await _inventoryItemProvider.getInventory(inventoryId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _inventoryItemData['name'],
          'Unit': _inventoryItemData['unit']['name'],
          'Precision': _inventoryItemData['precision'].toString(),
          'Tax': _inventoryItemData['tax']['displayName'],
        },
        'PRODUCT INFO': {
          'Section': _inventoryItemData['section'] == null
              ? null
              : _inventoryItemData['section']['name'],
          'Manufacturer': _inventoryItemData['manufacturer'] == null
              ? null
              : _inventoryItemData['manufacturer']['name'],
          'Barcode': _inventoryItemData['barcode'],
          'HSN Code': _inventoryItemData['hsnCode'],
        },
        'CONFIGURATION INFO': {
          'Enable Multiple Batches': _inventoryItemData['bwd'].toString(),
          'Allow Negative Stock':
              _inventoryItemData['allowNegativeStock'].toString(),
        },
      },
    );
  }

  Future<void> _deleteInventory() async {
    try {
      await _inventoryItemProvider.deleteInventory(inventoryId);
      utils.showSuccessSnackbar(
          _screenContext, 'Inventory Deleted Successfully');
      Navigator.of(_screenContext)
          .pushReplacementNamed('/inventory/manage/inventory-item');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(context, ['inv.inv.op'])) {
      _menuList.add('Inventory Opening');
    }
    if (utils.checkMenuWiseAccess(context, ['inv.inv.ar'])) {
      _menuList.add('Assign Racks');
    }
    if (utils.checkMenuWiseAccess(context, ['inv.inv.uc'])) {
      _menuList.add('Unit Conversion');
    }
    if (utils.checkMenuWiseAccess(context, ['inv.inv.pc'])) {
      _menuList.add('Price Configuration');
    }
    if (utils.checkMenuWiseAccess(context, ['inv.inv.pfvend'])) {
      _menuList.add('Dealers');
    }
    if (utils.checkMenuWiseAccess(context, ['inv.inv.dl'])) {
      _menuList.add('Delete Inventory');
    }
  }

  void _menuAction(String menu) {
    if (menu == 'Inventory Opening') {
      Navigator.of(context).pushNamed(
        '/inventory/manage/inventory-item/opening',
        arguments: {
          'id': inventoryId,
          'displayName': inventoryName,
          'isBatchWiseInventory': _inventoryItemData['bwd'],
        },
      );
    } else if (menu == 'Assign Racks') {
      Navigator.of(context).pushNamed(
        '/inventory/manage/inventory-item/assign-racks',
        arguments: {
          'id': inventoryId,
          'displayName': inventoryName,
        },
      );
    } else if (menu == 'Unit Conversion') {
      Navigator.of(context).pushNamed(
        '/inventory/manage/inventory-item/unit-conversion',
        arguments: {
          'id': inventoryId,
          'displayName': inventoryName,
        },
      );
    } else if (menu == 'Price Configuration') {
      Navigator.of(context).pushNamed(
        '/inventory/manage/inventory-item/price-configuration',
        arguments: {
          'id': inventoryId,
          'displayName': inventoryName,
        },
      );
    } else if (menu == 'Dealers') {
      Navigator.of(context).pushNamed(
        '/inventory/manage/inventory-item/dealer',
        arguments: {
          'id': inventoryId,
          'displayName': inventoryName,
        },
      );
    } else if (menu == 'Delete Inventory') {
      utils.showAlertDialog(
        _screenContext,
        _deleteInventory,
        'Delete Inventory?',
        'Are you sure want to delete',
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          inventoryName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/inventory-item/form',
                arguments: {
                  'id': inventoryId,
                  'displayName': inventoryName,
                  'detail': _inventoryItemData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inv.inv.up',
              ],
            ),
          ),
          Visibility(
            child: PopupMenuButton<String>(
              onSelected: (value) => _menuAction(value),
              itemBuilder: (BuildContext context) {
                return _menuList.map(
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
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inv.inv.op',
                'inv.inv.dl',
                'inv.inv.pfvend',
                'inv.inv.pc',
                'inv.inv.uc',
                'inv.inv.ar',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getInventory(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: DetailCard(
                      _buildDetailPage(),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
