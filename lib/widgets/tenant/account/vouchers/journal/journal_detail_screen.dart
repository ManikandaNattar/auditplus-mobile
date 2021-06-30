import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/widgets/tenant/account/vouchers/journal/journal_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class JournalDetailScreen extends StatefulWidget {
  @override
  _JournalDetailScreenState createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _journalData = Map();
  VoucherProvider _voucherProvider;
  String journalVoucherId;
  String journalVoucherName;
  Map arguments = {};

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    journalVoucherId = arguments['detail']['id'];
    journalVoucherName = arguments['detail']['voucherNo'];
    super.didChangeDependencies();
  }

  Future<void> _getJournalVoucher() async {
    try {
      _journalData = await _voucherProvider.getVoucher(journalVoucherId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Future<void> _deleteJournalVoucher() async {
    try {
      await _voucherProvider.deleteVoucher(journalVoucherId, '');
      utils.showSuccessSnackbar(
          _screenContext, 'Journal Voucher Deleted Successfully');
      Navigator.of(_screenContext).pushReplacementNamed(
        '/accounts/vouchers/journal',
        arguments: arguments['filterData'],
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          journalVoucherName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/vouchers/journal/form',
                arguments: {
                  'id': journalVoucherId,
                  'displayName': journalVoucherName,
                  'detail': _journalData,
                  'filterData': arguments['filterData'],
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.jo.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteJournalVoucher,
                  'Delete Journal Voucher?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.jo.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getJournalVoucher(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : JournalDetail(
                  journalData: _journalData,
                  isLoading:
                      snapShot.connectionState == ConnectionState.waiting,
                  totalAmount: _journalData['amount'].toString(),
                );
        },
      ),
    );
  }
}
