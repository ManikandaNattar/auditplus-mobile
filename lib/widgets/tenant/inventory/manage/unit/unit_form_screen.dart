import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class UnitFormScreen extends StatefulWidget {
  @override
  _UnitFormScreenState createState() => _UnitFormScreenState();
}

class _UnitFormScreenState extends State<UnitFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  UnitProvider _unitProvider;
  String unitId = '';
  String unitName = '';
  String name = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _uqcFocusNode = FocusNode();
  FocusNode _symbolFocusNode = FocusNode();
  TextEditingController _uqcTextEditingController = TextEditingController();
  Map<String, dynamic> _unitDetail = {};
  Map arguments = {};
  Map<String, dynamic> _unitData = {};
  List _uqcList = [];
  List _filterUQCList = [];

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _uqcFocusNode.dispose();
    _symbolFocusNode.dispose();
    _uqcTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _unitProvider = Provider.of<UnitProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        unitId = arguments['id'];
        unitName = arguments['displayName'];
        _getUnit();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Future<List> _getUQCList(String query) async {
    _filterUQCList.clear();
    _uqcList = await _unitProvider.getUnitUQC();
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _uqcList.length - 1; i++) {
        String name = _uqcList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterUQCList.add(_uqcList[i]);
        }
      }
    } else {
      _filterUQCList = _uqcList;
    }
    return _filterUQCList;
  }

  Map<String, dynamic> _getUnit() {
    _unitDetail = arguments['detail'];
    _uqcTextEditingController.text =
        _unitDetail['uqc'] == null ? '' : _unitDetail['uqc']['code'];
    return _unitDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> responseData = {};
      try {
        if (unitId.isEmpty) {
          responseData = await _unitProvider.createUnit(_unitData);
          utils.showSuccessSnackbar(
              _screenContext, 'Unit Created Successfully');
        } else {
          await _unitProvider.updateUnit(unitId, _unitData);
          utils.showSuccessSnackbar(
              _screenContext, 'Unit updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Future.delayed(Duration(seconds: 1)).then(
            (value) => Navigator.of(_screenContext)
                .pushReplacementNamed('/inventory/manage/unit'),
          );
        } else {
          arguments['routeFormArguments'] = responseData;
          Future.delayed(Duration(seconds: 1)).then(
            (value) => Navigator.of(_screenContext).pop(
              arguments,
            ),
          );
        }
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _unitFormGeneralInfoContainer() {
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
                    initialValue: name.isEmpty ? _unitDetail['name'] : name,
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
                        _unitData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _unitDetail['aliasName']
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
                      FocusScope.of(context).requestFocus(_symbolFocusNode);
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _unitData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: name.isEmpty ? _unitDetail['symbol'] : name,
                    focusNode: _symbolFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Symbol',
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
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Symbol should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _unitData.addAll({'symbol': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _unitDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _displayNameFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_uqcFocusNode);
                    },
                    onSaved: (val) {
                      _unitData.addAll({
                        'displayName': val.isEmpty ? _unitData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue:
                        utils.cast<Map<String, dynamic>>(_unitDetail['uqc']),
                    focusNode: _uqcFocusNode,
                    controller: _uqcTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _getUQCList(pattern);
                    },
                    validator: null,
                    labelText: 'UQC',
                    suggestionFormatter: (suggestion) => suggestion['code'],
                    textFormatter: (selection) => selection['code'],
                    onSaved: (val) {
                      _unitData.addAll(
                        {
                          'uqc': val == null
                              ? null
                              : _uqcTextEditingController.text.isEmpty
                                  ? null
                                  : val['code']
                        },
                      );
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
            unitName.isEmpty ? 'Add Unit' : unitName,
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
                      _unitFormGeneralInfoContainer(),
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
