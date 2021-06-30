import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../constants.dart' as constants;
import './../../../../utils.dart' as utils;

class AccountsVouchersFilterForm extends StatefulWidget {
  @override
  _AccountsVouchersFilterFormState createState() =>
      _AccountsVouchersFilterFormState();
}

class _AccountsVouchersFilterFormState
    extends State<AccountsVouchersFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AccountProvider _accountProvider;
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _voucherNoController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final FocusNode _voucherNoFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _accountFocusNode = FocusNode();
  String voucherNoFilterKey;
  String refNoFilterKey;
  String amountFilterKey;
  Map _formData = Map();

  @override
  void dispose() {
    _voucherNoFocusNode.dispose();
    _refNoFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
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
    _accountController.text =
        _formData['account'] == '' || _formData['account'] == null
            ? ''
            : _formData['account']['name'];
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
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                autoFocus: false,
                initialValue:
                    utils.cast<Map<String, dynamic>>(_formData['account']),
                focusNode: _accountFocusNode,
                controller: _accountController,
                autocompleteCallback: (pattern) {
                  return _accountProvider.accountAutocomplete(
                    searchText: pattern,
                    accountType: _formData['filterFormName'] == 'Contra'
                        ? [
                            "BANK_ACCOUNT",
                            "CASH",
                            "BANK_OD_ACCOUNT",
                          ]
                        : [
                            "CURRENT_ASSET",
                            "CURRENT_LIABILITY",
                            "FIXED_ASSET",
                            "LONGTERM_LIABILITY",
                            "EQUITY",
                            "UNDEPOSITED_FUNDS",
                            "EFT_ACCOUNT",
                            "DIRECT_EXPENSE",
                            "INDIRECT_EXPENSE",
                            "TRADE_RECEIVABLE",
                            "TRADE_PAYABLE",
                          ],
                  );
                },
                validator: null,
                labelText: 'Account',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  if (val != null) {
                    _formData['account'] = _accountController.text.isEmpty
                        ? _formData['account'] = ''
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
