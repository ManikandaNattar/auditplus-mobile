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
              'inv.inv.vw',
            ],
            'features': '',
          },
          {
            'title': 'Manufacturer',
            'icon': Icons.store_mall_directory,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/manufacturer',
            'privileges': [
              'inv.man.vw',
            ],
            'features': '',
          },
          {
            'title': 'Rack',
            'icon': Icons.dns,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/rack',
            'privileges': [
              'inv.rck.vw',
            ],
            'features': '',
          },
          {
            'title': 'Section',
            'icon': Icons.pie_chart,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/section',
            'privileges': [
              'inv.sec.vw',
            ],
            'features': '',
          },
          {
            'title': 'Unit',
            'icon': Icons.ac_unit,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/unit',
            'privileges': [
              'inv.unt.vw',
            ],
            'features': '',
          },
          {
            'title': 'Salt',
            'icon': Icons.battery_full,
            'checkBranch': true,
            'clickedMenu': '/inventory/manage/pharma-salt',
            'privileges': [
              'inv.pslt.vw',
            ],
            'features': 'pharmacy',
          },
        ],
        {
          'title': 'Sale',
          'isExpanded': false,
        }: [
          {
            'title': 'Customer',
            'icon': Icons.group,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale/customer',
            'privileges': [
              'inv.cus.vw',
            ],
            'features': '',
          },
          {
            'title': 'Doctor',
            'icon': Icons.local_hospital,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale/doctor',
            'privileges': [
              'inv.doc.vw',
            ],
            'features': 'pharmacy',
          },
          {
            'title': 'Patient',
            'icon': Icons.local_pharmacy,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale/patient',
            'privileges': [
              'inv.pat.vw',
            ],
            'features': 'pharmacy',
          },
          {
            'title': 'Sale',
            'icon': Icons.point_of_sale,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale',
            'privileges': [
              'inv.sal.vw',
            ],
            'features': '',
          },
          {
            'title': 'Sale Return',
            'icon': Icons.shop,
            'checkBranch': true,
            'clickedMenu': '/inventory/sale/sale-return',
            'privileges': [
              'inv.salret.vw',
            ],
            'features': '',
          },
          {
            'title': 'Sale Incharge',
            'icon': Icons.point_of_sale,
            'checkBranch': false,
            'clickedMenu': '/inventory/sale/sale-incharge',
            'privileges': [
              'inv.sinc.vw',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Purchase',
          'isExpanded': false,
        }: [
          {
            'title': 'Vendor',
            'icon': Icons.person,
            'checkBranch': true,
            'clickedMenu': '/inventory/purchase/vendor',
            'privileges': [
              'inv.vend.vw',
            ],
            'features': '',
          },
          {
            'title': 'Purchase',
            'icon': Icons.shopping_cart,
            'checkBranch': true,
            'clickedMenu': '/inventory/purchase',
            'privileges': [
              'inv.pur.vw',
            ],
            'features': '',
          },
          {
            'title': 'Purchase Return',
            'icon': Icons.shopping_cart_outlined,
            'checkBranch': true,
            'clickedMenu': '/inventory/purchase/purchase-return',
            'privileges': [
              'inv.purret.vw',
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
