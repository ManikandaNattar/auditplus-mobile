import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/menu_item/menu_item_card.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../utils.dart' as utils;

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _getMenuItemList() {
    return utils.checkMenuVisibility(
      context,
      {
        {
          'title': 'Manage',
          'isExpanded': true,
        }: [
          {
            'title': 'Inventory',
            'icon': Icons.inventory,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/inventory-item',
            'privileges': [
              'inventory.inventory.view',
            ],
            'features': '',
          },
          {
            'title': 'Manufacturer',
            'icon': Icons.store_mall_directory,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/manufacturer',
            'privileges': [
              'inventory.manufacturer.view',
            ],
            'features': '',
          },
          {
            'title': 'Rack',
            'icon': Icons.dns,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/rack',
            'privileges': [
              'inventory.rack.view',
            ],
            'features': '',
          },
          {
            'title': 'Section',
            'icon': Icons.pie_chart,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/section',
            'privileges': [
              'inventory.section.view',
            ],
            'features': '',
          },
          {
            'title': 'Unit',
            'icon': Icons.ac_unit,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/unit',
            'privileges': [
              'inventory.unit.view',
            ],
            'features': '',
          },
          {
            'title': 'Salt',
            'icon': Icons.battery_full,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/pharma-salt',
            'privileges': [
              'inventory.pharmaSalt.view',
            ],
            'features': 'pharmacy',
          },
        ],
        {
          'title': 'Sale',
          'isExpanded': false,
        }: [
          {
            'title': 'Sale',
            'icon': Icons.point_of_sale,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale',
            'privileges': [
              'inventory.sale.view',
            ],
            'features': '',
          },
          {
            'title': 'Sale Return',
            'icon': Icons.shop,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale/sale-return',
            'privileges': [
              'inventory.saleReturn.view',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Purchase',
          'isExpanded': false,
        }: [
          {
            'title': 'Purchase',
            'icon': Icons.shopping_cart,
            'checkBranch': true,
            'clickedMenu': '/inventory/purchase',
            'privileges': [
              'inventory.purchase.view',
            ],
            'features': '',
          },
          {
            'title': 'Purchase Return',
            'icon': Icons.shopping_cart_outlined,
            'checkBranch': true,
            'clickedMenu': '/inventory/purchase/purchase-return',
            'privileges': [
              'inventory.purchaseReturn.view',
            ],
            'features': '',
          },
        ],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory',
              ),
              AppBarBranchSelection(
                selectedBranch: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        drawer: MainDrawer(),
        body: MenuItemCard(
          menuItemList: _getMenuItemList(),
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/dashboard');
        return true;
      },
    );
  }
}
