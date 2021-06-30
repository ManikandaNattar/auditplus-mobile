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
                                'ac.ac.vw',
                                'ac.cc.vw',
                                'ac.ccat.vw',
                                'ac.pmt.vw',
                                'ac.jo.vw',
                                'ac.rcpt.vw',
                                'ac.ctra.vw',
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
                                'inv.inv.vw',
                                'inv.sec.vw',
                                'inv.man.vw',
                                'inv.rck.vw',
                                'inv.unt.vw',
                                'inv.pslt.vw',
                                'inv.sal.vw',
                                'inv.salret.vw',
                                'inv.pur.vw',
                                'inv.purret.vw',
                                'inv.sinc.vw',
                                'inv.cus.vw',
                                'inv.vend.vw',
                                'inv.doc.vw',
                                'inv.pat.vw',
                              ],
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
                                'rpt.ac.acbk',
                                'rpt.ac.expanlys',
                                'rpt.ac.blsht',
                                'rpt.ac.pfls',
                                'rpt.ac.eftacbk',
                                'rpt.cus.cusbk',
                                'rpt.cus.cusout',
                                'rpt.cus.invagesum',
                                'rpt.vend.vendbk',
                                'rpt.vend.vendout',
                                'rpt.inv.invbk',
                                'rpt.inv.stkanlys',
                                'rpt.inv.stkvalsum',
                                'rpt.inv.pdtwspft',
                                'rpt.inv.reodranlys',
                                'rpt.sls.pdtwssls',
                                'rpt.sls.slsbyinc',
                                'rpt.sls.slreg',
                                'rpt.csreg.csregbk',
                                'rpt.bch.bchbk',
                                'rpt.pur.pureg',
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
                            onTap: () => utils.launchUrl(
                              'mailto:support@auditplus.io?subject=Reg:Feedback',
                              context,
                            ),
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
