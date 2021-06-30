import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountDetailScreen extends StatefulWidget {
  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _accountData = Map();
  AccountProvider _accountProvider;
  String accountId;
  String accountName;
  List _menuList = [];

  @override
  void initState() {
    _checkVisibility();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    accountId = arguments['id'];
    accountName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getAccount() async {
    try {
      _accountData = await _accountProvider.getAccount(accountId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _accountData['name'],
          'AliasName': _accountData['aliasName'],
          'Account Type': _accountData['accountType']['name'],
          'Parent Account': _accountData['parentAccount'] == null &&
                  _accountData['parentAccount'] == {}
              ? ''
              : _accountData['parentAccount']['name'],
          'Description': _accountData['description'] == null
              ? ''
              : _accountData['description']
        },
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await _accountProvider.deleteAccount(accountId);
      utils.showSuccessSnackbar(_screenContext, 'Account Deleted Successfully');
      Navigator.of(_screenContext)
          .pushReplacementNamed('/accounts/manage/account');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(context, ['ac.ac.op'])) {
      _menuList.add('Account Opening');
    }
    if (utils.checkMenuWiseAccess(context, ['ac.ac.dl'])) {
      _menuList.add('Delete Account');
    }
  }

  void _menuAction(String menu) {
    if (menu == 'Account Opening') {
      Navigator.of(context).pushNamed(
        _accountData['accountType']['defaultName'] == 'TRADE_PAYABLE' ||
                _accountData['accountType']['defaultName'] == 'TRADE_RECEIVABLE'
            ? '/accounts/manage/account-type/opening'
            : '/accounts/manage/account/opening',
        arguments: {
          'id': accountId,
          'displayName': accountName,
          'detail': _accountData,
        },
      );
    } else if (menu == 'Delete Account') {
      utils.showAlertDialog(
        _screenContext,
        _deleteAccount,
        'Delete Account?',
        'Are you sure want to delete',
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          accountName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/manage/account/form',
                arguments: {
                  'id': accountId,
                  'displayName': accountName,
                  'detail': _accountData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.ac.up',
              ],
            ),
          ),
          Visibility(
            child: PopupMenuButton<String>(
              onSelected: (value) => _menuAction(value),
              itemBuilder: (BuildContext context) {
                return _menuList.map(
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
                'ac.ac.op',
                'ac.ac.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getAccount(),
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
