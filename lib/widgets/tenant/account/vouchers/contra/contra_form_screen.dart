import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class ContraFormScreen extends StatefulWidget {
  @override
  _ContraFormScreenState createState() => _ContraFormScreenState();
}

class _ContraFormScreenState extends State<ContraFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  AccountProvider _accountProvider;
  VoucherProvider _voucherProvider;
  CashRegisterProvider _cashRegisterProvider;
  TenantAuth _tenantAuth;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _toAccountController = TextEditingController();
  TextEditingController _byAccountController = TextEditingController();
  TextEditingController _cashRegisterController = TextEditingController();
  TextEditingController _instDateController = TextEditingController();
  TextEditingController _instNoController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Map _contraDetail = {};
  Map _contraData = {};
  BuildContext _screenContext;
  String _contraVoucherId = '';
  String _contraVoucherName = '';
  Map _toAccountData = {};
  Map _byAccountData = {};
  Map arguments = {};
  Map _toAccountDetail = {};
  Map _byAccountDetail = {};
  Map _selectedBranch = {};
  Map _selectedCashRegister = {};
  List _assignedCashRegisterList = [];
  String toAccountId = '';
  String byAccountId = '';

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    _voucherProvider = Provider.of<VoucherProvider>(context);
    _cashRegisterProvider = Provider.of<CashRegisterProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _tenantAuth = Provider.of<TenantAuth>(context);
    _assignedCashRegisterList = _tenantAuth.assignedCashRegisters;
    _selectedBranch = _tenantAuth.selectedBranch;
    if (arguments != null) {
      if (arguments['id'] == null && arguments['formName'] != null) {
        _dateController.text = constants.defaultDate.format(DateTime.now());
      } else {
        _contraDetail = arguments['detail'];
        _contraVoucherId = arguments['id'];
        _contraVoucherName = arguments['displayName'];
        _getFormData();
      }
    }
    _getCashAccount();
    super.didChangeDependencies();
  }

  void _getCashAccount() async {
    List data = await _accountProvider.accountAutocomplete(
      searchText: '',
      accountType: ['CASH'],
    );
    _byAccountDetail.addAll(data.first);
    _byAccountController.text = data.first['name'];
    _byAccountData.addAll({'account': data.first['id']});
  }

  void _getFormData() {
    List _contraVoucherTransactions = _contraDetail['trns'];
    _toAccountDetail = arguments['formName'] == 'CD'
        ? _contraVoucherTransactions
            .where((element) => element['credit'] == 0)
            .first
        : _contraVoucherTransactions
            .where((element) => element['debit'] == 0)
            .first;
    _byAccountDetail = arguments['formName'] == 'CD'
        ? _contraVoucherTransactions
            .where((element) => element['debit'] == 0)
            .first
        : _contraVoucherTransactions
            .where((element) => element['credit'] == 0)
            .first;
    _dateController.text = _dateController.text.isEmpty
        ? _contraDetail['date'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : constants.defaultDate.format(
                DateTime.parse(
                  _contraDetail['date'],
                ),
              )
        : _dateController.text;
    _instDateController.text = _instDateController.text.isEmpty
        ? _byAccountDetail.containsKey('instDate') == false
            ? ''
            : constants.defaultDate.format(
                DateTime.parse(
                  _byAccountDetail['instDate'],
                ),
              )
        : _instDateController.text;
    _toAccountController.text =
        _toAccountDetail == null ? '' : _toAccountDetail['account']['name'];
    _byAccountController.text =
        _byAccountDetail == null ? '' : _byAccountDetail['account']['name'];
    _refNoController.text = _contraDetail['refNo'];
    _amountController.text = double.parse(
      arguments['formName'] == 'CD'
          ? _toAccountDetail['debit'].toString()
          : _toAccountDetail['credit'].toString(),
    ).toStringAsFixed(2);
    _instNoController.text = _byAccountDetail['instNo'];
    _descriptionController.text = _contraDetail['description'];
    if (_contraDetail['cashRegisterEnabled'] != null &&
        _contraDetail['cashRegisterEnabled'] == true) {
      if (_assignedCashRegisterList.length == 1) {
        _selectedCashRegister = _assignedCashRegisterList.last;
        _byAccountDetail['cashRegister'] = _assignedCashRegisterList.last;
        _cashRegisterController.text = _assignedCashRegisterList.first['name'];
      }
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _contraData.addAll(
        {
          'branch': _selectedBranch['id'],
          'voucherType': "CONTRA",
          'cashRegister': _selectedCashRegister.isEmpty
              ? null
              : _selectedCashRegister['id'],
          'trns': [_toAccountData, _byAccountData],
        },
      );
      try {
        if (_contraVoucherId.isEmpty) {
          await _voucherProvider.createVoucher(_contraData);
          utils.showSuccessSnackbar(
              _screenContext, 'Contra Voucher Created Successfully');
        } else {
          await _voucherProvider.updateVoucher(
            _contraVoucherId,
            _contraData,
          );
          utils.showSuccessSnackbar(
              _screenContext, 'Contra Voucher updated Successfully');
        }
        Navigator.of(_screenContext).pushReplacementNamed(
          '/accounts/vouchers/contra',
          arguments: arguments['filterData'],
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _accountContraVoucherInfo() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'VOUCHER INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              DatePickerFormField(
                title: 'Date',
                controller: _dateController,
                onSaved: (value) {
                  _contraData['date'] = constants.isoDateFormat
                      .format(constants.defaultDate.parse(value));
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _refNoController,
                decoration: InputDecoration(
                  labelText: 'Ref.No',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.subtitle1,
                textInputAction: TextInputAction.next,
                onSaved: (val) {
                  if (val.isNotEmpty) {
                    _contraData.addAll({'refNo': val});
                  }
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

  Widget _accountContraFormTransactionInfo() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'TRANSACTION INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              AutocompleteFormField(
                initialValue: utils.cast<Map<String, dynamic>>(
                  _toAccountDetail['account'],
                ),
                autoFocus: false,
                controller: _toAccountController,
                autocompleteCallback: (pattern) {
                  return _accountProvider.accountAutocomplete(
                    searchText: pattern,
                    accountType: [
                      "BANK_ACCOUNT",
                      "BANK_OD_ACCOUNT",
                    ],
                  );
                },
                validator: (val) {
                  if (toAccountId.isEmpty && val == null) {
                    return 'Bank should not be empty';
                  }
                  return null;
                },
                labelText: 'Bank',
                labelStyle: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  _toAccountData.addAll({
                    'account': toAccountId.isEmpty ? val['id'] : toAccountId
                  });
                },
                suffixIconWidget: Visibility(
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(
                      '/accounts/manage/account/form',
                      arguments: {
                        'routeForm': 'ContraToAccount',
                        'id': _contraVoucherId,
                        'displayName': _contraVoucherName,
                        'detail': _contraData,
                        'formInputName': _toAccountController.text,
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          arguments = value;
                          toAccountId = arguments['routeFormArguments']['id'];
                          _toAccountController.text =
                              arguments['routeFormArguments']['name'];
                        });
                      }
                    }),
                  ),
                  visible: utils.checkMenuWiseAccess(
                    context,
                    [
                      'ac.ac.cr',
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                readOnly: true,
                controller: _byAccountController,
                decoration: InputDecoration(
                  labelText: 'Cash Account',
                  labelStyle: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey[50],
                  filled: true,
                ),
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.subtitle1,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                initialValue: utils.cast<Map<String, dynamic>>(
                  _byAccountDetail['cashRegister'],
                ),
                autoFocus: false,
                controller: _cashRegisterController,
                autocompleteCallback: (pattern) {
                  return _cashRegisterProvider.cashRegisterAutoComplete(
                    searchText: pattern,
                  );
                },
                validator: (val) {
                  if (val == null) {
                    return 'Cash Register should not be empty';
                  }
                  return null;
                },
                labelText: 'Cash Register',
                labelStyle: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  _selectedCashRegister = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _amountController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.subtitle1,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val == null) {
                    return 'Amount should not be empty';
                  }
                  return null;
                },
                onSaved: (val) {
                  if (arguments['formName'] == 'CD') {
                    _toAccountData.addAll(
                      {
                        'debit': double.parse(val),
                        'credit': 0,
                      },
                    );
                    _byAccountData.addAll(
                      {
                        'credit': double.parse(val),
                        'debit': 0,
                      },
                    );
                  } else if (arguments['formName'] == 'CW') {
                    _toAccountData.addAll(
                      {
                        'debit': 0,
                        'credit': double.parse(val),
                      },
                    );
                    _byAccountData.addAll(
                      {
                        'credit': 0,
                        'debit': double.parse(val),
                      },
                    );
                  }
                },
              ),
              Visibility(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    DatePickerFormField(
                      title: 'Instrument Date',
                      controller: _instDateController,
                      onSaved: (value) {
                        if (value != '' && value != null) {
                          _byAccountData['instDate'] = constants.isoDateFormat
                              .format(constants.defaultDate.parse(value));
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _instNoController,
                      decoration: InputDecoration(
                        labelText: 'Instrument No',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.subtitle1,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) {
                        if (val.isNotEmpty) {
                          _byAccountData.addAll({'instNo': val});
                        }
                      },
                    ),
                  ],
                ),
                visible: arguments['formName'] == 'CW',
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.subtitle1,
                onSaved: (val) {
                  if (val.isNotEmpty) {
                    _contraData.addAll({'description': val});
                  }
                },
                maxLines: null,
              ),
              SizedBox(
                height: 20.0,
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
          title: Text(
            _contraVoucherName.isEmpty
                ? arguments['formName'] == 'CD'
                    ? 'Add Cash Deposit'
                    : 'Add Cash Withdrawal'
                : _contraVoucherName,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _onSubmit();
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            _screenContext = context;
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _accountContraVoucherInfo(),
                      _accountContraFormTransactionInfo(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      onWillPop: () async {
        utils.showAlertDialog(
          context,
          () => Navigator.of(context).pop(),
          'Discard Changes?',
          'Changes will be discarded once you leave this page',
        );
        return true;
      },
    );
  }
}
