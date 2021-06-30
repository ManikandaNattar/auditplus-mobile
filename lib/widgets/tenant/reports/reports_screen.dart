import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/menu_item/menu_item_card.dart';
import 'package:flutter/material.dart';

import './../main_drawer/main_drawer.dart';
import './../../../utils.dart' as utils;

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _getMenuItemList() {
    return utils.checkMenuVisibility(
      context,
      {
        {
          'title': 'Account',
          'isExpanded': true,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/account/account-book',
            'privileges': [
              'rpt.ac.acbk',
              'rpt.ac.eftacbk',
              'rpt.cus.cusbk',
              'rpt.vend.vendbk',
            ],
            'features': '',
          },
          {
            'title': 'Outstanding',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/reports/account/account-outstanding',
            'privileges': [
              'rpt.ac.acout',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Inventory',
          'isExpanded': false,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/inventory-book',
            'privileges': [
              'rpt.inv.invbk',
            ],
            'features': '',
          },
          {
            'title': 'Stock Analysis',
            'icon': Icons.chrome_reader_mode,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/stock-analysis',
            'privileges': [
              'rpt.inv.stkanlys',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Activities',
          'isExpanded': false,
        }: [
          {
            'title': 'Activity Log',
            'icon': Icons.book,
            'checkBranch': false,
            'clickedMenu': '/reports/activities/activity-log',
            'privileges': [
              '',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Sales',
          'isExpanded': false,
        }: [
          {
            'title': 'Product wise Sales',
            'icon': Icons.point_of_sale,
            'checkBranch': true,
            'clickedMenu': '/reports/sales/product-wise-sales',
            'privileges': [
              'rpt.sls.pdtwssls',
            ],
            'features': '',
          },
          {
            'title': 'Sales by Incharge',
            'icon': Icons.person_pin_circle,
            'checkBranch': true,
            'clickedMenu': '/reports/sales/sales-by-incharge',
            'privileges': [
              'rpt.sls.slsbyinc',
            ],
            'features': '',
          },
          {
            'title': 'Sales Register',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/sales/sale-register',
            'privileges': [
              'rpt.sls.slreg',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Purchases',
          'isExpanded': false,
        }: [
          {
            'title': 'Purchase Register',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/purchases/purchase-register',
            'privileges': [
              'rpt.pur.pureg',
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
                'Reports',
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
        body: SingleChildScrollView(
          child: Container(
            child: MenuItemCard(
              menuItemList: _getMenuItemList(),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/dashboard');
        return true;
      },
    );
  }
}
