import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CashRegisterDetailScreen extends StatefulWidget {
  @override
  _CashRegisterDetailScreenState createState() =>
      _CashRegisterDetailScreenState();
}

class _CashRegisterDetailScreenState extends State<CashRegisterDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _cashRegisterData = Map();
  CashRegisterProvider _cashRegisterProvider;
  String cashRegisterId;
  String cashRegisterName;
  @override
  void didChangeDependencies() {
    _cashRegisterProvider = Provider.of<CashRegisterProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    cashRegisterId = arguments['id'];
    cashRegisterName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getCashRegister() async {
    try {
      _cashRegisterData =
          await _cashRegisterProvider.getCashRegister(cashRegisterId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _cashRegisterData['name'],
          'AliasName': _cashRegisterData['aliasName'],
          'Branch': _cashRegisterData['branch']['name'],
          'Opening':
              _cashRegisterData['opening'].toString().replaceAll('null', '0') +
                  '.00',
        },
      },
    );
  }

  Future<void> _deleteCashRegister() async {
    try {
      await _cashRegisterProvider.deleteCashRegister(cashRegisterId);
      utils.showSuccessSnackbar(
          _screenContext, 'Cash Register Deleted Successfully');
      Navigator.of(_screenContext)
          .pushReplacementNamed('/administration/manage/cash-register');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cashRegisterName,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              '/administration/manage/cash-register/form',
              arguments: {
                'id': cashRegisterId,
                'displayName': cashRegisterName,
                'detail': _cashRegisterData,
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              utils.showAlertDialog(
                _screenContext,
                _deleteCashRegister,
                'Delete Cash Register?',
                'Are you sure want to delete',
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCashRegister(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: DetailCard(
                      _buildDetailPage(),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
