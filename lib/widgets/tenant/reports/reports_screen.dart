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
              'report.account.accountBook',
            ],
            'features': '',
          },
          {
            'title': 'General Book',
            'icon': Icons.chrome_reader_mode,
            'checkBranch': true,
            'clickedMenu': '/reports/account/general-account-book',
            'privileges': [
              'report.account.accountBook',
            ],
            'features': '',
          },
          {
            'title': 'EFT Account Book',
            'icon': Icons.dvr,
            'checkBranch': true,
            'clickedMenu': '/reports/account/eft-account-book',
            'privileges': [
              'report.account.accountBook',
            ],
            'features': '',
          },
          {
            'title': 'Balance Sheet',
            'icon': Icons.exposure,
            'checkBranch': true,
            'clickedMenu': '/reports/account/balance-sheet',
            'privileges': [
              'report.account.balanceSheet',
            ],
            'features': '',
          },
          {
            'title': 'Profit & Loss',
            'icon': Icons.show_chart,
            'checkBranch': true,
            'clickedMenu': '/reports/account/profit-loss',
            'privileges': [
              'report.account.profitLoss',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Customer',
          'isExpanded': false,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/customer/customer-book',
            'privileges': [
              'report.customer.customerBook',
            ],
            'features': '',
          },
          {
            'title': 'Outstanding',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/reports/customer/customer-outstanding',
            'privileges': [
              'report.customer.customerOutstanding',
            ],
            'features': '',
          },
          {
            'title': 'Invoice Aging Summary',
            'icon': Icons.insert_chart,
            'checkBranch': true,
            'clickedMenu': '/reports/customer/invoice-aging-summary',
            'privileges': [
              'report.customer.invoiceAgingSummary',
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
              'report.inventory.inventoryBook',
            ],
            'features': '',
          },
          {
            'title': 'Stock Analysis',
            'icon': Icons.chrome_reader_mode,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/stock-analysis',
            'privileges': [
              'report.inventory.stockAnalysis',
            ],
            'features': '',
          },
          {
            'title': 'Product wise Profit',
            'icon': Icons.local_atm,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/product-wise-profit',
            'privileges': [
              'report.inventory.productwiseProfit',
            ],
            'features': '',
          },
          {
            'title': 'Stock Valuation Summary',
            'icon': Icons.bar_chart,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/stock-valuation-summary',
            'privileges': [
              'report.inventory.stockValuationSummary',
            ],
            'features': '',
          },
          {
            'title': 'Reorder Level Analysis',
            'icon': Icons.list_alt,
            'checkBranch': true,
            'clickedMenu': '/reports/inventory/reorder-level-analysis',
            'privileges': [
              'report.inventory.reorderAnalysis',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Vendor',
          'isExpanded': false,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/vendor/vendor-book',
            'privileges': [
              'report.vendor.vendorBook',
            ],
            'features': '',
          },
          {
            'title': 'Outstanding',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/reports/vendor/vendor-outstanding',
            'privileges': [
              'report.vendor.vendorOutstanding',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Cash Register',
          'isExpanded': false,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/cash-register/cash-register-book',
            'privileges': [
              'report.cashRegister.cashRegisterBook',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Branch',
          'isExpanded': false,
        }: [
          {
            'title': 'Book',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/branch/branch-book',
            'privileges': [
              'report.branch.branchBook',
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
          'title': 'GST Returns',
          'isExpanded': false,
        }: [
          {
            'title': 'Summary of Outward Supplies (GSTR-1)',
            'icon': Icons.attach_money,
            'checkBranch': true,
            'clickedMenu': '/reports/gst-returns/gstr1-summary',
            'privileges': [
              'report.gstReturns.GSTR1Summary',
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
              'report.sales.productwiseSales',
            ],
            'features': '',
          },
          {
            'title': 'Sales by Incharge',
            'icon': Icons.person_pin_circle,
            'checkBranch': true,
            'clickedMenu': '/reports/sales/sales-by-incharge',
            'privileges': [
              'report.sales.salesByIncharge',
            ],
            'features': '',
          },
          {
            'title': 'Sales Register',
            'icon': Icons.book,
            'checkBranch': true,
            'clickedMenu': '/reports/sales/sale-register',
            'privileges': [
              'report.sales.saleRegister',
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
              'report.purchases.purchaseRegister',
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
