import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class AccountTypeOpeningScreen extends StatefulWidget {
  @override
  _AccountTypeOpeningScreenState createState() =>
      _AccountTypeOpeningScreenState();
}

class _AccountTypeOpeningScreenState extends State<AccountTypeOpeningScreen> {
  BuildContext _screenContext;
  AccountProvider _accountProvider;
  TenantAuth _tenantAuth;
  String accountId = '';
  String accountName = '';
  String branchId = '';
  String branchName = '';
  bool _isLoading = true;
  List _accountOpeningList = [];
  Map arguments = {};
  Map selectedBranch = {};

  @override
  void didChangeDependencies() {
    _accountProvider = Provider.of<AccountProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    accountId = arguments['id'];
    accountName = arguments['displayName'];
    _getAccountOpening();
    super.didChangeDependencies();
  }

  Future<void> _getAccountOpening() async {
    selectedBranch = _tenantAuth.selectedBranch;
    branchId = selectedBranch['id'];
    branchName = selectedBranch['name'];
    Map data = await _accountProvider.getAccountOpening(branchId, accountId);
    setState(() {
      _isLoading = false;
      _addAccountOpening(data['items']);
    });
  }

  void _addAccountOpening(List response) {
    _accountOpeningList.addAll(
      response.map(
        (e) {
          return {
            'isExpanded': false,
            'id': response.indexOf(e),
            'effDate': e['effDate'],
            'credit': double.parse('${e['credit']}'),
            'debit': double.parse('${e['debit']}'),
            'refNo': e['refNo'],
          };
        },
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (branchName != 'Select Branch') {
      try {
        List invoices = [];
        invoices.addAll(_accountOpeningList.map(
          (e) {
            return {
              'id': e['id'],
              'effDate': e['effDate'],
              'credit': double.parse('${e['credit']}'),
              'debit': double.parse('${e['debit']}'),
              'refNo': e['refNo'],
            };
          },
        ).toList());
        await _accountProvider.setAccountOpening(
          branchId,
          accountId,
          invoices,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Account Opening added Successfully');
        Navigator.of(context).pop(
          arguments,
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    } else {
      utils.handleErrorResponse(
        _screenContext,
        'Branch sholud not be empty!',
        'tenant',
      );
    }
  }

  Widget _accountOpeningFormContainer() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 4.0,
              ),
              child: Text(
                accountName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Visibility(
                    child: _accountOpeningListContainer(),
                    visible: _accountOpeningList.isNotEmpty,
                  ),
            SizedBox(
              height: 60.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _accountOpeningListContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'INV.DATE',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 60.0,
                  ),
                  child: Text(
                    'REF.NO',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 60.0,
                  ),
                  child: Text(
                    'AMOUNT',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ExpansionPanelList(
            elevation: 1,
            expandedHeaderPadding: EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 0.0,
            ),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _accountOpeningList[panelIndex]['isExpanded'] = !isExpanded;
              });
            },
            children: [
              ..._accountOpeningList.map(
                (e) {
                  return ExpansionPanel(
                    headerBuilder: (_, bool isExpanded) {
                      return ListTile(
                        title: Table(
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  constants.defaultDate.format(
                                    DateTime.parse(
                                      e['effDate'],
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.subtitle1,
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    e['refNo'] == null ? '' : e['refNo'],
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Text(
                                  e['credit'] == 0.0 || e['credit'] == '0.0'
                                      ? '${double.parse(e['debit'].toString()).toStringAsFixed(2).toString()} Dr'
                                      : '${double.parse(e['credit'].toString()).toStringAsFixed(2).toString()} Cr',
                                  style: Theme.of(context).textTheme.subtitle1,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              e['isExpanded'] = false;
                            });
                            Navigator.of(context).pushNamed(
                              '/accounts/manage/account-type/opening/form',
                              arguments: {
                                'formData': {
                                  'id': e['id'],
                                  'refNo': e['refNo'],
                                  'effDate': e['effDate'],
                                  'credit': e['credit'],
                                  'debit': e['debit'],
                                  'openingBranch': branchName,
                                  'openingAccount': accountName,
                                  'isExpanded': e['isExpanded'],
                                },
                              },
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _accountOpeningList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _accountOpeningList.addAll({value});
                                  });
                                }
                              },
                            );
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _accountOpeningList.removeWhere(
                                  (element) => element['id'] == e['id']);
                            });
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    isExpanded: e['isExpanded'],
                  );
                },
              ).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addAccountOpeningButtonWidget() {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        label: Text(
          'Add Account Opening',
          style: Theme.of(context).textTheme.button,
        ),
        icon: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: () => Navigator.of(context).pushNamed(
          '/accounts/manage/account-type/opening/form',
          arguments: {
            'formData': {
              'id': _accountOpeningList.isEmpty
                  ? 0
                  : _accountOpeningList.lastIndexOf(_accountOpeningList.last) +
                      1,
              'isExpanded': false,
              'refNo': '',
              'effDate': '',
              'credit': '0.0',
              'debit': '0.0',
              'openingBranch': branchName,
              'openingAccount': accountName,
            },
          },
        ).then(
          (value) {
            if (value != null) {
              Map data = value;
              setState(() {
                _accountOpeningList.removeWhere(
                    (element) => element['id'] == data['id'].toString());
                _accountOpeningList.addAll({value});
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Opening',
            ),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    selectedBranch = value['branchInfo'];
                    branchId = selectedBranch['id'];
                    branchName = selectedBranch['name'];
                    _isLoading = true;
                    _accountOpeningList.clear();
                  });
                  _getAccountOpening();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _onSubmit(),
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
        builder: (BuildContext context) {
          _screenContext = context;
          return _accountOpeningFormContainer();
        },
      ),
      floatingActionButton: _addAccountOpeningButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
