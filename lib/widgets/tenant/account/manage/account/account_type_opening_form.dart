import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../constants.dart' as constants;

class AccountTypeOpeningForm extends StatefulWidget {
  @override
  _AccountTypeOpeningFormState createState() => _AccountTypeOpeningFormState();
}

class _AccountTypeOpeningFormState extends State<AccountTypeOpeningForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceDateTextEditingController =
      TextEditingController();
  TextEditingController _creditTextEditingController = TextEditingController();
  TextEditingController _debitTextEditingController = TextEditingController();
  FocusNode _invoiceDateFocusNode = FocusNode();
  FocusNode _refNoFocusNode = FocusNode();
  FocusNode _creditFocusNode = FocusNode();
  FocusNode _debitFocusNode = FocusNode();
  Map<String, dynamic> _formData = Map();
  Map arguments = Map();

  @override
  void dispose() {
    _invoiceDateFocusNode.dispose();
    _refNoFocusNode.dispose();
    _creditFocusNode.dispose();
    _debitFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getFormData() {
    _formData = arguments['formData'];
    _creditTextEditingController.text = _formData['credit'].toString();
    _debitTextEditingController.text = _formData['debit'].toString();
    _invoiceDateTextEditingController.text = _formData['effDate'] == ''
        ? constants.defaultDate.format(DateTime.now())
        : constants.defaultDate.format(
            DateTime.parse(
              _formData['effDate'],
            ),
          );
    return _formData;
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop(_formData);
    }
  }

  Widget _openingFormGeneralInfoContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              _formData['openingAccount'].toUpperCase(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              _formData['openingBranch'].toUpperCase(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
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
                      vertical: 4.0,
                    ),
                    child: Column(
                      children: [
                        DatePickerFormField(
                          title: 'Invoice Date',
                          controller: _invoiceDateTextEditingController,
                          onSaved: (value) {
                            var inputInvoiceDate =
                                constants.defaultDate.parse(value);
                            var outputInvoiceDate = constants.isoDateFormat
                                .format(inputInvoiceDate);
                            _formData['effDate'] = outputInvoiceDate;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          initialValue: _formData['refNo'] == null
                              ? ''
                              : _formData['refNo'],
                          focusNode: _refNoFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Reference Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.subtitle1,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            _refNoFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_creditFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Reference Number should not be empty!';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            if (val.isNotEmpty) {
                              _formData['refNo'] = val;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: _creditTextEditingController,
                          focusNode: _creditFocusNode,
                          decoration: InputDecoration(
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
                              _formData['credit'] = val;
                            }
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _debitTextEditingController.text = '0.0';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: _debitTextEditingController,
                          focusNode: _debitFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Debit',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.subtitle1,
                          onSaved: (val) {
                            _formData['debit'] = val;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _creditTextEditingController.text = '0.0';
                            }
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Opening',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _onSubmit();
            },
            child: Text(
              'ADD',
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
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _openingFormGeneralInfoContainer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
