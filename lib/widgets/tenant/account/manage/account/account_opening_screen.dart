import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountOpeningScreen extends StatefulWidget {
  @override
  _AccountOpeningScreenState createState() => _AccountOpeningScreenState();
}

class _AccountOpeningScreenState extends State<AccountOpeningScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  BuildContext _screenContext;
  AccountProvider _accountProvider;
  TenantAuth _tenantAuth;
  TextEditingController _creditTextEditingController = TextEditingController();
  TextEditingController _debitTextEditingController = TextEditingController();
  FocusNode _creditFocusNode = FocusNode();
  FocusNode _debitFocusNode = FocusNode();
  String accountId = '';
  String accountName = '';
  String branchId = '';
  String branchName = '';
  bool _isLoading = true;
  Map<String, dynamic> _accountOpeningList = {};
  Map<String, dynamic> _accountOpeningData = {};
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

  @override
  void dispose() {
    _creditFocusNode.dispose();
    _debitFocusNode.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getAccountOpening() async {
    selectedBranch = _tenantAuth.selectedBranch;
    branchId = selectedBranch['id'];
    branchName = selectedBranch['name'];
    final data = await _accountProvider.getAccountOpening(branchId, accountId);
    setState(() {
      _isLoading = false;
      _accountOpeningList.addAll(data);
    });
    _creditTextEditingController.text = double.parse(
            _accountOpeningList['credit'].toString().replaceAll('null', '0'))
        .toStringAsFixed(2);
    _creditTextEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _creditTextEditingController.text.length,
      ),
    );
    _debitTextEditingController.text = double.parse(
            _accountOpeningList['debit'].toString().replaceAll('null', '0'))
        .toStringAsFixed(2);
    _debitTextEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _debitTextEditingController.text.length,
      ),
    );
    return _accountOpeningList;
  }

  Future<void> _onSubmit() async {
    if (branchName != 'Select Branch' && _formKey.currentState.validate()) {
      try {
        _formKey.currentState.save();
        await _accountProvider.setAccountOpening(
          branchId,
          accountId,
          _accountOpeningData,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Account Opening added Successfully');
        Future.delayed(Duration(seconds: 1)).then(
          (value) => Navigator.of(context).pop(
            arguments,
          ),
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    } else {
      utils.handleErrorResponse(
          _screenContext, 'Branch should not be empty!', 'tenant');
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
                horizontal: 28.0,
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
                : _accountopeningFormGeneralInfoContainer(),
          ],
        ),
      ),
    );
  }

  Widget _accountopeningFormGeneralInfoContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 0.0,
            ),
            width: double.infinity,
            child: Card(
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: Text(
                      'GENERAL INFO',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              textAlign: TextAlign.end,
                              controller: _creditTextEditingController,
                              focusNode: _creditFocusNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: -5,
                                  horizontal: 10,
                                ),
                                labelText: 'Credit',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _creditFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_debitFocusNode);
                              },
                              onSaved: (val) {
                                if (val.isNotEmpty) {
                                  _accountOpeningData['credit'] =
                                      double.parse(val);
                                }
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _debitTextEditingController.text = '0';
                                }
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Credit should not be empty!';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              controller: _debitTextEditingController,
                              focusNode: _debitFocusNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: -5,
                                  horizontal: 10,
                                ),
                                labelText: 'Debit',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              onSaved: (val) {
                                _accountOpeningData['debit'] =
                                    double.parse(val);
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _creditTextEditingController.text = '0';
                                }
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debit should not be empty!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
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
    );
  }
}
