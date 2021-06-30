import 'package:auditplusmobile/providers/inventory/pharma_salt_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class PharmaSaltFormScreen extends StatefulWidget {
  @override
  _PharmaSaltFormScreenState createState() => _PharmaSaltFormScreenState();
}

class _PharmaSaltFormScreenState extends State<PharmaSaltFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  PharmaSaltProvider _pharmaSaltProvider;
  String saltId = '';
  String saltName = '';
  String name = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  Map<String, dynamic> _saltDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _saltData = {};
  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _pharmaSaltProvider = Provider.of<PharmaSaltProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        saltId = arguments['id'];
        saltName = arguments['displayName'];
        _getPharmaSalt();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getPharmaSalt() {
    _saltDetail = arguments['detail'];
    return _saltDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> responseData = {};
      try {
        if (saltId.isEmpty) {
          responseData = await _pharmaSaltProvider.createPharmaSalt(_saltData);
          utils.showSuccessSnackbar(
              _screenContext, 'Salt Created Successfully');
        } else {
          await _pharmaSaltProvider.updatePharmaSalt(saltId, _saltData);
          utils.showSuccessSnackbar(
              _screenContext, 'Salt updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/pharma-salt');
        } else {
          arguments['routeFormArguments'] = responseData;
          Navigator.of(_screenContext).pop(
            arguments,
          );
        }
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _pharmaSaltFormGeneralInfoContainer() {
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
                    initialValue: name.isEmpty ? _saltDetail['name'] : name,
                    focusNode: _nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _nameFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_aliasNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _saltData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _saltDetail['aliasName']
                        .toString()
                        .replaceAll('null', ''),
                    focusNode: _aliasNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Alias Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _aliasNameFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _saltData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _saltDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      _saltData.addAll({
                        'displayName': val.isEmpty ? _saltData['name'] : val
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
            saltName.isEmpty ? 'Add Salt' : saltName,
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
                      _pharmaSaltFormGeneralInfoContainer(),
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
