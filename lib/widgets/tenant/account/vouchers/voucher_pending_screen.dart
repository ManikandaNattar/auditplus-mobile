import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils.dart' as utils;

enum AdjustmentForOption {
  DebitAmount,
  CreditAmount,
}

class VoucherPendingScreen extends StatefulWidget {
  @override
  _VoucherPendingScreenState createState() => _VoucherPendingScreenState();
}

class _VoucherPendingScreenState extends State<VoucherPendingScreen> {
  BuildContext _screenContext;
  VoucherProvider _voucherProvider;
  TextEditingController _newRefTextEditingController = TextEditingController();
  TextEditingController _searchQueryTextEditingController =
      TextEditingController();
  AdjustmentForOption _adjustmentOption = AdjustmentForOption.DebitAmount;
  List<TextEditingController> _amountTextEditingController = [];
  List _voucherPendingList = [];
  List adjustmentList = [];
  List adjs = [];
  List _voucherTransactions = [];
  List _voucherPendingsLiveData = [];
  List _responseData = [];
  Map arguments = {};
  Map adjustmentData = {};
  Map _toAccount = {};
  Map<String, dynamic> _voucherData = Map();
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getVoucherPendingList();
    _chkAdjustmentForOption();
    _getNewRefValue();
    super.didChangeDependencies();
  }

  void _chkAdjustmentForOption() {
    _adjustmentOption = arguments['voucherType'] == 'payment'
        ? AdjustmentForOption.DebitAmount
        : arguments['voucherType'] == 'receipt'
            ? AdjustmentForOption.CreditAmount
            : arguments['voucherMode'] == '-1'
                ? AdjustmentForOption.DebitAmount
                : AdjustmentForOption.CreditAmount;
  }

  void _getNewRefValue() {
    _newRefTextEditingController.text = double.parse((arguments['amount'] ==
                    null
                ? 0
                : arguments['amount'] - double.parse(_getAdjustmentsTotal()))
            .toString())
        .toStringAsFixed(2);
  }

  Future<void> _getVoucherPendingList() async {
    try {
      adjustmentList = arguments['adjustments'];
      List adjustmentIds = [];
      if (adjustmentList.isNotEmpty) {
        adjustmentList.forEach((element) {
          adjustmentIds.add(element['pending']);
        });
      }
      if (arguments['voucherId'] == '') {
        adjs = [];
      } else {
        _voucherData =
            await _voucherProvider.getVoucher(arguments['voucherId']);
        _voucherTransactions = _voucherData['trns'];
        if (arguments['voucherType'] == 'journal') {
          _toAccount = _voucherTransactions
              .where((element) =>
                  element['account']['id'] == arguments['account']['id'])
              .single;
        } else {
          if (arguments['voucherMode'] == '1') {
            _toAccount = _voucherTransactions
                    .where((element) => element['debit'] == 0)
                    .isEmpty
                ? null
                : _voucherTransactions
                    .where((element) => element['debit'] == 0)
                    .first;
          } else {
            _toAccount = _voucherTransactions
                    .where((element) => element['credit'] == 0)
                    .isEmpty
                ? null
                : _voucherTransactions
                    .where((element) => element['credit'] == 0)
                    .first;
          }
        }
        adjs = _toAccount['adjs'] == null ? [] : _toAccount['adjs'];
      }
      if (!_isSearching) {
        _responseData = await _voucherProvider.getVoucherPendings(
          arguments['branch']['id'],
          arguments['account']['id'],
          arguments['voucherMode'],
          adjustmentIds,
        );
        _voucherPendingsLiveData = _responseData;
      }
      setState(() {
        addVoucherPendings(_responseData);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      return [];
    }
  }

  void addVoucherPendings(List data) {
    _voucherPendingList.addAll(
      data.map(
        (elm) {
          return {
            'pending': elm['pending'],
            'date': elm['date'],
            'voucherType': elm['voucherName'] == null ? '' : elm['voucherName'],
            'refNo': elm['refNo'].toString().replaceAll('null', ''),
            'opening': elm['opening'] == null ? 0 : elm['opening'],
            'days': elm['days'],
            'closing': adjs.isEmpty
                ? elm['closing']
                : adjs
                        .where(
                            (element) => element['pending'] == elm['pending'])
                        .isEmpty
                    ? elm['closing']
                    : elm['closing'].abs() +
                        adjs
                            .where((element) =>
                                element['pending'] == elm['pending'])
                            .first['amount']
                            .abs()
          };
        },
      ).toList(),
    );
  }

  void _addAmountTextEditingController(Map data) {
    _amountTextEditingController.add(
      TextEditingController.fromValue(
        TextEditingValue(
          text: adjustmentList.isEmpty
              ? '0.00'
              : adjustmentList
                      .where((element) => element['pending'] == data['pending'])
                      .isEmpty
                  ? '0.00'
                  : double.parse(adjustmentList
                          .where((element) =>
                              element['pending'] == data['pending'])
                          .first['amount']
                          .toString())
                      .abs()
                      .toStringAsFixed(2),
        ),
      ),
    );
  }

  Widget _showVoucherPendings() {
    return Expanded(
      child: Container(
        child: _voucherPendingList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                itemCount: _voucherPendingList.length,
                itemBuilder: (_, idx) {
                  _addAmountTextEditingController(_voucherPendingList[idx]);
                  return Container(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _voucherPendingList[idx]['date'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Visibility(
                                      child: Text(
                                        _voucherPendingList[idx]['refNo'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                              fontSize: 12.0,
                                            ),
                                      ),
                                      visible: _voucherPendingList[idx]['refNo']
                                          .toString()
                                          .replaceAll('null', '')
                                          .isNotEmpty,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Due days : ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                        Text(
                                          _voucherPendingList[idx]['days']
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                letterSpacing: 0.5,
                                                fontSize: 12.0,
                                              ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      arguments['voucherMode'] == '-1'
                                          ? double.parse(
                                                      _voucherPendingList[idx]
                                                              ['closing']
                                                          .abs()
                                                          .toString())
                                                  .toStringAsFixed(2) +
                                              ' Cr'
                                          : double.parse(
                                                      _voucherPendingList[idx]
                                                              ['closing']
                                                          .toString())
                                                  .toStringAsFixed(2) +
                                              ' Dr',
                                      style: arguments['voucherMode'] == '-1'
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                color: Colors.red,
                                                letterSpacing: 0.5,
                                                fontSize: 13.0,
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                color: Colors.green,
                                                letterSpacing: 0.5,
                                                fontSize: 13.0,
                                              ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      arguments['voucherMode'] == '-1'
                                          ? '(' +
                                              double.parse(
                                                      _voucherPendingList[idx]
                                                              ['opening']
                                                          .abs()
                                                          .toString())
                                                  .toStringAsFixed(2) +
                                              ' Cr)'
                                          : '(' +
                                              double.parse(
                                                      _voucherPendingList[idx]
                                                              ['opening']
                                                          .toString())
                                                  .toStringAsFixed(2) +
                                              ' Dr)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 40,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: _amountTextEditingController[idx],
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  style: Theme.of(context).textTheme.subtitle1,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      adjustmentData = {
                                        'pending': _voucherPendingList[idx]
                                            ['pending'],
                                        'amount': double.parse(
                                          arguments['voucherMode'] == '1'
                                              ? '-' + value
                                              : value,
                                        ),
                                      };
                                      if (adjustmentData['pending'] ==
                                          _voucherPendingList[idx]['pending']) {
                                        adjustmentData['amount'] = double.parse(
                                          arguments['voucherMode'] == '1'
                                              ? '-' + value
                                              : value,
                                        );
                                        adjustmentList.removeWhere((element) =>
                                            element['pending'] ==
                                            adjustmentData['pending']);
                                        setState(() {
                                          adjustmentList.add(adjustmentData);
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        adjustmentList.removeWhere((element) =>
                                            element['pending'] ==
                                            _voucherPendingList[idx]
                                                ['pending']);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ])
                          ],
                        ),
                        Divider(
                          thickness: 0.75,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _showVoucherPendingDetailHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Table(
        children: [
          TableRow(children: [
            Text(
              'PARTICULARS',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'BALANCE',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          letterSpacing: 0.5,
                        ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '(BILL.AMT)',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              'ADJUSTMENT',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    letterSpacing: 0.5,
                  ),
              textAlign: TextAlign.right,
            ),
          ])
        ],
      ),
    );
  }

  String _getAdjustmentsTotal() {
    double adjustment = 0;
    adjustment = adjustmentList.isEmpty
        ? 0
        : adjustmentList
            .map((e) => double.parse(e['amount'].toString()).abs())
            .reduce((value, element) => value + element);
    return adjustment.abs().toStringAsFixed(2);
  }

  Widget _showVoucherPendingFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      padding: EdgeInsets.all(8.0),
      height: 45.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TOTAL',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Text(
            _getAdjustmentsTotal(),
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _showAdjustmentDropdown() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Adjustment for',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          arguments['voucherType'] == 'payment' ||
                  arguments['voucherType'] == 'receipt'
              ? Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    _adjustmentOption.toString().split('.').last,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : SizedBox(
                  width: 130.0,
                  child: DropdownButton<AdjustmentForOption>(
                    isExpanded: true,
                    value: _adjustmentOption,
                    onChanged: (AdjustmentForOption newValue) {
                      if (arguments['voucherType'] == 'journal') {
                        setState(() {
                          _adjustmentOption = newValue;
                          if (newValue == AdjustmentForOption.CreditAmount) {
                            arguments['voucherMode'] = '1';
                          } else {
                            arguments['voucherMode'] = '-1';
                          }
                          _isLoading = true;
                          _voucherPendingList = [];
                        });
                        _getVoucherPendingList();
                      }
                    },
                    items: AdjustmentForOption.values.map(
                      (AdjustmentForOption viewReport) {
                        return DropdownMenuItem<AdjustmentForOption>(
                          value: viewReport,
                          child: Text(
                            viewReport.toString().split('.').last,
                            style: TextStyle(
                              color: viewReport == _adjustmentOption
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _newRefForm() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'New Ref',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            width: 130.0,
            height: 40.0,
            child: TextFormField(
              controller: _newRefTextEditingController,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.subtitle1,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.end,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  arguments['amount'] = double.parse(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _voucherPendingSearchWidget() {
    return Container(
      child: TextFormField(
        controller: _searchQueryTextEditingController,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.subtitle1,
        decoration: InputDecoration(
          hintText: 'Voucher no...',
          prefixIcon: Icon(
            Icons.search_rounded,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () {
              if (_searchQueryTextEditingController.text.isNotEmpty) {
                _searchQueryTextEditingController.text = '';
                setState(() {
                  _amountTextEditingController = [];
                  _voucherPendingList = [];
                  _isLoading = true;
                  _isSearching = false;
                });
                _getVoucherPendingList();
              }
            },
          ),
        ),
        onFieldSubmitted: (val) {
          _getFilterData(val);
        },
      ),
    );
  }

  _getFilterData(String searchQuery) {
    _responseData = _voucherPendingsLiveData
        .where((element) => element['refNo'].toString().contains(searchQuery))
        .toList();
    setState(() {
      _amountTextEditingController = [];
      _isLoading = true;
      _isSearching = true;
      _voucherPendingList = [];
    });
    _getVoucherPendingList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pending Detail',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  {
                    'adjustments': adjustmentList,
                    'adjustmentTotal': double.parse(
                            (double.parse(_newRefTextEditingController.text) +
                                    double.parse(_getAdjustmentsTotal()))
                                .toString())
                        .toStringAsFixed(2),
                    'adjustmentFor': _adjustmentOption,
                  },
                );
              },
              child: Text(
                'SUBMIT',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            _screenContext = context;
            return _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _voucherPendingSearchWidget(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                          8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              arguments['account']['name'].toUpperCase(),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Text(
                              arguments['branch']['name'].toUpperCase(),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _showAdjustmentDropdown(),
                            _newRefForm(),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                      _showVoucherPendingDetailHeader(),
                      Divider(
                        thickness: 1.0,
                      ),
                      _showVoucherPendings(),
                      _showVoucherPendingFooter(),
                    ],
                  );
          },
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
    );
  }
}
