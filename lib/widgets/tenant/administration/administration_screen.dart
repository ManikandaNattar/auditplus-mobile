import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/menu_item/menu_item_card.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../utils.dart' as utils;

class AdministrationScreen extends StatefulWidget {
  @override
  _AdministrationScreenState createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _getMenuItemList() {
    return utils.checkMenuVisibility(
      context,
      {
        {
          'title': 'Manage',
          'isExpanded': true,
        }: [
          {
            'title': 'Branch',
            'icon': Icons.storefront_outlined,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/branch',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Desktop Client',
            'icon': Icons.laptop_chromebook,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/desktop-client',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Role',
            'icon': Icons.verified_user,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/role',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'User',
            'icon': Icons.group,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/user',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Cash Register',
            'icon': Icons.book_sharp,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/cash-register',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Warehouse',
            'icon': Icons.store_mall_directory,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/warehouse',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Accountant',
            'icon': Icons.account_circle,
            'checkBranch': false,
            'clickedMenu': '/administration/manage/accountant-/',
            'privileges': [
              '',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Configuration',
          'isExpanded': false,
        }: [
          {
            'title': 'Voucher Number',
            'icon': Icons.format_list_numbered,
            'checkBranch': false,
            'clickedMenu': '/administration/configuration/voucher-number',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Financial Configuration',
            'icon': Icons.monetization_on,
            'checkBranch': false,
            'clickedMenu':
                '/administration/configuration/financial-configuration',
            'privileges': [
              '',
            ],
            'features': '',
          },
          {
            'title': 'Preferences',
            'icon': Icons.settings,
            'checkBranch': false,
            'clickedMenu': '/administration/configuration/preferences',
            'privileges': [
              '',
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
                'Administration',
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
