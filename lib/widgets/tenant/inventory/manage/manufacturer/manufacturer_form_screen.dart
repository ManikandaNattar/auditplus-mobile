import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class ManufacturerFormScreen extends StatefulWidget {
  @override
  _ManufacturerFormScreenState createState() => _ManufacturerFormScreenState();
}

class _ManufacturerFormScreenState extends State<ManufacturerFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  ManufacturerProvider _manufacturerProvider;
  String manufacturerId = '';
  String manufacturerName = '';
  String name = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _telephoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  Map<String, dynamic> _manufacturerDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _manufacturerData = {};
  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _manufacturerProvider = Provider.of<ManufacturerProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        manufacturerId = arguments['id'];
        manufacturerName = arguments['displayName'];
        _getManufacturer();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getManufacturer() {
    _manufacturerDetail = arguments['detail'];
    return _manufacturerDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> responseData = {};
      try {
        if (manufacturerId.isEmpty) {
          responseData =
              await _manufacturerProvider.createManufacturer(_manufacturerData);
          utils.showSuccessSnackbar(
              _screenContext, 'Manufacturer Created Successfully');
        } else {
          await _manufacturerProvider.updateManufacturer(
              manufacturerId, _manufacturerData);
          utils.showSuccessSnackbar(
              _screenContext, 'Manufacturer updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Future.delayed(Duration(seconds: 1)).then((value) =>
              Navigator.of(_screenContext)
                  .pushReplacementNamed('/inventory/manage/manufacturer'));
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

  Widget _manufacturerFormGeneralInfoContainer() {
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
                    initialValue:
                        name.isEmpty ? _manufacturerDetail['name'] : name,
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
                        _manufacturerData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _manufacturerDetail['aliasName']
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
                        _manufacturerData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _manufacturerDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      _manufacturerData.addAll({
                        'displayName':
                            val.isEmpty ? _manufacturerData['name'] : val
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

  Widget _manufacturerFormContactInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTileTheme(
            dense: true,
            child: ExpansionTile(
              maintainState: true,
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              title: Text(
                'CONTACT INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                TextFormField(
                  initialValue: _manufacturerDetail['mobile']
                      .toString()
                      .replaceAll('null', ''),
                  focusNode: _mobileFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _mobileFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_telephoneFocusNode);
                  },
                  onSaved: (val) {
                    _manufacturerData
                        .addAll({'mobile': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _manufacturerDetail['telephone']
                      .toString()
                      .replaceAll('null', ''),
                  focusNode: _telephoneFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Telephone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _telephoneFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  onSaved: (val) {
                    _manufacturerData
                        .addAll({'telephone': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _manufacturerDetail['email']
                      .toString()
                      .replaceAll('null', ''),
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.subtitle1,
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value) ==
                          false) {
                        return 'Email address should be valid address!';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _manufacturerData
                        .addAll({'email': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
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
            manufacturerName.isEmpty ? 'Add Manufacturer' : manufacturerName,
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
                      _manufacturerFormGeneralInfoContainer(),
                      _manufacturerFormContactInfoContainer(),
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
