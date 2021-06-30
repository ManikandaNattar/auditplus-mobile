import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../voucher_pending_screen.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class JournalFormScreen extends StatefulWidget {
  @override
  _JournalFormScreenState createState() => _JournalFormScreenState();
}

class _JournalFormScreenState extends State<JournalFormScreen> {
  AdjustmentForOption _adjustmentForOption = AdjustmentForOption.DebitAmount;
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  VoucherProvider _voucherProvider;
  AccountProvider _accountProvider;
  TenantAuth _tenantAuth;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List adjustments = [];
  List _journalVoucherTransList = [];
  List<TextEditingController> _debitControllerList = [];
  List<TextEditingController> _creditControllerList = [];
  Map _journalVoucherTransData = {};
  Map _journalDetail = {};
  Map _journalVoucherData = {};
  Map arguments = {};
  Map _selectedBranch = {};
  String _journalVoucherId = '';
  String _journalVoucherName = '';
  int _rowCount = 1;

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    _accountProvider = Provider.of<AccountProvider>(context);
    if (arguments != null && arguments['id'] != null) {
      _journalDetail = arguments['detail'];
      _journalVoucherId = arguments['id'];
      _journalVoucherName = arguments['displayName'];
      _getFormData();
    } else {
      _dateController.text = _dateController.text.isEmpty
          ? constants.defaultDate.format(DateTime.now())
          : _dateController.text;
      if (_journalVoucherTransList.isEmpty) {
        _journalVoucherTransList = [
          {'id': 0},
          {'id': 1}
        ];
      }
    }
    super.didChangeDependencies();
  }

  void _getFormData() {
    _dateController.text = _dateController.text.isEmpty
        ? _journalDetail['date'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : constants.defaultDate.format(
                DateTime.parse(
                  _journalDetail['date'],
                ),
              )
        : _dateController.text;
    _descriptionController.text = _journalDetail['description'];
    _refNoController.text = _journalDetail['refNo'];
    _journalVoucherTransList = _journalDetail['trns'];
    _rowCount = _journalDetail['trns'].length;
  }

  bool _chkForm() {
    return _journalVoucherTransList.first['account'] != null &&
        _journalVoucherTransList.first['debit'] != null &&
        _journalVoucherTransList.first['credit'] != null;
  }

  Future<void> _onSubmit() async {
    List trans = [];
    if (_chkForm()) {
      if (_getDebitTotal() == _getCreditTotal()) {
        _formKey.currentState.save();
        _journalVoucherTransList.forEach(
          (element) {
            List trnsAdjs = element['adjs'];
            List adjs = [];
            if (trnsAdjs != null) {
              trnsAdjs.forEach((e) {
                adjs.add(
                  {
                    'pending': e['pending'],
                    'amount': e['amount'],
                  },
                );
              });
            }
            trans.add(
              {
                'account': element['account']['id'],
                'debit': element['debit'],
                'credit': element['credit'],
                'adjs': adjs,
              },
            );
          },
        );
        _journalVoucherData.addAll(
          {
            'branch': _selectedBranch['id'],
            'voucherType': "JOURNAL",
            'cashRegister': null,
            'trns': trans,
          },
        );
        try {
          if (_journalVoucherId.isEmpty) {
            await _voucherProvider.createVoucher(_journalVoucherData);
            utils.showSuccessSnackbar(
                _screenContext, 'Journal Voucher Created Successfully');
          } else {
            await _voucherProvider.updateVoucher(
              _journalVoucherId,
              _journalVoucherData,
            );
            utils.showSuccessSnackbar(
                _screenContext, 'Journal Voucher updated Successfully');
          }
          Navigator.of(_screenContext).pushReplacementNamed(
            '/accounts/vouchers/journal',
            arguments: arguments['filterData'],
          );
        } catch (error) {
          utils.handleErrorResponse(_screenContext, error.message, 'tenant');
        }
      } else {
        utils.handleErrorResponse(
          _screenContext,
          'Total debit and credit should be equal',
          'tenant',
        );
      }
    } else {
      utils.handleErrorResponse(
        _screenContext,
        'Transactions must contain 2 accounts',
        'tenant',
      );
    }
  }

  Widget _journalVoucherInfo() {
    return Container(
      padding: EdgeInsets.all(4.0),
      width: double.infinity,
      child: Card(
        elevation: 5.0,
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
                  _journalVoucherData['date'] = constants.isoDateFormat
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
                    _journalVoucherData.addAll({'refNo': val});
                  }
                },
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
                    _journalVoucherData.addAll({'description': val});
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

  Widget _journalVoucherHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 2.0,
      ),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(MediaQuery.of(context).size.width - 230),
          1: FlexColumnWidth(100.0),
          2: FlexColumnWidth(100.0),
        },
        children: [
          TableRow(
            children: [
              Text.rich(
                TextSpan(
                  text: 'ACCOUNT',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  'DEBIT',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Text(
                  'CREDIT',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  void _addDebitTextEditingController(Map data) {
    _debitControllerList.add(
      TextEditingController.fromValue(
        TextEditingValue(
          text: data['debit'] == null
              ? ''
              : data['debit'] == 0
                  ? data['debit'].toString().replaceAll('0', '')
                  : double.parse(data['debit'].toString()).toStringAsFixed(2),
          selection: new TextSelection.collapsed(
            offset: data['debit'] == null ? 0 : data['debit'].toString().length,
          ),
        ),
      ),
    );
  }

  void _addCreditTextEditingController(Map data) {
    _creditControllerList.add(
      TextEditingController.fromValue(
        TextEditingValue(
          text: data['credit'] == null
              ? ''
              : data['credit'] == 0
                  ? data['credit'].toString().replaceAll('0', '')
                  : double.parse(data['credit'].toString()).toStringAsFixed(2),
          selection: new TextSelection.collapsed(
            offset:
                data['credit'] == null ? 0 : data['credit'].toString().length,
          ),
        ),
      ),
    );
  }

  Widget _journalVoucherTransactions() {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 0.0,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _journalVoucherTransList.length,
          itemBuilder: (_, idx) {
            _addDebitTextEditingController(_journalVoucherTransList[idx]);
            _addCreditTextEditingController(_journalVoucherTransList[idx]);
            return Column(
              children: [
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(MediaQuery.of(context).size.width - 230),
                    1: FlexColumnWidth(80.0),
                    2: FlexColumnWidth(80.0),
                    3: FlexColumnWidth(30.0),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 0.0,
                          ),
                          child: AutocompleteFormField(
                            initialValue: utils.cast<Map<String, dynamic>>(
                              _journalVoucherTransList[idx]['account'],
                            ),
                            autoFocus: false,
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: _journalVoucherTransList[idx]
                                            ['account'] ==
                                        null
                                    ? ''
                                    : _journalVoucherTransList[idx]['account']
                                        ['name'],
                                selection: new TextSelection.collapsed(
                                  offset: _journalVoucherTransList[idx]
                                              ['account'] ==
                                          null
                                      ? 0
                                      : _journalVoucherTransList[idx]['account']
                                              ['name']
                                          .length,
                                ),
                              ),
                            ),
                            autocompleteCallback: (pattern) {
                              return _accountProvider.accountAutocomplete(
                                searchText: pattern,
                                accountType: [
                                  "CASH",
                                  "BANK_ACCOUNT",
                                  "BANK_OD_ACCOUNT",
                                  "CURRENT_ASSET",
                                  "CURRENT_LIABILITY",
                                  "DIRECT_INCOME",
                                  "DIRECT_EXPENSE",
                                  "INDIRECT_INCOME",
                                  "INDIRECT_EXPENSE",
                                  "FIXED_ASSET",
                                  "LONGTERM_LIABILITY",
                                  "EQUITY",
                                  "UNDEPOSITED_FUNDS",
                                  "EFT_ACCOUNT",
                                  "TRADE_RECEIVABLE",
                                  "TRADE_PAYABLE",
                                  "ACCOUNT_PAYABLE",
                                  "ACCOUNT_RECEIVABLE",
                                ],
                              );
                            },
                            validator: null,
                            labelText: '',
                            outlineInputBorder: false,
                            suggestionFormatter: (suggestion) =>
                                suggestion['name'],
                            textFormatter: (selection) => selection['name'],
                            onSaved: (_) {},
                            onSelected: (value) {
                              Map _selectedAccount = value;
                              _journalVoucherTransData = {};
                              adjustments =
                                  _journalVoucherTransList[idx]['adjs'] == null
                                      ? []
                                      : _journalVoucherTransList[idx]['adjs'];
                              if (_chkAccountType(value)) {
                                Navigator.of(context).pushNamed(
                                  '/accounts/vouchers/vouchers-pendings',
                                  arguments: {
                                    'branch': _selectedBranch,
                                    'account': _selectedAccount,
                                    'voucherMode': _adjustmentForOption ==
                                            AdjustmentForOption.DebitAmount
                                        ? '-1'
                                        : '1',
                                    'adjustments': adjustments,
                                    'voucherId': _journalVoucherId,
                                    'voucherType': 'journal',
                                    'amount': _journalVoucherTransList[idx]
                                                ['credit'] ==
                                            0
                                        ? _journalVoucherTransList[idx]['debit']
                                        : _journalVoucherTransList[idx]
                                            ['credit']
                                  },
                                ).then(
                                  (value) {
                                    if (value != null) {
                                      Map data = value;
                                      adjustments = data['adjustments'];
                                      _adjustmentForOption =
                                          data['adjustmentFor'];
                                      if (_adjustmentForOption ==
                                          AdjustmentForOption.CreditAmount) {
                                        _creditControllerList[idx].text =
                                            data['adjustmentTotal'];
                                        _debitControllerList[idx].text = '';
                                      } else {
                                        _debitControllerList[idx].text =
                                            data['adjustmentTotal'];
                                        _creditControllerList[idx].text = '';
                                      }
                                    }
                                    _journalVoucherTransData.addAll(
                                      {
                                        'id': idx,
                                        'account': _selectedAccount,
                                        'adjs': adjustments,
                                        'debit': _debitControllerList[idx]
                                                .text
                                                .isEmpty
                                            ? 0
                                            : double.parse(
                                                _debitControllerList[idx].text),
                                        'credit': _creditControllerList[idx]
                                                .text
                                                .isEmpty
                                            ? 0
                                            : double.parse(
                                                _creditControllerList[idx]
                                                    .text),
                                      },
                                    );
                                    _journalVoucherTransList.removeAt(idx);
                                    setState(() {
                                      _journalVoucherTransList.insert(
                                        idx,
                                        _journalVoucherTransData,
                                      );
                                    });
                                  },
                                );
                              } else {
                                _journalVoucherTransData.addAll(
                                  {
                                    'id': idx,
                                    'account': _selectedAccount,
                                    'debit':
                                        _debitControllerList[idx].text.isEmpty
                                            ? 0
                                            : double.parse(
                                                _debitControllerList[idx].text),
                                    'credit': _creditControllerList[idx]
                                            .text
                                            .isEmpty
                                        ? 0
                                        : double.parse(
                                            _creditControllerList[idx].text),
                                  },
                                );
                                _journalVoucherTransList.removeAt(idx);
                                setState(() {
                                  _journalVoucherTransList.insert(
                                    idx,
                                    _journalVoucherTransData,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 6.0,
                          ),
                          child: TextFormField(
                            readOnly: _chkAccountType(
                              _journalVoucherTransList[idx]['account'],
                            ),
                            controller: _debitControllerList[idx],
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.subtitle1,
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.end,
                            onChanged: (value) {
                              _journalVoucherTransData = {};
                              _journalVoucherTransData.addAll(
                                {
                                  'id': idx,
                                  'account': _journalVoucherTransList[idx]
                                      ['account'],
                                  'adjs': _journalVoucherTransList[idx]['adjs'],
                                  'debit':
                                      value.isEmpty ? 0 : double.parse(value),
                                  'credit': 0,
                                },
                              );
                              _creditControllerList[idx].text = '';
                              _journalVoucherTransList.removeAt(idx);
                              setState(() {
                                _journalVoucherTransList.insert(
                                  idx,
                                  _journalVoucherTransData,
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 6.0,
                          ),
                          child: TextFormField(
                            readOnly: _chkAccountType(
                              _journalVoucherTransList[idx]['account'],
                            ),
                            controller: _creditControllerList[idx],
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.end,
                            onChanged: (value) {
                              _journalVoucherTransData = {};
                              _journalVoucherTransData.addAll(
                                {
                                  'id': idx,
                                  'account': _journalVoucherTransList[idx]
                                      ['account'],
                                  'adjs': _journalVoucherTransList[idx]['adjs'],
                                  'debit': 0,
                                  'credit':
                                      value.isEmpty ? 0 : double.parse(value),
                                },
                              );
                              _debitControllerList[idx].text = '';
                              _journalVoucherTransList.removeAt(idx);
                              setState(() {
                                _journalVoucherTransList.insert(
                                  idx,
                                  _journalVoucherTransData,
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                            onPressed: () {
                              if (_journalVoucherTransList.length > 2) {
                                setState(() {
                                  _rowCount -= 1;
                                  _journalVoucherTransList.removeAt(idx);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Align(
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
                              _journalVoucherTransData = {};
                              adjustments =
                                  _journalVoucherTransList[idx]['adjs'] == null
                                      ? []
                                      : _journalVoucherTransList[idx]['adjs'];
                              Navigator.of(context).pushNamed(
                                '/accounts/vouchers/vouchers-pendings',
                                arguments: {
                                  'branch': _selectedBranch,
                                  'account': _journalVoucherTransList[idx]
                                      ['account'],
                                  'voucherMode':
                                      _debitControllerList[idx].text.isEmpty
                                          ? '1'
                                          : '-1',
                                  'adjustments': adjustments,
                                  'voucherId': _journalVoucherId,
                                  'voucherType': 'journal',
                                  'amount': _journalVoucherTransList[idx]
                                              ['credit'] ==
                                          0
                                      ? _journalVoucherTransList[idx]['debit']
                                      : _journalVoucherTransList[idx]['credit']
                                },
                              ).then(
                                (value) {
                                  if (value != null) {
                                    Map data = value;
                                    adjustments = data['adjustments'];
                                    _adjustmentForOption =
                                        data['adjustmentFor'];
                                    if (_adjustmentForOption ==
                                        AdjustmentForOption.DebitAmount) {
                                      _creditControllerList[idx].text =
                                          data['adjustmentTotal'];
                                      _debitControllerList[idx].text = '0';
                                    } else {
                                      _debitControllerList[idx].text =
                                          data['adjustmentTotal'];
                                      _creditControllerList[idx].text = '0';
                                    }
                                  }
                                  _journalVoucherTransData.addAll(
                                    {
                                      'id': idx,
                                      'account': _journalVoucherTransList[idx]
                                          ['account'],
                                      'adjs': adjustments,
                                      'debit': _debitControllerList[idx]
                                              .text
                                              .isEmpty
                                          ? 0
                                          : double.parse(
                                              _debitControllerList[idx].text,
                                            ),
                                      'credit': _creditControllerList[idx]
                                              .text
                                              .isEmpty
                                          ? 0
                                          : double.parse(
                                              _creditControllerList[idx].text,
                                            ),
                                    },
                                  );
                                  _journalVoucherTransList.removeAt(idx);
                                  setState(() {
                                    _journalVoucherTransList.insert(
                                      idx,
                                      _journalVoucherTransData,
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  visible: _chkAccountType(
                    _journalVoucherTransList[idx]['account'],
                  ),
                ),
              ],
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.blue,
              size: 28.0,
            ),
            onPressed: () {
              if (_journalVoucherTransList.last['account'] != null) {
                setState(() {
                  _rowCount += 1;
                });
                _debitControllerList = [];
                _creditControllerList = [];
                _adjustmentForOption = AdjustmentForOption.DebitAmount;
                _journalVoucherTransData = {};
                _journalVoucherTransData.addAll({'id': _rowCount});
                _journalVoucherTransList.add(_journalVoucherTransData);
              }
            },
          ),
        ),
      ],
    );
  }

  String _getDebitTotal() {
    double debitTotal = 0;
    _journalVoucherTransList.forEach((element) {
      if (element['debit'] != null) {
        debitTotal += element['debit'];
      }
    });
    return debitTotal.toStringAsFixed(2);
  }

  String _getCreditTotal() {
    double creditTotal = 0;
    _journalVoucherTransList.forEach((element) {
      if (element['credit'] != null) {
        creditTotal += element['credit'];
      }
    });
    return creditTotal.toStringAsFixed(2);
  }

  Widget _journalVoucherFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      height: 45.0,
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(MediaQuery.of(context).size.width - 230),
          1: FlexColumnWidth(100.0),
          2: FlexColumnWidth(100.0),
        },
        children: [
          TableRow(
            children: [
              Text(
                'TOTAL',
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  _getDebitTotal(),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Text(
                  _getCreditTotal(),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _journalVoucherName.isEmpty ? 'Add Journal' : _journalVoucherName,
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
            Visibility(
              child: PopupMenuButton<String>(
                onSelected: (value) => Navigator.of(context).pushNamed(
                  '/accounts/manage/account/form',
                  arguments: {
                    'routeForm': 'JournalToAccount',
                    'id': _journalVoucherId,
                    'displayName': _journalVoucherName,
                    'detail': _journalVoucherData,
                    'formInputName': '',
                  },
                ),
                itemBuilder: (BuildContext context) {
                  return ['Add Account'].map(
                    (menu) {
                      return PopupMenuItem<String>(
                        value: menu,
                        child: Text(
                          menu,
                        ),
                      );
                    },
                  ).toList();
                },
              ),
              visible: utils.checkMenuWiseAccess(
                context,
                [
                  'ac.ac.cr',
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _journalVoucherFooter(context),
        body: Builder(
          builder: (context) {
            _screenContext = context;
            return SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _journalVoucherInfo(),
                      SizedBox(
                        height: 5.0,
                      ),
                      _journalVoucherHeader(context),
                      _journalVoucherTransactions(),
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
