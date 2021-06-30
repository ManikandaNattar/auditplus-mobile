import 'dart:convert';

import 'package:auditplusmobile/providers/accounting/cost_category_provider.dart';
import 'package:auditplusmobile/providers/accounting/cost_centre_provider.dart';
import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:auditplusmobile/providers/administration/preference_provider.dart';
import 'package:auditplusmobile/providers/administration/role_provider.dart';
import 'package:auditplusmobile/providers/inventory/sale_incharge_provider.dart';
import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/providers/administration/warehouse_provider.dart';
import 'package:auditplusmobile/providers/common_provider.dart';
import 'package:auditplusmobile/providers/inventory/customer_provider.dart';
import 'package:auditplusmobile/providers/inventory/doctor_provider.dart';
import 'package:auditplusmobile/providers/inventory/patient_provider.dart';
import 'package:auditplusmobile/providers/inventory/sale_provider.dart';
import 'package:auditplusmobile/providers/inventory/vendor_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:auditplusmobile/providers/inventory/pharma_salt_provider.dart';
import 'package:auditplusmobile/providers/inventory/rack_provider.dart';
import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/providers/qsearch_provider.dart';
import 'package:auditplusmobile/providers/reports/account_reports_provider.dart';
import 'package:auditplusmobile/providers/reports/inventory_reports_provider.dart';
import 'package:auditplusmobile/providers/reports/purchase_reports_provider.dart';
import 'package:auditplusmobile/providers/reports/sale_reports_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/auth/cloud_auth_provider.dart';
import './providers/organization_provider.dart';
import './providers/auth/tenant_auth_provider.dart';
import './home_screen.dart';
import './providers/accounting/account_provider.dart';
import './providers/reports/dashboard_provider.dart';

void main() {
  runApp(MyApp());
}

Future<void> getCloudAuth(CloudAuth auth) async {
  final prefs = await SharedPreferences.getInstance();
  final authInfoData = prefs.getString('cloud_auth_info');
  if (authInfoData != null) {
    final authInfo = json.decode(authInfoData);
    auth.setAuth(
      authInfo['token'],
      authInfo['email'],
    );
  }
}

Future<void> getTenantAuth(TenantAuth auth) async {
  final prefs = await SharedPreferences.getInstance();
  final authInfoData = prefs.getString('auth_info');
  if (authInfoData != null) {
    final authInfo = json.decode(authInfoData);
    auth.setAuth(
      authInfo['token'],
      authInfo['userId'],
      authInfo['organization'],
    );
    await auth.getProfile();
    await auth.getselectedBranch();
  }
}

Future<bool> getAuthInfo() async {
  bool isCloudLogin;
  final prefs = await SharedPreferences.getInstance();
  final cloudAuthInfoData = prefs.getString('cloud_auth_info');
  if (cloudAuthInfoData == null) {
    isCloudLogin = false;
  } else {
    isCloudLogin = true;
  }
  return isCloudLogin;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CloudAuth(),
        ),
        ChangeNotifierProvider.value(
          value: OrganizationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TenantAuth(),
        ),
        ChangeNotifierProxyProvider<TenantAuth, DashboardProvider>(
          create: null,
          update: (ctx, auth, _) => DashboardProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, AccountProvider>(
          create: null,
          update: (ctx, auth, _) => AccountProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, CustomerProvider>(
          create: null,
          update: (ctx, auth, _) => CustomerProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, TaxProvider>(
          create: null,
          update: (ctx, auth, _) => TaxProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, CommonProvider>(
          create: null,
          update: (ctx, auth, _) => CommonProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, VendorProvider>(
          create: null,
          update: (ctx, auth, _) => VendorProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, DoctorProvider>(
          create: null,
          update: (ctx, auth, _) => DoctorProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, PatientProvider>(
          create: null,
          update: (ctx, auth, _) => PatientProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, InventoryItemProvider>(
          create: null,
          update: (ctx, auth, _) => InventoryItemProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, ManufacturerProvider>(
          create: null,
          update: (ctx, auth, _) => ManufacturerProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, SectionProvider>(
          create: null,
          update: (ctx, auth, _) => SectionProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, RackProvider>(
          create: null,
          update: (ctx, auth, _) => RackProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, UnitProvider>(
          create: null,
          update: (ctx, auth, _) => UnitProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, PharmaSaltProvider>(
          create: null,
          update: (ctx, auth, _) => PharmaSaltProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, PreferenceProvider>(
          create: null,
          update: (ctx, auth, _) => PreferenceProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, CostCentreProvider>(
          create: null,
          update: (ctx, auth, _) => CostCentreProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, CostCategoryProvider>(
          create: null,
          update: (ctx, auth, _) => CostCategoryProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, BranchProvider>(
          create: null,
          update: (ctx, auth, _) => BranchProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, DesktopClientProvider>(
          create: null,
          update: (ctx, auth, _) => DesktopClientProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, RoleProvider>(
          create: null,
          update: (ctx, auth, _) => RoleProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, UserProvider>(
          create: null,
          update: (ctx, auth, _) => UserProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, CashRegisterProvider>(
          create: null,
          update: (ctx, auth, _) => CashRegisterProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, WarehouseProvider>(
          create: null,
          update: (ctx, auth, _) => WarehouseProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, SaleInchargeProvider>(
          create: null,
          update: (ctx, auth, _) => SaleInchargeProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, AccountReportsProvider>(
          create: null,
          update: (ctx, auth, _) => AccountReportsProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, QSearchProvider>(
          create: null,
          update: (ctx, auth, _) => QSearchProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, InventoryReportsProvider>(
          create: null,
          update: (ctx, auth, _) => InventoryReportsProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, VoucherProvider>(
          create: null,
          update: (ctx, auth, _) => VoucherProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, SaleReportsProvider>(
          create: null,
          update: (ctx, auth, _) => SaleReportsProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, PurchaseReportsProvider>(
          create: null,
          update: (ctx, auth, _) => PurchaseReportsProvider(auth),
        ),
        ChangeNotifierProxyProvider<TenantAuth, SaleProvider>(
          create: null,
          update: (ctx, auth, _) => SaleProvider(auth),
        ),
      ],
      child: FutureBuilder<bool>(
        future: getAuthInfo(),
        builder: (_, AsyncSnapshot<bool> snapShot) {
          return snapShot.data == true
              ? Consumer<CloudAuth>(
                  builder: (ctx, auth, _) => FutureBuilder(
                    future: getCloudAuth(auth),
                    builder: (_, snapShot) => HomeScreen(auth, 'cloud'),
                  ),
                )
              : Consumer<TenantAuth>(
                  builder: (ctx, auth, _) => FutureBuilder(
                    future: getTenantAuth(auth),
                    builder: (_, snapShot) => HomeScreen(auth, 'tenant'),
                  ),
                );
        },
      ),
    );
  }
}
