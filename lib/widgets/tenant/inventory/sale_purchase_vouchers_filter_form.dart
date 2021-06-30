import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/customer_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/vendor_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../constants.dart' as constants;
import './../../../utils.dart' as utils;

class SalePurchaseVouchersFilterForm extends StatefulWidget {
  @override
  _SalePurchaseVouchersFilterFormState createState() =>
      _SalePurchaseVouchersFilterFormState();
}

class _SalePurchaseVouchersFilterFormState
    extends State<SalePurchaseVouchersFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  CustomerProvider _customerProvider;
  InventoryItemProvider _inventoryItemProvider;
  VendorProvider _vendorProvider;
  TenantAuth _tenantAuth;
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController _vendorController = TextEditingController();
  TextEditingController _inventoryController = TextEditingController();
  TextEditingController _voucherNoController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final FocusNode _voucherNoFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _customerFocusNode = FocusNode();
  final FocusNode _vendorFocusNode = FocusNode();
  final FocusNode _inventoryFocusNode = FocusNode();
  String voucherNoFilterKey;
  String refNoFilterKey;
  String amountFilterKey;
  Map _formData = Map();
  Map _selectedBranch = {};

  @override
  void dispose() {
    _voucherNoFocusNode.dispose();
    _refNoFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _vendorProvider = Provider.of<VendorProvider>(context);
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    _formData = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _fromDateController.text = _fromDateController.text.isEmpty
        ? _formData['fromDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : _formData['fromDate']
        : _fromDateController.text;
    _toDateController.text = _toDateController.text.isEmpty
        ? _formData['toDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : _formData['toDate']
        : _fromDateController.text;
    _customerController.text =
        _formData['customer'] == '' || _formData['customer'] == null
            ? ''
            : _formData['customer']['name'];
    _vendorController.text =
        _formData['vendor'] == '' || _formData['vendor'] == null
            ? ''
            : _formData['vendor']['name'];
    _inventoryController.text =
        _formData['inventory'] == '' || _formData['inventory'] == null
            ? ''
            : _formData['inventory']['name'];
    _voucherNoController.text = _formData['voucherNo'];
    _refNoController.text = _formData['refNo'];
    _amountController.text = _formData['amount'];
    voucherNoFilterKey = _formData['voucherNoFilterKey'];
    amountFilterKey = _formData['amountFilterKey'];
    refNoFilterKey = _formData['refNoFilterKey'];
  }

  Widget _buildFilterForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              DatePickerFormField(
                title: 'From Date',
                controller: _fromDateController,
                onSaved: (value) {
                  if (value != '') {
                    _formData['fromDate'] = value;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              DatePickerFormField(
                title: 'To Date',
                controller: _toDateController,
                onSaved: (value) {
                  if (value != '') {
                    _formData['toDate'] = value;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'Voucher No',
                filterType: 'text',
                autoFocus: false,
                filterKey: voucherNoFilterKey,
                textEditingController: _voucherNoController,
                focusNode: _voucherNoFocusNode,
                nextFocusNode: _refNoFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['voucherNo'] = val;
                },
                buttonOnPressed: (val) {
                  voucherNoFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'Reference No',
                filterType: 'text',
                autoFocus: false,
                filterKey: refNoFilterKey,
                textEditingController: _refNoController,
                focusNode: _refNoFocusNode,
                nextFocusNode: _amountFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['refNo'] = val;
                },
                buttonOnPressed: (val) {
                  refNoFilterKey = val;
                },
              ),
              Visibility(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      autoFocus: false,
                      initialValue: utils
                          .cast<Map<String, dynamic>>(_formData['customer']),
                      focusNode: _customerFocusNode,
                      controller: _customerController,
                      autocompleteCallback: (pattern) {
                        return _customerProvider.customerAutoComplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Customer',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['customer'] =
                              _customerController.text.isEmpty
                                  ? _formData['customer'] = ''
                                  : val;
                        }
                      },
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Sale',
              ),
              Visibility(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      autoFocus: false,
                      initialValue:
                          utils.cast<Map<String, dynamic>>(_formData['vendor']),
                      focusNode: _vendorFocusNode,
                      controller: _vendorController,
                      autocompleteCallback: (pattern) {
                        return _vendorProvider.vendorAutoComplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Vendor',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        if (val != null) {
                          _formData['vendor'] = _vendorController.text.isEmpty
                              ? _formData['vendor'] = ''
                              : val;
                        }
                      },
                    ),
                  ],
                ),
                visible: _formData['filterFormName'] == 'Purchase',
              ),
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                autoFocus: false,
                initialValue:
                    utils.cast<Map<String, dynamic>>(_formData['inventory']),
                focusNode: _inventoryFocusNode,
                controller: _inventoryController,
                autocompleteCallback: (pattern) {
                  return _inventoryItemProvider.inventoryItemAutoComplete(
                    searchText: pattern,
                    inventoryHeads: [
                      _selectedBranch['inventoryHead'],
                    ],
                  );
                },
                validator: null,
                labelText: 'Inventory',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  if (val != null) {
                    _formData['inventory'] = _inventoryController.text.isEmpty
                        ? _formData['inventory'] = ''
                        : val;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'Amount',
                filterType: 'number',
                autoFocus: false,
                filterKey: amountFilterKey,
                textEditingController: _amountController,
                focusNode: _amountFocusNode,
                nextFocusNode: null,
                textInputAction: TextInputAction.done,
                onChanged: (val) {
                  _formData['amount'] = val;
                },
                buttonOnPressed: (val) {
                  amountFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_formData['filterFormName']),
        actions: [
          TextButton(
            onPressed: () {
              _formKey.currentState.save();
              _formData['voucherNoFilterKey'] = voucherNoFilterKey;
              _formData['refNoFilterKey'] = refNoFilterKey;
              _formData['amountFilterKey'] = amountFilterKey;
              _formData['isAdvancedFilter'] = 'true';
              Navigator.of(context).pop(_formData);
            },
            child: Text(
              'SEARCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: _buildFilterForm(context),
    );
  }
}
