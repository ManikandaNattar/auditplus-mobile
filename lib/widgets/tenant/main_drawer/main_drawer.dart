import 'package:auditplusmobile/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth/tenant_auth_provider.dart';
import './../../../models/organization.dart';
import './../../../utils.dart' as utils;
import './drawer_item.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  TenantAuth _tenantAuth;
  BuildContext _screenContext;
  String organizationName = '';
  String avatar = '';
  bool _isMenuLoading = false;
  @override
  void didChangeDependencies() {
    _tenantAuth = Provider.of<TenantAuth>(context);
    organizationName = _tenantAuth.organizationName;
    avatar = Organization(organizationName).avatar;
    super.didChangeDependencies();
  }

  Future<void> _getTenantAuth() async {
    try {
      await getTenantAuth(_tenantAuth).then((value) {
        setState(() {
          _isMenuLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        _isMenuLoading = false;
      });
      Navigator.of(context).pop();
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Future<void> _routeToOrganization() async {
    await _tenantAuth.logout();
    Navigator.of(_screenContext).pushReplacementNamed('/organization');
  }

  Future<void> _logout() async {
    await _tenantAuth.logout();
    Navigator.of(_screenContext).pushReplacementNamed('/login',
        arguments: {'organization': organizationName});
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        _screenContext = context;
        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      organizationName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMenuLoading = true;
                        });
                        _getTenantAuth();
                      },
                    )
                  ],
                ),
                accountEmail: null,
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    avatar,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _isMenuLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerItem(
                            title: 'Dashboard',
                            icon: Icons.dashboard,
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed('/dashboard'),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Administration',
                              icon: Icons.admin_panel_settings,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/administration'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              [],
                            ),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Accounts',
                              icon: Icons.account_balance_wallet,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/accounts'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              [
                                'accounting.account.view',
                                'accounting.costCentre.view',
                                'accounting.costCategory.view',
                                'accounting.accountPayment.view',
                                'accounting.expensePayment.view',
                                'accounting.journal.view',
                                'accounting.accountReceipt.view',
                                'accounting.incomeReceipt.view',
                                'accounting.cashDeposit.view',
                                'accounting.cashWithdrawal.view'
                              ],
                            ),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Contacts',
                              icon: Icons.contacts,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/contacts'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              [
                                'contacts.customer.view',
                                'contacts.vendor.view',
                                'contacts.doctor.view',
                                'contacts.patient.view',
                                'contacts.customerPayment.view',
                                'contacts.customerReceipt.view',
                                'contacts.vendorReceipt.view',
                                'contacts.vendorPayment.view',
                              ],
                            ),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Inventory',
                              icon: Icons.inventory,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/inventory'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              [
                                'inventory.inventory.view',
                                'inventory.section.view',
                                'inventory.manufacturer.view',
                                'inventory.rack.view',
                                'inventory.unit.view',
                                'inventory.pharmaSalt.view',
                                'inventory.cashSale.view',
                                'inventory.creditSale.view',
                                'inventory.cashSaleReturn.view',
                                'inventory.creditSaleReturn.view',
                                'inventory.cashPurchase.view',
                                'inventory.creditPurchase.view',
                                'inventory.cashPurchaseReturn.view',
                                'inventory.creditPurchaseReturn.view',
                              ],
                            ),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Taxes',
                              icon: Icons.remove_red_eye,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/tax'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              ['tax.tax.view'],
                            ),
                          ),
                          Visibility(
                            child: DrawerItem(
                              title: 'Reports',
                              icon: Icons.pie_chart,
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/reports'),
                            ),
                            visible: utils.checkMenuWiseAccess(
                              context,
                              [
                                'report.account.accountBook',
                                'report.account.expenseAnalysis',
                                'report.account.balanceSheet',
                                'report.customer.customerBook',
                                'report.customer.customerOutstanding',
                                'report.customer.invoiceAgingSummary',
                                'report.vendor.vendorBook',
                                'report.vendor.vendorOutstanding',
                                'report.inventory.inventoryBook',
                                'report.inventory.stockAnalysis',
                                'report.inventory.stockValuationSummary',
                                'report.inventory.productwiseSales',
                                'report.inventory.productwiseProfit',
                                'report.inventory.reorderAnalysis',
                                'report.cashRegister.cashRegisterBook',
                                'report.branch.branchBook',
                                'report.gstReturns.GSTR1Summary',
                              ],
                            ),
                          ),
                          DrawerItem(
                            title: 'Settings',
                            icon: Icons.settings,
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed('/settings'),
                          ),
                          DrawerItem(
                            title: 'Feedback',
                            icon: Icons.feedback,
                            onTap: null,
                          ),
                          DrawerItem(
                            title: 'Switch Organization',
                            icon: Icons.domain,
                            onTap: () => utils.showAlertDialog(
                              context,
                              _routeToOrganization,
                              'Switch Organization?',
                              'Do you want to continue',
                            ),
                          ),
                          DrawerItem(
                            title: 'Logout',
                            icon: Icons.logout,
                            onTap: () => utils.showAlertDialog(
                              context,
                              _logout,
                              'Logout?',
                              'Do you want to continue',
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
