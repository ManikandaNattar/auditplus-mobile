import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/contacts/customer_provider.dart';
import 'package:auditplusmobile/providers/contacts/vendor_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../constants.dart' as constants;
import './../../../utils.dart' as utils;

class PaymentReceiptFilterForm extends StatefulWidget {
  @override
  _PaymentReceiptFilterFormState createState() =>
      _PaymentReceiptFilterFormState();
}

class _PaymentReceiptFilterFormState extends State<PaymentReceiptFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  VendorProvider _vendorProvider;
  CustomerProvider _customerProvider;
  AccountProvider _accountProvider;
  final TextEditingController _formDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _voucherNoController = TextEditingController();
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _byAccountController = TextEditingController();
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _fromDateFocusNode = FocusNode();
  final FocusNode _toDateFocusNode = FocusNode();
  final FocusNode _voucherNoFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _byAccountFocusNode = FocusNode();
  final FocusNode _toAccountFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  String voucherNoFilterKey;
  String refNoFilterKey;
  String amountFilterKey;
  Map _formData = Map();

  @override
  void dispose() {
    _voucherNoFocusNode.dispose();
    _fromDateFocusNode.dispose();
    _toDateFocusNode.dispose();
    _refNoFocusNode.dispose();
    _byAccountFocusNode.dispose();
    _toAccountFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _vendorProvider = Provider.of<VendorProvider>(context);
    _accountProvider = Provider.of<AccountProvider>(context);
    _customerProvider = Provider.of<CustomerProvider>(context);
    _formData = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _formDateController.text = _formDateController.text.isEmpty
        ? _formData['fromDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : _formData['fromDate']
        : _formDateController.text;
    _toDateController.text = _toDateController.text.isEmpty
        ? _formData['toDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : _formData['toDate']
        : _toDateController.text;
    _voucherNoController.text = _formData['voucherNo'];
    _refNoController.text = _formData['refNo'];
    _byAccountController.text =
        _formData['byAccount'] == '' || _formData['byAccount'] == null
            ? ''
            : _formData['byAccount']['name'];
    _toAccountController.text =
        _formData['toAccount'] == '' || _formData['toAccount'] == null
            ? ''
            : _formData['toAccount']['name'];
    _amountController.text = _formData['amount'];
    voucherNoFilterKey = _formData['voucherNoFilterKey'];
    refNoFilterKey = _formData['refNoFilterKey'];
    amountFilterKey = _formData['amountFilterKey'];
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
                controller: _formDateController,
                onSaved: (value) {
                  _formData['fromDate'] = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              DatePickerFormField(
                title: 'To Date',
                controller: _toDateController,
                onSaved: (value) {
                  _formData['toDate'] = value;
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
                labelName: 'Ref.No',
                filterType: 'text',
                autoFocus: false,
                filterKey: refNoFilterKey,
                textEditingController: _refNoController,
                focusNode: _refNoFocusNode,
                nextFocusNode: _toAccountFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['refNo'] = val;
                },
                buttonOnPressed: (val) {
                  refNoFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                initialValue:
                    utils.cast<Map<String, dynamic>>(_formData['toAccount']),
                focusNode: _toAccountFocusNode,
                controller: _toAccountController,
                autoFocus: false,
                autocompleteCallback: (pattern) {
                  return _formData['filterFormName'] == 'CustomerPayment'
                      ? _customerProvider.customerAutoComplete(
                          searchText: pattern,
                        )
                      : _vendorProvider.vendorAutoComplete(
                          searchText: pattern,
                        );
                },
                validator: null,
                labelText: _formData['filterFormName'] == 'CustomerPayment'
                    ? 'Customer'
                    : 'Vendor',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  if (val != null) {
                    _formData['toAccount'] = _toAccountController.text.isEmpty
                        ? _formData['toAccount'] = ''
                        : val;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                initialValue:
                    utils.cast<Map<String, dynamic>>(_formData['byAccount']),
                focusNode: _byAccountFocusNode,
                controller: _byAccountController,
                autoFocus: false,
                autocompleteCallback: (pattern) {
                  return _accountProvider.accountAutocomplete(
                    searchText: pattern,
                    accountType: [
                      'BANK_ACCOUNT',
                      'CASH',
                      'BANK_OD_ACCOUNT',
                      'EFT_ACCOUNT',
                    ],
                  );
                },
                validator: null,
                labelText: 'Paid Through',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  if (val != null) {
                    _formData['byAccount'] = _byAccountController.text.isEmpty
                        ? _formData['byAccount'] = ''
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
    );
  }
}
