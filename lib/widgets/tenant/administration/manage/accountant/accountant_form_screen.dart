import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class AccountantFormScreen extends StatefulWidget {
  @override
  _AccountantFormScreenState createState() => _AccountantFormScreenState();
}

class _AccountantFormScreenState extends State<AccountantFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  UserProvider _userProvider;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _acountantCodeFocusNode = FocusNode();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _accountantCodeTextEditingController =
      TextEditingController();
  Map<String, dynamic> _acountantData = {};
  @override
  void dispose() {
    _emailFocusNode.dispose();
    _acountantCodeFocusNode.dispose();
    _emailTextEditingController.dispose();
    _accountantCodeTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await _userProvider.addAccountant(_acountantData);
        utils.showSuccessSnackbar(
            _screenContext, 'Accountant added Successfully');
        Navigator.of(_screenContext)
            .pushReplacementNamed('/administration/manage/accountant');
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _accountantFormGeneralInfoContainer() {
    return Container(
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailTextEditingController,
                    focusNode: _emailFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Accountant Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _emailFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_acountantCodeFocusNode);
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _acountantData
                            .addAll({'email': val.isEmpty ? null : val.trim()});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Divider(
                            thickness: 0.5,
                          ),
                        ),
                        Text(
                          'OR',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(
                          width: 100,
                          child: Divider(
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: _accountantCodeTextEditingController,
                    focusNode: _acountantCodeFocusNode,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      labelText: 'Accountant Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      _acountantData.addAll({
                        'actCode': val.isEmpty ? null : int.parse(val.trim())
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
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
            'Add Accountant',
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
                      _accountantFormGeneralInfoContainer(),
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
