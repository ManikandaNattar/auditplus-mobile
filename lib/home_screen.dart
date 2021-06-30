import 'package:auditplusmobile/widgets/shared/settings_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/accounts_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/account/accounts_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_type_opening_form.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_type_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/accounts_vouchers_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/contra/contra_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/contra/contra_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/contra/contra_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/journal/journal_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/journal/journal_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/journal/journal_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/payment/payment_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/payment/payment_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/payment/payment_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/receipt/receipt_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/receipt/receipt_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/receipt/receipt_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/voucher_pending_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/administration_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/administration/administration_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/accountant/accountant_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/accountant/accountant_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/branch_assign_desktop_clients_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/branch_assign_users_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/branch_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/branch_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/branch_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/cash_register/cash_register_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/cash_register/cash_register_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/cash_register/cash_register_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/desktop_client/desktop_client_assign_branches_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/desktop_client/desktop_client_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/desktop_client/desktop_client_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/desktop_client/desktop_client_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_assign_branches_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/customer/customer_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/customer/customer_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/doctor/doctor_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/doctor/doctor_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/doctor/doctor_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/patient/patient_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/patient/patient_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/patient/patient_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/purchase/vendor/vendor_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/purchase/vendor/vendor_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/purchase/vendor/vendor_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/inventory_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/inventory_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_assign_racks_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_dealers_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_opening_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_price_configuration_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_unit_conversion_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/inventoryItem/inventory_item_unit_conversion_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/manufacturer/manufacturer_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/manufacturer/manufacturer_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/manufacturer/manufacturer_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/pharmaSalt/pharma_salt_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/pharmaSalt/pharma_salt_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/pharmaSalt/pharma_salt_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/rack/rack_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/rack/rack_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/rack/rack_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/unit/unit_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/unit/unit_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/manage/unit/unit_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale/sale_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale/sale_form/sale_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale/sale_form/sale_item_batch_detail.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale/sale_form/sale_item_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale/sale_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale_incharge/sale_incharge_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale/sale_incharge/sale_incharge_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/inventory/sale_purchase_vouchers_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/account/account_outstanding/account_outstanding_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/account/account_outstanding/account_outstanding_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/stock_analysis/stock_analysis_summary_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/purchase/purchase_register/purchase_register_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/purchase/purchase_register/purchase_register_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/product_wise_sales/product_wise_sales_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/product_wise_sales/product_wise_sales_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sale_register/sale_register_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sale_register/sale_register_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sales_by_incharge/sales_by_incharge_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sales_by_incharge/sales_by_incharge_screen.dart';
import 'package:auditplusmobile/widgets/tenant/settings/help_screen.dart';
import 'package:auditplusmobile/widgets/tenant/settings/tenant_change_password.dart';
import 'package:auditplusmobile/widgets/tenant/settings/tenant_profile_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/tenant/dashboard/dashboard_screen.dart';
import 'widgets/tenant/inventory/manage/section/section_detail_screen.dart';
import 'widgets/tenant/inventory/manage/section/section_form_screen.dart';
import 'widgets/tenant/inventory/manage/section/section_list_screen.dart';
import 'widgets/tenant/login/login_screen.dart';
import 'widgets/tenant/reports/account/account_book/account_book_form_screen.dart';
import 'widgets/tenant/reports/account/account_book/account_book_screen.dart';
import 'widgets/tenant/reports/reports_screen.dart';
import 'widgets/cloud/dashboard/dashboard_screen.dart';
import 'widgets/cloud/login/login_screen.dart';
import 'widgets/cloud/register/register_screen.dart';
import 'widgets/tenant/organization/organization_screen.dart';
import 'widgets/tenant/inventory/sale/customer/customer_list_screen.dart';
import 'widgets/tenant/inventory/sale_purchase_filter_form.dart';

class HomeScreen extends StatelessWidget {
  final auth;
  final _appLoginMode;
  HomeScreen(this.auth, this._appLoginMode);

