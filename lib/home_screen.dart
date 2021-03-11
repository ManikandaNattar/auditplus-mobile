import 'package:auditplusmobile/widgets/tenant/account/accounts_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/account/accounts_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/account/account_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_category/cost_category_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/account/manage/cost_centre/cost_centre_list_screen.dart';
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
import 'package:auditplusmobile/widgets/tenant/administration/manage/sale_incharge/sale_incharge_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/sale_incharge/sale_incharge_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/warehouse/warehouse_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/contacts_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/contacts_opening_form.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/customer/customer_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/customer/customer_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/customer/customer_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/doctor/doctor_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/doctor/doctor_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/doctor/doctor_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/patient/patient_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/patient/patient_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/patient/patient_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/vendor/vendor_detail_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/vendor/vendor_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/vendor/vendor_list_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/manage/vendor/vendor_opening_screen.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/payment_receipt_filter_form.dart';
import 'package:auditplusmobile/widgets/tenant/contacts/vendor/payment/vendor_payment_list_screen.dart';
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
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_book/customer_book_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_book/customer_book_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/customer/customer_outstanding/customer_outstanding_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_book/vendor_book_form_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_book/vendor_book_screen.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_form.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_screen.dart';
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
import 'widgets/tenant/contacts/contacts_filter_form.dart';
import 'widgets/tenant/contacts/manage/customer/customer_list_screen.dart';

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
        '/contacts': (ctx) => ContactsScreen(),
        '/contacts/manage/contacts-filter-form': (ctx) => ContactsFilterForm(),
        '/contacts/manage/customer': (ctx) => CustomerListScreen(),
        '/contacts/manage/customer/detail': (ctx) => CustomerDetailScreen(),
        '/contacts/manage/customer/form': (ctx) => CustomerFormScreen(),
        '/contacts/manage/vendor': (ctx) => VendorListScreen(),
        '/contacts/manage/vendor/detail': (ctx) => VendorDetailScreen(),
        '/contacts/manage/vendor/form': (ctx) => VendorFormScreen(),
        '/contacts/manage/doctor': (ctx) => DoctorListScreen(),
        '/contacts/manage/doctor/detail': (ctx) => DoctorDetailScreen(),
        '/contacts/manage/doctor/form': (ctx) => DoctorFormScreen(),
        '/contacts/manage/patient': (ctx) => PatientListScreen(),
        '/contacts/manage/patient/detail': (ctx) => PatientDetailScreen(),
        '/contacts/manage/patient/form': (ctx) => PatientFormScreen(),
        '/contacts/manage/customer/opening': (ctx) => CustomerOpeningScreen(),
        '/contacts/manage/contacts-opening-form': (ctx) =>
            ContactsOpeningForm(),
        '/contacts/manage/vendor/opening': (ctx) => VendorOpeningScreen(),
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
        '/accounts': (ctx) => AccountsScreen(),
        '/accounts/manage/accounts-filter-form': (ctx) => AccountsFilterForm(),
        '/accounts/manage/account': (ctx) => AccountListScreen(),
        '/accounts/manage/account/detail': (ctx) => AccountDetailScreen(),
        '/accounts/manage/account/form': (ctx) => AccountFormScreen(),
        '/accounts/manage/account/opening': (ctx) => AccountOpeningScreen(),
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
        '/administration/manage/sale-incharge': (ctx) =>
            SaleInchargeListScreen(),
        '/administration/manage/sale-incharge/form': (ctx) =>
            SaleInchargeFormScreen(),
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
        '/reports/customer/customer-outstanding': (ctx) =>
            CustomerOutstandingScreen(),
        '/reports/customer/customer-outstanding/form': (ctx) =>
            CustomerOutstandingFormScreen(),
        '/reports/account/account-book': (ctx) => AccountBookScreen(),
        '/reports/account/account-book-form': (ctx) => AccountBookFormScreen(),
        '/reports/vendor/vendor-outstanding': (ctx) =>
            VendorOutstandingScreen(),
        '/reports/vendor/vendor-outstanding/form': (ctx) =>
            VendorOutstandingForm(),
        '/reports/customer/customer-book': (ctx) => CustomerBookScreen(),
        '/reports/customer/customer-book-form': (ctx) =>
            CustomerBookFormScreen(),
        '/reports/vendor/vendor-book': (ctx) => VendorBookScreen(),
        '/reports/vendor/vendor-book-form': (ctx) => VendorBookFormScreen(),
        '/reports/inventory/inventory-book': (ctx) => InventoryBookScreen(),
        '/reports/inventory/inventory-book-form': (ctx) =>
            InventoryBookFormScreen(),
        '/contacts/vendor/payment': (ctx) => VendorPaymentListScreen(),
        '/contacts/payment-receipt-filter-form': (ctx) =>
            PaymentReceiptFilterForm(),
      },
    );
  }
}
