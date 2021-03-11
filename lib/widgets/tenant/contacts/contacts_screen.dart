import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/menu_item/menu_item_card.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../utils.dart' as utils;

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Map<Map<String, dynamic>, List<Map<String, dynamic>>> _getMenuItemList() {
    return utils.checkMenuVisibility(
      context,
      {
        {
          'title': 'Manage',
          'isExpanded': true,
        }: [
          {
            'title': 'Customer',
            'icon': Icons.group,
            'checkBranch': true,
            'clickedMenu': '/contacts/manage/customer',
            'privileges': [
              'contacts.customer.view',
            ],
            'features': '',
          },
          {
            'title': 'Vendor',
            'icon': Icons.person,
            'checkBranch': true,
            'clickedMenu': '/contacts/manage/vendor',
            'privileges': [
              'contacts.vendor.view',
            ],
            'features': '',
          },
          {
            'title': 'Doctor',
            'icon': Icons.local_hospital,
            'checkBranch': true,
            'clickedMenu': '/contacts/manage/doctor',
            'privileges': [
              'contacts.doctor.view',
            ],
            'features': 'pharmacy',
          },
          {
            'title': 'Patient',
            'icon': Icons.local_pharmacy,
            'checkBranch': true,
            'clickedMenu': '/contacts/manage/patient',
            'privileges': [
              'contacts.patient.view',
            ],
            'features': 'pharmacy',
          },
        ],
        {
          'title': 'Customer',
          'isExpanded': false,
        }: [
          {
            'title': 'Payment',
            'icon': Icons.payment,
            'checkBranch': true,
            'clickedMenu': '/contacts/customer/payment',
            'privileges': [
              'contacts.customerPayment.view',
            ],
            'features': '',
          },
          {
            'title': 'Receipt',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/contacts/customer/receipt',
            'privileges': [
              'contacts.customerReceipt.view',
            ],
            'features': '',
          },
        ],
        {
          'title': 'Vendor',
          'isExpanded': false,
        }: [
          {
            'title': 'Payment',
            'icon': Icons.payment,
            'checkBranch': true,
            'clickedMenu': '/contacts/vendor/payment',
            'privileges': [
              'contacts.vendorPayment.view',
            ],
            'features': '',
          },
          {
            'title': 'Receipt',
            'icon': Icons.receipt,
            'checkBranch': true,
            'clickedMenu': '/contacts/vendor/receipt',
            'privileges': [
              'contacts.vendorReceipt.view',
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
                'Contacts',
              ),
              AppBarBranchSelection(
                selectedBranch: (value) {
                  if (value != null) {
                    setState(() {});
                  }
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