  Widget _homeScreen() {
    if (_appLoginMode == 'cloud') {
      return auth.isAuthenticated
          ? CloudDashboardScreen()
          : OrganizationScreen();
    } else {
      return auth.isAuthenticated ? DashboardScreen() : OrganizationScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auditplus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline3: TextStyle(
            color: Colors.black54,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
          headline5: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
          subtitle1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          subtitle2: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: _homeScreen(),
      routes: {
        '/organization': (ctx) => OrganizationScreen(),
        '/login': (ctx) => LoginScreen(),
        '/dashboard': (ctx) => DashboardScreen(),
        '/cloud/login': (ctx) => CloudLoginScreen(),
        '/cloud/dashboard': (ctx) => CloudDashboardScreen(),
        '/cloud/register': (ctx) => CloudRegisterScreen(),
        '/inventory': (ctx) => InventoryScreen(),
        '/inventory/manage/inventory-filter-form': (ctx) =>
            InventoryFilterForm(),
        '/inventory/manage/pharma-salt': (ctx) => PharmaSaltListScreen(),
        '/inventory/manage/pharma-salt/detail': (ctx) =>
            PharmaSaltDetailScreen(),
        '/inventory/manage/pharma-salt/form': (ctx) => PharmaSaltFormScreen(),
        '/inventory/manage/unit': (ctx) => UnitListScreen(),
        '/inventory/manage/unit/detail': (ctx) => UnitDetailScreen(),
        '/inventory/manage/unit/form': (ctx) => UnitFormScreen(),
        '/inventory/manage/section': (ctx) => SectionListScreen(),
        '/inventory/manage/section/detail': (ctx) => SectionDetailScreen(),
        '/inventory/manage/section/form': (ctx) => SectionFormScreen(),
        '/inventory/manage/rack': (ctx) => RackListScreen(),
        '/inventory/manage/rack/detail': (ctx) => RackDetailScreen(),
        '/inventory/manage/rack/form': (ctx) => RackFormScreen(),
        '/inventory/manage/manufacturer': (ctx) => ManufacturerListScreen(),
        '/inventory/manage/manufacturer/detail': (ctx) =>
            ManufacturerDetailScreen(),
        '/inventory/manage/manufacturer/form': (ctx) =>
            ManufacturerFormScreen(),
        '/inventory/manage/inventory-item': (ctx) => InventoryItemListScreen(),
        '/inventory/manage/inventory-item/detail': (ctx) =>
            InventoryItemDetailScreen(),
        '/inventory/manage/inventory-item/form': (ctx) =>
            InventoryItemFormScreen(),
        '/inventory/manage/inventory-item/price-configuration': (ctx) =>
            InventoryItemPriceConfigurationScreen(),
        '/inventory/manage/inventory-item/dealer': (ctx) =>
            InventoryItemDealersScreen(),
        '/inventory/manage/inventory-item/unit-conversion': (ctx) =>
            InventoryItemUnitConversionScreen(),
        '/inventory/manage/inventory-item/unit-conversion/form': (ctx) =>
            InventoryItemUnitConversionFormScreen(),
        '/inventory/manage/inventory-item/assign-racks': (ctx) =>
            InventoryItemAssignRacksScreen(),
        '/inventory/manage/inventory-item/opening': (ctx) =>
            InventoryItemOpeningScreen(),
        '/inventory/manage/inventory-item/opening/form': (ctx) =>
            InventoryItemOpeningFormScreen(),
        '/inventory/sale-purchase-filter-form': (ctx) =>
            SalePurchaseFilterForm(),
        '/inventory/sale/customer': (ctx) => CustomerListScreen(),
        '/inventory/sale/customer/detail': (ctx) => CustomerDetailScreen(),
        '/inventory/sale/customer/form': (ctx) => CustomerFormScreen(),
        '/inventory/sale/doctor': (ctx) => DoctorListScreen(),
        '/inventory/sale/doctor/detail': (ctx) => DoctorDetailScreen(),
        '/inventory/sale/doctor/form': (ctx) => DoctorFormScreen(),
        '/inventory/sale/patient': (ctx) => PatientListScreen(),
        '/inventory/sale/patient/detail': (ctx) => PatientDetailScreen(),
        '/inventory/sale/patient/form': (ctx) => PatientFormScreen(),
        '/inventory/sale/sale-incharge': (ctx) => SaleInchargeListScreen(),
        '/inventory/sale/sale-incharge/form': (ctx) => SaleInchargeFormScreen(),
        '/inventory/purchase/vendor': (ctx) => VendorListScreen(),
        '/inventory/purchase/vendor/detail': (ctx) => VendorDetailScreen(),
        '/inventory/purchase/vendor/form': (ctx) => VendorFormScreen(),
        '/accounts': (ctx) => AccountsScreen(),
        '/accounts/manage/accounts-filter-form': (ctx) => AccountsFilterForm(),
        '/accounts/manage/account': (ctx) => AccountListScreen(),
        '/accounts/manage/account/detail': (ctx) => AccountDetailScreen(),
        '/accounts/manage/account/form': (ctx) => AccountFormScreen(),
        '/accounts/manage/account/opening': (ctx) => AccountOpeningScreen(),
        '/accounts/manage/account-type/opening': (ctx) =>
            AccountTypeOpeningScreen(),
        '/accounts/manage/account-type/opening/form': (ctx) =>
            AccountTypeOpeningForm(),
        '/accounts/manage/cost-centre': (ctx) => CostCentreListScreen(),
        '/accounts/manage/cost-centre/detail': (ctx) =>
            CostCentreDetailScreen(),
        '/accounts/manage/cost-centre/form': (ctx) => CostCentreFormScreen(),
        '/accounts/manage/cost-category': (ctx) => CostCategoryListScreen(),
        '/accounts/manage/cost-category/detail': (ctx) =>
            CostCategoryDetailScreen(),
        '/accounts/manage/cost-category/form': (ctx) =>
            CostCategoryFormScreen(),
        '/administration': (ctx) => AdministrationScreen(),
        '/administration/manage/administration-filter-form': (ctx) =>
            AdministrationFilterFormScreen(),
        '/administration/manage/branch': (ctx) => BranchListScreen(),
        '/administration/manage/branch/detail': (ctx) => BranchDetailScreen(),
        '/administration/manage/branch/form': (ctx) => BranchFormScreen(),
        '/administration/manage/branch/assign-users': (ctx) =>
            BranchAssignUsersScreen(),
        '/administration/manage/branch/assign-clients': (ctx) =>
            BranchAssignDesktopClientsScreen(),
        '/administration/manage/desktop-client': (ctx) =>
            DesktopClientListScreen(),
        '/administration/manage/desktop-client/detail': (ctx) =>
            DesktopClientDetailScreen(),
        '/administration/manage/desktop-client/form': (ctx) =>
            DesktopClientFormScreen(),
        '/administration/manage/desktop-client/assign-branches': (ctx) =>
            DesktopClientAssignBranchesScreen(),
        '/administration/manage/user': (ctx) => UserListScreen(),
        '/administration/manage/user/detail': (ctx) => UserDetailScreen(),
        '/administration/manage/user/form': (ctx) => UserFormScreen(),
        '/administration/manage/user/assign-branches': (ctx) =>
            UserAssignBranchesScreen(),
        '/administration/manage/warehouse': (ctx) => WarehouseListScreen(),
        '/administration/manage/warehouse/detail': (ctx) =>
            WarehouseDetailScreen(),
        '/administration/manage/warehouse/form': (ctx) => WarehouseFormScreen(),
        '/administration/manage/accountant': (ctx) => AccountantListScreen(),
        '/administration/manage/accountant/form': (ctx) =>
            AccountantFormScreen(),
        '/administration/manage/cash-register': (ctx) =>
            CashRegisterListScreen(),
        '/administration/manage/cash-register/form': (ctx) =>
            CashRegisterFormScreen(),
        '/administration/manage/cash-register/detail': (ctx) =>
            CashRegisterDetailScreen(),
        '/reports': (ctx) => ReportsScreen(),
        '/reports/account/account-book': (ctx) => AccountBookScreen(),
        '/reports/account/account-book/form': (ctx) => AccountBookFormScreen(),
        '/reports/inventory/inventory-book': (ctx) => InventoryBookScreen(),
        '/reports/inventory/inventory-book/form': (ctx) =>
            InventoryBookFormScreen(),
        '/settings': (ctx) => SettingsScreen(),
        '/help': (ctx) => HelpScreen(),
        '/tenant-profile': (ctx) => TenantProfileScreen(),
        'tenant-profile/change-password': (ctx) => TenantChangePassword(),
        '/accounts/vouchers/payment': (ctx) => PaymentListScreen(),
        '/accounts/vouchers/payment/form': (ctx) => PaymentFormScreen(),
        '/accounts/vouchers/payment/detail': (ctx) => PaymentDetailScreen(),
        '/accounts/vouchers/accounts-vouchers-filter-form': (ctx) =>
            AccountsVouchersFilterForm(),
        '/reports/account/account-outstanding': (ctx) =>
            AccountOutstandingScreen(),
        '/reports/account/account-outstanding/form': (ctx) =>
            AccountOutstandingFormScreen(),
        '/reports/sales/sales-by-incharge': (ctx) => SalesByInchargeScreen(),
        '/reports/sales/sales-by-incharge/form': (ctx) =>
            SalesByInchargeFormScreen(),
        '/reports/sales/product-wise-sales': (ctx) => ProductWiseSalesScreen(),
        '/reports/sales/product-wise-sales/form': (ctx) =>
            ProductWiseSalesFormScreen(),
        '/reports/sales/sale-register': (ctx) => SaleRegisterScreen(),
        '/reports/sales/sale-register/form': (ctx) => SaleRegisterFormScreen(),
        '/reports/inventory/stock-analysis': (ctx) => StockAnalysisScreen(),
        '/reports/inventory/stock-analysis/form': (ctx) =>
            StockAnalysisFormScreen(),
        '/reports/inventory/stock-analysis/summary': (ctx) =>
            StockAnalysisSummaryScreen(),
        '/reports/inventory/stock-analysis/detail': (ctx) =>
            StockAnalysisDetailScreen(),
        '/reports/purchases/purchase-register/form': (ctx) =>
            PurchaseRegisterFormScreen(),
        '/reports/purchases/purchase-register': (ctx) =>
            PurchaseRegisterScreen(),
        '/accounts/vouchers/vouchers-pendings': (ctx) => VoucherPendingScreen(),
        '/accounts/vouchers/receipt': (ctx) => ReceiptListScreen(),
        '/accounts/vouchers/receipt/form': (ctx) => ReceiptFormScreen(),
        '/accounts/vouchers/receipt/detail': (ctx) => ReceiptDetailScreen(),
        '/accounts/vouchers/contra': (ctx) => ContraListScreen(),
        '/accounts/vouchers/contra/form': (ctx) => ContraFormScreen(),
        '/accounts/vouchers/contra/detail': (ctx) => ContraDetailScreen(),
        '/accounts/vouchers/journal': (ctx) => JournalListScreen(),
        '/accounts/vouchers/journal/form': (ctx) => JournalFormScreen(),
        '/accounts/vouchers/journal/detail': (ctx) => JournalDetailScreen(),
        '/inventory/sale': (ctx) => SaleListScreen(),
        '/inventory/sale/form': (ctx) => SaleFormScreen(),
        '/inventory/sale/detail': (ctx) => SaleDetailScreen(),
        '/inventory/sale-purchase-vouchers-filter-form': (ctx) =>
            SalePurchaseVouchersFilterForm(),
        '/inventory/sale/item/form': (ctx) => SaleItemFormScreen(),
        '/inventory/sale/item/batches/detail': (ctx) => SaleItemBatchDetail(),
      },
    );
  }
}
