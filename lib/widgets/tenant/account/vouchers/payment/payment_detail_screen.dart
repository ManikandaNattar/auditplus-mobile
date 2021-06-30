import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/cash_register_selection.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/voucher_adjustments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class PaymentDetailScreen extends StatefulWidget {
  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen>
    with SingleTickerProviderStateMixin {
  BuildContext _screenContext;
  Map<String, dynamic> _paymentData = Map();
  List _paymentVoucherTransactions = [];
  Map _toAccount = {};
  Map _byAccount = {};
  VoucherProvider _voucherProvider;
  TenantAuth _tenantAuth;
  String paymentVoucherId;
  String paymentVoucherName;
  TabController _tabController;
  String cashRegisterId = '';
  Map arguments = {};
  List _assignedCashRegisterList = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _assignedCashRegisterList = _tenantAuth.assignedCashRegisters;
    arguments = ModalRoute.of(context).settings.arguments;
    paymentVoucherId = arguments['detail']['id'];
    paymentVoucherName = arguments['detail']['voucherNo'];
    super.didChangeDependencies();
  }

  Future<void> _getPaymentVoucher() async {
    try {
      _paymentData = await _voucherProvider.getVoucher(paymentVoucherId);
      _paymentVoucherTransactions = _paymentData['trns'];
      _toAccount = _paymentVoucherTransactions
              .where((element) => element['credit'] == 0)
              .isEmpty
          ? null
          : _paymentVoucherTransactions
              .where((element) => element['credit'] == 0)
              .first;
      _byAccount = _paymentVoucherTransactions
              .where((element) => element['debit'] == 0)
              .isEmpty
          ? null
          : _paymentVoucherTransactions
              .where((element) => element['debit'] == 0)
              .first;
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'ACCOUNT PAYMENT INFO': {
          'Date': constants.defaultDate.format(
            DateTime.parse(
              _paymentData['date'],
            ),
          ),
          'Payment Account':
              _toAccount == null ? null : _toAccount['account']['name'],
          'Paid via': _byAccount == null ? null : _byAccount['account']['name'],
          'Reference No': _paymentData['refNo'],
          'Instrument Date': _byAccount == null
              ? null
              : _byAccount.containsKey('instDate') == false
                  ? null
                  : constants.defaultDate.format(
                      DateTime.parse(
                        _byAccount['instDate'],
                      ),
                    ),
          'Instrument No': _byAccount == null
              ? null
              : _byAccount.containsKey('instNo') == false
                  ? null
                  : _byAccount['instNo'],
          'Description': _paymentData['description'],
        },
      },
    );
  }

  Future<void> _deletePaymentVoucher() async {
    try {
      await _voucherProvider.deleteVoucher(
        paymentVoucherId,
        cashRegisterId,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Payment Voucher Deleted Successfully');
      Navigator.of(_screenContext).pushReplacementNamed(
        '/accounts/vouchers/payment',
        arguments: arguments['filterData'],
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  String _getTotalBalance() {
    List adjustmentList = _toAccount['adjustments'];
    List adjsList = _toAccount['adjs'];
    double balance = 0;
    var totalAdjsAmount = adjsList == null
        ? 0.00
        : adjsList
            .map((e) => double.parse(e['amount'].abs().toString()))
            .reduce((value, element) => value + element);
    var totalAdjustmentsAmount = adjustmentList == null
        ? 0.00
        : adjustmentList
            .map((e) => double.parse(e['amount'].abs().toString()))
            .reduce((value, element) => value + element);
    balance = _toAccount['debit'] - (totalAdjsAmount + totalAdjustmentsAmount);
    return balance.abs().toStringAsFixed(2);
  }

  Widget _paymentVoucherFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Amount',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(
                    _toAccount['debit'].toString(),
                  ).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Balance',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  _getTotalBalance(),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          paymentVoucherName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/vouchers/payment/form',
                arguments: {
                  'id': paymentVoucherId,
                  'displayName': paymentVoucherName,
                  'detail': _paymentData,
                  'filterData': arguments['filterData'],
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.pmt.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (_paymentData['cashRegisterEnabled']) {
                  _assignedCashRegisterList.length == 1
                      ? cashRegisterId = _assignedCashRegisterList.single['id']
                      : cashRegisterSelectionBottomSheet(
                          context: _screenContext,
                        ).then(
                          (value) {
                            if (value != null) {
                              cashRegisterId = value['id'];
                              utils.showAlertDialog(
                                _screenContext,
                                _deletePaymentVoucher,
                                'Delete Payment Voucher?',
                                'Are you sure want to delete',
                              );
                            }
                          },
                        );
                } else {
                  utils.showAlertDialog(
                    _screenContext,
                    _deletePaymentVoucher,
                    'Delete Payment Voucher?',
                    'Are you sure want to delete',
                  );
                }
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.pmt.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getPaymentVoucher(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    children: [
                      TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(
                            text: 'Account Payment',
                          ),
                          Tab(
                            text: 'Adjustments',
                          )
                        ],
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            DetailCard(
                              _buildDetailPage(),
                            ),
                            VoucherAdjustments(
                              list: _toAccount['adjustments'] == null
                                  ? []
                                  : _toAccount['adjustments'],
                              isLoading: snapShot.connectionState ==
                                  ConnectionState.waiting,
                            ),
                          ],
                          controller: _tabController,
                        ),
                      ),
                      _paymentVoucherFooter(),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
