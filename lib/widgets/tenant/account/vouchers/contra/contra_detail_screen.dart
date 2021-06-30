import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/cash_register_selection.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class ContraDetailScreen extends StatefulWidget {
  @override
  _ContraDetailScreenState createState() => _ContraDetailScreenState();
}

class _ContraDetailScreenState extends State<ContraDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _contraData = Map();
  List _contraVoucherTransactions = [];
  Map _bankAccount = {};
  Map _cashAccount = {};
  VoucherProvider _voucherProvider;
  TenantAuth _tenantAuth;
  String contraVoucherId;
  String contraVoucherName;
  String cashRegisterId = '';
  Map arguments = {};
  List _assignedCashRegisterList = [];

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _assignedCashRegisterList = _tenantAuth.assignedCashRegisters;
    arguments = ModalRoute.of(context).settings.arguments;
    contraVoucherId = arguments['detail']['id'];
    contraVoucherName = arguments['detail']['voucherNo'];
    super.didChangeDependencies();
  }

  Future<void> _getContraVoucher() async {
    try {
      _contraData = await _voucherProvider.getVoucher(contraVoucherId);
      _contraVoucherTransactions = _contraData['trns'];
      _bankAccount = _contraVoucherTransactions
          .where((element) => element['account']['accountType'] != 'CASH')
          .first;
      _cashAccount = _contraVoucherTransactions
          .where((element) => element['account']['accountType'] == 'CASH')
          .first;
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'CONTRA INFO': {
          'Date': constants.defaultDate.format(
            DateTime.parse(
              _contraData['date'],
            ),
          ),
          'Bank': _bankAccount == null ? null : _bankAccount['account']['name'],
          'Cash Account':
              _cashAccount == null ? null : _cashAccount['account']['name'],
          'Reference No': _contraData['refNo'],
          'Instrument Date': _cashAccount == null
              ? null
              : _cashAccount.containsKey('instDate') == false
                  ? null
                  : constants.defaultDate.format(
                      DateTime.parse(
                        _cashAccount['instDate'],
                      ),
                    ),
          'Instrument No': _cashAccount == null
              ? null
              : _cashAccount.containsKey('instNo') == false
                  ? null
                  : _cashAccount['instNo'],
          'Description': _contraData['description'],
        },
      },
    );
  }

  Future<void> _deleteContraVoucher() async {
    try {
      await _voucherProvider.deleteVoucher(
        contraVoucherId,
        cashRegisterId,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Contra Voucher Deleted Successfully');
      Navigator.of(_screenContext).pushReplacementNamed(
        '/accounts/vouchers/contra',
        arguments: arguments['filterData'],
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _contraVoucherFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      height: 45.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'AMOUNT',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Text(
            double.parse(
              _contraData['amount'].toString(),
            ).toStringAsFixed(2),
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
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
          contraVoucherName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/vouchers/contra/form',
                arguments: {
                  'id': contraVoucherId,
                  'displayName': contraVoucherName,
                  'detail': _contraData,
                  'formName': _contraVoucherTransactions
                              .where((element) =>
                                  element['account']['accountType'] == 'CASH')
                              .first['debit'] ==
                          0
                      ? 'CD'
                      : 'CW',
                  'filterData': arguments['filterData'],
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.ctra.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (_contraData['cashRegisterEnabled']) {
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
                                _deleteContraVoucher,
                                'Delete Contra Voucher?',
                                'Are you sure want to delete',
                              );
                            }
                          },
                        );
                } else {
                  utils.showAlertDialog(
                    _screenContext,
                    _deleteContraVoucher,
                    'Delete Contra Voucher?',
                    'Are you sure want to delete',
                  );
                }
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.ctra.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getContraVoucher(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: DetailCard(
                          _buildDetailPage(),
                        ),
                      ),
                      _contraVoucherFooter(),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
