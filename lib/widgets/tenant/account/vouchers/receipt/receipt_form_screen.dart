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

class ReceiptFormScreen extends StatefulWidget {
  @override
  _ReceiptFormScreenState createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends State<ReceiptFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  BuildContext _screenContext;
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
  List _assignedCashRegisterList = [];
  List adjustments = [];
  Map _voucherReceiptDetail = {};
  Map _receiptVoucherData = {};
  Map _toAccountData = {};
  Map _byAccountData = {};
  Map arguments = {};
  Map _toAccountDetail = {};
  Map _byAccountDetail = {};
  Map _selectedBranch = {};
  Map _selectedAccount = {};
  Map _selectedByAccount = {};
  Map _selectedCashRegister = {};
  String _receiptVoucherId = '';
  String _receiptVoucherName = '';
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
    if (arguments != null && arguments['id'] != null) {
      _voucherReceiptDetail = arguments['detail'];
      _receiptVoucherId = arguments['id'];
      _receiptVoucherName = arguments['displayName'];
      _getFormData();
    } else {
      _dateController.text = constants.defaultDate.format(DateTime.now());
    }
    super.didChangeDependencies();
  }

  void _getFormData() {
    List _receiptVoucherTransactions = _voucherReceiptDetail['trns'];
    _toAccountDetail = _receiptVoucherTransactions
            .where((element) => element['debit'] == 0)
            .isEmpty
        ? null
        : _receiptVoucherTransactions
            .where((element) => element['debit'] == 0)
            .first;
    _byAccountDetail = _receiptVoucherTransactions
            .where((element) => element['credit'] == 0)
            .isEmpty
        ? null
        : _receiptVoucherTransactions
            .where((element) => element['credit'] == 0)
            .first;
    _dateController.text = _dateController.text.isEmpty
        ? _voucherReceiptDetail['date'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : constants.defaultDate.format(
                DateTime.parse(
                  _voucherReceiptDetail['date'],
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
    _refNoController.text = _voucherReceiptDetail['refNo'];
    _amountController.text = double.parse(
      _toAccountDetail['credit'].toString(),
    ).toStringAsFixed(2);
    _instNoController.text = _byAccountDetail['instNo'];
    _descriptionController.text = _voucherReceiptDetail['description'];
    _selectedAccount = _toAccountDetail['account'];
    _selectedByAccount = _byAccountDetail['account'];
    adjustments =
        _toAccountDetail['adjs'] == null ? [] : _toAccountDetail['adjs'];
    if (_voucherReceiptDetail['cashRegisterEnabled'] != null &&
            _voucherReceiptDetail['cashRegisterEnabled'] == true ||
        _selectedByAccount['accountType'] == 'CASH') {
      if (_assignedCashRegisterList.length == 1) {
        _selectedCashRegister = _assignedCashRegisterList.single;
        _byAccountDetail['cashRegister'] = _assignedCashRegisterList.single;
        _cashRegisterController.text = _assignedCashRegisterList.first['name'];
      }
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (adjustments.isNotEmpty && !_toAccountData.containsKey('adjs')) {
        _toAccountData.addAll(
          {
            'adjs': adjustments,
          },
        );
      }
      _receiptVoucherData.addAll(
        {
          'branch': _selectedBranch['id'],
          'voucherType': "RECEIPT",
          'cashRegister': _selectedCashRegister.isEmpty
              ? null
              : _selectedCashRegister['id'],
          'trns': [_toAccountData, _byAccountData],
        },
      );
      try {
        if (_receiptVoucherId.isEmpty) {
          await _voucherProvider.createVoucher(_receiptVoucherData);
          utils.showSuccessSnackbar(
              _screenContext, 'Receipt Voucher Created Successfully');
        } else {
          await _voucherProvider.updateVoucher(
            _receiptVoucherId,
            _receiptVoucherData,
          );
          utils.showSuccessSnackbar(
              _screenContext, 'Receipt Voucher updated Successfully');
        }
        Navigator.of(_screenContext).pushReplacementNamed(
          '/accounts/vouchers/receipt',
          arguments: arguments['filterData'],
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  bool _chkAccountType(Map accountData) {
    List accountTypes = [
      "TRADE_RECEIVABLE",
      "TRADE_PAYABLE",
      "ACCOUNT_PAYABLE",
      "ACCOUNT_RECEIVABLE",
    ];
    return accountData == null
        ? false
        : accountTypes
            .where((element) => element == accountData['accountType'])
            .isNotEmpty;
  }

  Widget _accountReceiptVoucherInfo() {
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
                  _receiptVoucherData['date'] = constants.isoDateFormat
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
                    _receiptVoucherData.addAll({'refNo': val});
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

  Widget _accountReceiptFormTransactionInfo() {
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
                      "ACCOUNT_PAYABLE",
                      "ACCOUNT_RECEIVABLE",
                    ],
                  );
                },
                validator: (val) {
                  if (toAccountId.isEmpty && val == null) {
                    return 'Receipt Account should not be empty';
                  }
                  return null;
                },
                labelText: 'Receipt Account',
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
                onSelected: (value) {
                  setState(() {
                    _toAccountDetail['account'] = value;
                    _selectedAccount = value;
                  });
                  if (_chkAccountType(_selectedAccount)) {
                    Navigator.of(context).pushNamed(
                      '/accounts/vouchers/vouchers-pendings',
                      arguments: {
                        'branch': _selectedBranch,
                        'account': value,
                        'voucherMode': '1',
                        'adjustments': adjustments,
                        'voucherId': _receiptVoucherId,
                        'voucherType': 'receipt',
                        'amount': _amountController.text.isEmpty
                            ? 0
                            : double.parse(_amountController.text),
                      },
                    ).then(
                      (value) {
                        if (value != null) {
                          Map data = value;
                          _toAccountData.addAll(
                            {
                              'adjs': data['adjustments'],
                            },
                          );
                          _amountController.text = data['adjustmentTotal'];
                        }
                      },
                    );
                  }
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
                        'routeForm': 'ReceiptToAccount',
                        'id': _receiptVoucherId,
                        'displayName': _receiptVoucherName,
                        'detail': _receiptVoucherData,
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
              Visibility(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: Text(
                          "Show Pendings",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/accounts/vouchers/vouchers-pendings',
                            arguments: {
                              'branch': _selectedBranch,
                              'account': _selectedAccount,
                              'voucherMode': '1',
                              'adjustments': adjustments,
                              'voucherId': _receiptVoucherId,
                              'voucherType': 'receipt',
                              'amount': _amountController.text.isEmpty
                                  ? 0
                                  : double.parse(_amountController.text),
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                Map data = value;
                                _toAccountData.addAll(
                                  {
                                    'adjs': data['adjustments'],
                                  },
                                );
                                _amountController.text =
                                    data['adjustmentTotal'];
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
                visible: _chkAccountType(_selectedAccount),
              ),
              SizedBox(
                height: 15.0,
              ),
              AutocompleteFormField(
                initialValue: utils.cast<Map<String, dynamic>>(
                  _byAccountDetail['account'],
                ),
                autoFocus: false,
                controller: _byAccountController,
                autocompleteCallback: (pattern) {
                  return _accountProvider.accountAutocomplete(
                    searchText: pattern,
                    accountType: [
                      "BANK_ACCOUNT",
                      "CASH",
                      "BANK_OD_ACCOUNT",
                    ],
                  );
                },
                validator: (val) {
                  if (byAccountId.isEmpty && val == null) {
                    return 'Bank/Cash should not be empty';
                  }
                  return null;
                },
                labelText: 'Bank/Cash',
                labelStyle: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                onSaved: (val) {
                  _byAccountData.addAll({
                    'account': byAccountId.isEmpty ? val['id'] : byAccountId
                  });
                },
                onSelected: (val) {
                  setState(() {
                    _byAccountDetail['account'] = val;
                    _selectedByAccount = val;
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
                        'routeForm': 'ReceiptToAccount',
                        'id': _receiptVoucherId,
                        'displayName': _receiptVoucherName,
                        'detail': _receiptVoucherData,
                        'formInputName': _byAccountController.text,
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          arguments = value;
                          byAccountId = arguments['routeFormArguments']['id'];
                          _byAccountController.text =
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
              Visibility(
                child: Column(
                  children: [
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
                  ],
                ),
                visible: _voucherReceiptDetail['cashRegisterEnabled'] != null &&
                        _voucherReceiptDetail['cashRegisterEnabled'] == true ||
                    _selectedByAccount['accountType'] == 'CASH',
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                readOnly: _chkAccountType(_selectedAccount),
                controller: _amountController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                  border: OutlineInputBorder(),
                  fillColor: _chkAccountType(_selectedAccount)
                      ? Colors.grey[50]
                      : null,
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
                  _toAccountData.addAll(
                    {
                      'credit': double.parse(val),
                      'debit': 0,
                    },
                  );
                  _byAccountData.addAll(
                    {
                      'debit': double.parse(val),
                      'credit': 0,
                    },
                  );
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
                visible: _selectedByAccount['accountType'] != 'CASH',
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
                    _receiptVoucherData.addAll({'description': val});
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
            _receiptVoucherName.isEmpty ? 'Add Receipt' : _receiptVoucherName,
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
                      _accountReceiptVoucherInfo(),
                      _accountReceiptFormTransactionInfo(),
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
