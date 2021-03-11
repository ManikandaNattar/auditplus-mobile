import 'package:auditplusmobile/widgets/shared/menu_item/menu_item_card.dart';
import 'package:flutter/material.dart';
import './../../shared/app_bar_branch_selection.dart';
import './../../tenant/main_drawer/main_drawer.dart';
import './../../../utils.dart' as utils;

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _getMenuItemList() {
    return utils.checkMenuVisibility(
      context,
      {
        {
          'title': 'Manage',
          'isExpanded': true,
        }: [
          {
            'title': 'Account',
            'icon': Icons.account_balance,
            'checkBranch': false,
            'clickedMenu': '/accounts/manage/account',
            'privileges': [
              'accounting.account.view',
            ],
            'features': '',
          },
          {
            'title': 'Cost Centre',
            'icon': Icons.business_center,
            'checkBranch': false,
            'clickedMenu': '/accounts/manage/cost-centre',
            'privileges': [
              'accounting.costCentre.view',
            ],
            'features': '',
          },
          {
            'title': 'Cost Category',
            'icon': Icons.category,
            'checkBranch': false,
            'clickedMenu': '/accounts/manage/cost-category',
            'privileges': [
              'accounting.costCategory.view',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Vouchers',
          'isExpanded': false,
        }: [
          {
            'title': 'Income',
            'icon': Icons.euro_symbol,
            'checkBranch': false,
            'clickedMenu': '/accounts/vouchers/income',
            'privileges': [
              'accounting.incomeReceipt.view',
            ],
            'features': '',
          },
          {
            'title': 'Receipt',
            'icon': Icons.receipt,
            'checkBranch': false,
            'clickedMenu': '/accounts/vouchers/receipt',
            'privileges': [
              'accounting.incomeReceipt.view',
            ],
            'features': '',
          },
          {
            'title': 'Expense',
            'icon': Icons.money,
            'checkBranch': false,
            'clickedMenu': '/accounts/vouchers/expense',
            'privileges': [
              'accounting.expensePayment.view',
            ],
            'features': '',
          },
          {
            'title': 'Payment',
            'icon': Icons.payment,
            'checkBranch': false,
            'clickedMenu': '/accounts/vouchers/payment',
            'privileges': [
              'accounting.expensePayment.view',
            ],
            'features': '',
          },
          {
            'title': 'Journal',
            'icon': Icons.sticky_note_2,
            'checkBranch': false,
            'clickedMenu': '/accounts/vouchers/journal',
            'privileges': [
              'accounting.journal.view',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Banking',
          'isExpanded': false,
        }: [
          {
            'title': 'Cash Deposit',
            'icon': Icons.account_balance_wallet,
            'checkBranch': false,
            'clickedMenu': '/accounts/banking/cash-deposit',
            'privileges': [
              'accounting.cashDeposit.view',
            ],
            'features': '',
          },
          {
            'title': 'Cash Withdrawal',
            'icon': Icons.atm,
            'checkBranch': false,
            'clickedMenu': '/accounts/banking/cash-withdrawal',
            'privileges': [
              'accounting.cashWithdrawal.view',
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
                'Accounts',
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
