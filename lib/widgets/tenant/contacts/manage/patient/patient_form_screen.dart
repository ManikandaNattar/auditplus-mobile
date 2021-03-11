import 'package:auditplusmobile/providers/contacts/customer_provider.dart';
import 'package:auditplusmobile/providers/contacts/patient_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class PatientFormScreen extends StatefulWidget {
  @override
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  PatientProvider _patientProvider;
  CustomerProvider _customerProvider;
  String patientId = '';
  String patientName = '';
  String customerId = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _customerFocusNode = FocusNode();
  TextEditingController _customerTextEditingController =
      TextEditingController();
  Map<String, dynamic> _patientDetail = {};
  Map arguments = {};
  Map<String, dynamic> _patientData = {};

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _customerFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _patientProvider = Provider.of<PatientProvider>(context);
    _customerProvider = Provider.of<CustomerProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      patientId = arguments['id'];
      patientName = arguments['displayName'];
      _getPatient();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getPatient() {
    _patientDetail = arguments['detail'];
    _customerTextEditingController.text = _patientDetail['customer']['name'];
    return _patientDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        if (patientId.isEmpty) {
          await _patientProvider.createPatient(_patientData);
          utils.showSuccessSnackbar(
              _screenContext, 'Patient Created Successfully');
        } else {
          await _patientProvider.updatePatient(patientId, _patientData);
          utils.showSuccessSnackbar(
              _screenContext, 'Patient updated Successfully');
        }
        Future.delayed(Duration(seconds: 1)).then((value) =>
            Navigator.of(_screenContext)
                .pushReplacementNamed('/contacts/manage/patient'));
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _patientFormGeneralInfoContainer() {
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
                    initialValue: _patientDetail['name'],
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
                        _patientData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _patientDetail['aliasName']
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
                        _patientData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _patientDetail['displayName'],
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
                      FocusScope.of(context).requestFocus(_customerFocusNode);
                    },
                    onSaved: (val) {
                      _patientData.addAll({
                        'displayName': val.isEmpty ? _patientData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils
                        .cast<Map<String, dynamic>>(_patientDetail['customer']),
                    focusNode: _customerFocusNode,
                    controller: _customerTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _customerProvider.customerAutoComplete(
                          searchText: pattern);
                    },
                    validator: (value) {
                      if (customerId.isEmpty && value == null) {
                        return 'Customer should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Customer',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _patientData.addAll(
                        {
                          'customer':
                              customerId.isEmpty ? val['id'] : customerId
                        },
                      );
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        padding: EdgeInsets.only(top: 8.0),
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/contacts/manage/customer/form',
                          arguments: {
                            'routeForm': 'PatientToCustomer',
                            'id': patientId,
                            'displayName': patientName,
                            'detail': _patientData,
                            'formInputName':
                                _customerTextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              customerId =
                                  arguments['routeFormArguments']['id'];
                              _customerTextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        ['contacts.customer.create'],
                      ),
                    ),
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
            patientName.isEmpty ? 'Add Patient' : patientName,
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
                      _patientFormGeneralInfoContainer(),
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
