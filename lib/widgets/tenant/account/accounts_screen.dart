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
              'ac.ac.vw',
            ],
            'features': '',
          },
          // {
          //   'title': 'Cost Centre',
          //   'icon': Icons.business_center,
          //   'checkBranch': false,
          //   'clickedMenu': '/accounts/manage/cost-centre/',
          //   'privileges': [
          //     'ac.cc .vw',
          //   ],
          //   'features': '',
          // },
          // {
          //   'title': 'Cost Category',
          //   'icon': Icons.category,
          //   'checkBranch': false,
          //   'clickedMenu': '/accounts/manage/cost-category/',
          //   'privileges': [
          //     'ac.ccat.vw',
          //   ],
          //   'features': '',
          // },
        ],
        {
          'title': 'Vouchers',
          'isExpanded': false,
        }: [
          {
            'title': 'Payment',
            'icon': Icons.payment,
            'checkBranch': true,
            'clickedMenu': '/accounts/vouchers/payment',
            'privileges': [
              'ac.pmt.vw',
            ],
            'features': '',
          },
          {
            'title': 'Receipt',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/accounts/vouchers/receipt',
            'privileges': [
              'ac.rcpt.vw',
            ],
            'features': '',
          },
          {
            'title': 'Contra',
            'icon': Icons.account_balance_wallet,
            'checkBranch': true,
            'clickedMenu': '/accounts/vouchers/contra',
            'privileges': [
              'ac.ctra.vw',
            ],
            'features': '',
          },
          {
            'title': 'Journal',
            'icon': Icons.money,
            'checkBranch': true,
            'clickedMenu': '/accounts/vouchers/journal',
            'privileges': [
              'ac.jo.vw',
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
