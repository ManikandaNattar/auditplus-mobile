import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './customer_group_form.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../providers/common_provider.dart';
import './../../../../../providers/tax/tax_provider.dart';
import '../../../../../providers/inventory/customer_provider.dart';
import './../../../../shared/autocomplete_form_field.dart';

class CustomerFormScreen extends StatefulWidget {
  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  CustomerProvider _customerProvider;
  TaxProvider _taxProvider;
  CommonProvider _commonProvider;
  String customerId = '';
  String customerName = '';
  Map regTypeInitialValue = {};
  TextEditingController _regTypeTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _stateTextEditingController = TextEditingController();
  TextEditingController _customerGroupTextEditingController =
      TextEditingController();
  TextEditingController _locationTextEditingController =
      TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _customerGroupFocusNode = FocusNode();
  FocusNode _regTypeFocusNode = FocusNode();
  FocusNode _gstNoFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();
  FocusNode _aadhaarNoFocusNode = FocusNode();
  FocusNode _panNoFocusNode = FocusNode();
  FocusNode _contactPersonFocusNode = FocusNode();
  FocusNode _primaryMobileFocusNode = FocusNode();
  FocusNode _secondaryMobileFocusNode = FocusNode();
  FocusNode _telephoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _addressContactPersonFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _pincodeFocusNode = FocusNode();
  FocusNode _countryFocusNode = FocusNode();
  FocusNode _stateFocusNode = FocusNode();
  List _customerGroupList = [];
  List _filterCustomerGroupList = [];
  List _regTypeList = [];
  List _filterRegTypeList = [];
  List _countryList = [];
  List _filterCountryList = [];
  List _locationList = [];
  List _filterLocationList = [];
  List _stateList = [];
  List _filterStateList = [];
  bool _gstNoVisiblity = false;
  bool _locationVisiblity = true;
  String name = '';
  Map<String, dynamic> _customerDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _customerData = {};
  Map<String, dynamic> _gstInfoData = {};
  Map<String, dynamic> _otherInfoData = {};
  Map<String, dynamic> _contactInfoData = {};
  Map<String, dynamic> _addressInfoData = {};

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _customerGroupFocusNode.dispose();
    _regTypeFocusNode.dispose();
    _gstNoFocusNode.dispose();
    _locationFocusNode.dispose();
    _aadhaarNoFocusNode.dispose();
    _panNoFocusNode.dispose();
    _contactPersonFocusNode.dispose();
    _primaryMobileFocusNode.dispose();
    _secondaryMobileFocusNode.dispose();
    _telephoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressContactPersonFocusNode.dispose();
    _addressFocusNode.dispose();
    _cityFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _commonProvider = Provider.of<CommonProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        customerId = arguments['id'];
        customerName = arguments['displayName'];
        _getCustomer();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getCustomer() {
    _customerDetail = arguments['detail'];
    regTypeInitialValue = _customerDetail['gstInfo']['regType'];
    _customerGroupTextEditingController.text =
        _customerDetail.keys.contains('group')
            ? _customerDetail['group']['name']
            : '';
    _regTypeTextEditingController.text = _customerDetail['gstInfo']['regType']
            .toString()
            .replaceAll('null', '')
            .isEmpty
        ? ''
        : _customerDetail['gstInfo']['regType']['name'];
    _locationTextEditingController.text = _customerDetail['gstInfo']['location']
            .toString()
            .replaceAll('null', '')
            .isEmpty
        ? ''
        : _customerDetail['gstInfo']['location']['name'];
    _stateTextEditingController.text = _customerDetail['addressInfo'] == null
        ? ''
        : _customerDetail['addressInfo']['state']['name'];
    _countryTextEditingController.text = _customerDetail['addressInfo'] == null
        ? ''
        : _customerDetail['addressInfo']['country']['name'];
    return _customerDetail;
  }

  Future<List> _getCustomerGroupList(String query) async {
    _filterCustomerGroupList.clear();
    _customerGroupList = await _customerProvider.getCustomerGroup();
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _customerGroupList.length - 1; i++) {
        String name = _customerGroupList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterCustomerGroupList.add(_customerGroupList[i]);
        }
      }
    } else {
      _filterCustomerGroupList = _customerGroupList;
    }
    return _filterCustomerGroupList;
  }

  Future<List> _getRegistrationTypeList(String query) async {
    _filterRegTypeList.clear();
    if (_regTypeList.isEmpty) {
      _regTypeList =
          await _taxProvider.getRegistrationType(registerType: 'customer');
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _regTypeList.length - 1; i++) {
        String name = _regTypeList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterRegTypeList.add(_regTypeList[i]);
        }
      }
    } else {
      _filterRegTypeList = _regTypeList;
    }
    return _filterRegTypeList;
  }

  Future<List> _getCountryList(String query) async {
    _filterCountryList.clear();
    if (_countryList.isEmpty) {
      _countryList = await _commonProvider.getCountryList();
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _countryList.length - 1; i++) {
        String name = _countryList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterCountryList.add(_countryList[i]);
        }
      }
    } else {
      _filterCountryList = _countryList;
    }
    return _filterCountryList;
  }

  Future<List> _getStateList(String query) async {
    _filterStateList.clear();
    if (_stateList.isEmpty) {
      _stateList = await _commonProvider.getStateList();
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _stateList.length - 1; i++) {
        String name = _stateList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterStateList.add(_stateList[i]);
        }
      }
    } else {
      _filterStateList = _stateList;
    }
    return _filterStateList;
  }

  Future<List> _getLocationList(String query) async {
    _filterLocationList.clear();
    if (_locationList.isEmpty) {
      _locationList = await _commonProvider.getStateList();
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _locationList.length - 1; i++) {
        String name = _locationList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterLocationList.add(_locationList[i]);
        }
      }
    } else {
      _filterLocationList = _locationList;
    }
    return _filterLocationList;
  }

  void _checkVisibilityForGSTNo(String selectedValue) {
    setState(() {
      regTypeInitialValue = null;
      if (selectedValue.contains('Consumer') ||
          selectedValue.contains('Overseas')) {
        if (_customerDetail['gstInfo'] != null) {
          _customerDetail['gstInfo']['gstNo'] = '';
        }
        _gstNoVisiblity = false;
      } else {
        _gstNoVisiblity = true;
      }
    });
  }

  void _checkVisibilityForLocation(String selectedValue) {
    setState(() {
      regTypeInitialValue = null;
      if (selectedValue.contains('Overseas')) {
        if (_customerDetail['gstInfo'] != null) {
          _customerDetail['gstInfo']['location'] = '';
        }
        _locationVisiblity = false;
      } else {
        _locationVisiblity = true;
      }
    });
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Map<String, dynamic> responseData = {};
        _customerData.addAll({
          'gstInfo': _gstInfoData,
          'otherInfo': _otherInfoData,
          'contactInfo': _contactInfoData,
          'addressInfo': _addressInfoData,
        });
        if (customerId.isEmpty) {
          responseData = await _customerProvider.createCustomer(_customerData);
          utils.showSuccessSnackbar(
              _screenContext, 'Customer Created Successfully');
        } else {
          await _customerProvider.updateCustomer(customerId, _customerData);
          utils.showSuccessSnackbar(
              _screenContext, 'Customer updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/sale/customer');
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

  Widget _customerFormGeneralInfoContainer() {
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
                    initialValue: name.isEmpty ? _customerDetail['name'] : name,
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
                        _customerData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _customerDetail['aliasName']
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
                        _customerData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _customerDetail['displayName'],
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
                      FocusScope.of(context)
                          .requestFocus(_customerGroupFocusNode);
                    },
                    onSaved: (val) {
                      _customerData.addAll({
                        'displayName': val.isEmpty ? _customerData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils
                        .cast<Map<String, dynamic>>(_customerDetail['group']),
                    focusNode: _customerGroupFocusNode,
                    controller: _customerGroupTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _getCustomerGroupList(pattern);
                    },
                    validator: null,
                    labelText: 'Customer Group',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _customerData
                          .addAll({'group': val == null ? null : val['id']});
                    },
                    suffixIconWidget: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => showCustomerGroupForm(
                        screenContext: _screenContext,
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

  Widget _customerFormGSTInfoContainer() {
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
                'GST INFO',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutocompleteFormField(
                    initialValue:
                        utils.cast<Map<String, dynamic>>(regTypeInitialValue),
                    focusNode: _regTypeFocusNode,
                    controller: _regTypeTextEditingController,
                    labelText: 'Registration Type',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    autocompleteCallback: (pattern) {
                      return _getRegistrationTypeList(pattern);
                    },
                    onSelected: (selectedValue) {
                      _checkVisibilityForGSTNo(selectedValue['name']);
                      _checkVisibilityForLocation(selectedValue['name']);
                    },
                    onSaved: (val) {
                      _gstInfoData.addAll(
                          {'regType': val == null ? null : val['defaultName']});
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Registration Type should not be empty!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _customerDetail['gstInfo'] == null
                              ? ''
                              : _customerDetail['gstInfo']['gstNo']
                                  .toString()
                                  .replaceAll('null', ''),
                          focusNode: _gstNoFocusNode,
                          decoration: InputDecoration(
                            labelText: 'GSTIN',
                            labelStyle: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.subtitle1,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            _gstNoFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_locationFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'GSTIN should not be empty!';
                            } else if (value.length < 15 || value.length > 15) {
                              return 'GSTIN should be 15 chars!';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _gstInfoData
                                .addAll({'gstNo': val.isEmpty ? null : val});
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                    visible: _customerDetail.isEmpty
                        ? _gstNoVisiblity
                        : _customerDetail['gstInfo']['gstNo']
                                .toString()
                                .replaceAll('null', '')
                                .isNotEmpty
                            ? true
                            : _gstNoVisiblity,
                  ),
                  Visibility(
                    child: Column(
                      children: [
                        AutocompleteFormField(
                          initialValue: _customerDetail.isEmpty
                              ? null
                              : utils.cast<Map<String, dynamic>>(
                                  _customerDetail['gstInfo']['location']),
                          focusNode: _locationFocusNode,
                          controller: _locationTextEditingController,
                          labelText: 'Location',
                          labelStyle: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          autocompleteCallback: (pattern) {
                            return _getLocationList(pattern);
                          },
                          onSaved: (val) {
                            _gstInfoData.addAll(
                                {'location': val == null ? null : val['code']});
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Location should not be empty!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                    visible: _customerDetail.isEmpty
                        ? _locationVisiblity
                        : _customerDetail['gstInfo']['location']
                            .toString()
                            .replaceAll('null', '')
                            .isNotEmpty,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerFormOtherInfoContainer() {
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
                'OTHER INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                TextFormField(
                  initialValue: _customerDetail['otherInfo'] == null
                      ? ''
                      : _customerDetail['otherInfo']['aadharNo']
                          .toString()
                          .replaceAll('null', ''),
                  autofocus: true,
                  focusNode: _aadhaarNoFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Aadhar Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _aadhaarNoFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_panNoFocusNode);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (value.length < 12 || value.length > 12) {
                        return 'Aadhar Number should be 12 chars!';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _otherInfoData
                        .addAll({'aadharNo': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['otherInfo'] == null
                      ? ''
                      : _customerDetail['otherInfo']['panNo']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _panNoFocusNode,
                  decoration: InputDecoration(
                    labelText: 'PAN',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _panNoFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_contactPersonFocusNode);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (value.length < 10 || value.length > 10) {
                        return 'PAN should be 10 chars!';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _otherInfoData.addAll({'panNo': val.isEmpty ? null : val});
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

  Widget _customerFormContactInfoContainer() {
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
                  initialValue: _customerDetail['contactInfo'] == null
                      ? ''
                      : _customerDetail['contactInfo']['contactPerson']
                          .toString()
                          .replaceAll('null', ''),
                  autofocus: true,
                  focusNode: _contactPersonFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _contactPersonFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_primaryMobileFocusNode);
                  },
                  onSaved: (val) {
                    _contactInfoData
                        .addAll({'contactPerson': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['contactInfo'] == null
                      ? ''
                      : _customerDetail['contactInfo']['mobile']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _primaryMobileFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    hintText: 'Primary',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _primaryMobileFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_secondaryMobileFocusNode);
                  },
                  onSaved: (val) {
                    _contactInfoData
                        .addAll({'mobile': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['contactInfo'] == null
                      ? ''
                      : _customerDetail['contactInfo']['alternateMobile']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _secondaryMobileFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Alternate Mobile',
                    hintText: 'Secondary',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _secondaryMobileFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_telephoneFocusNode);
                  },
                  onSaved: (val) {
                    _contactInfoData
                        .addAll({'alternateMobile': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['contactInfo'] == null
                      ? ''
                      : _customerDetail['contactInfo']['telephone']
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
                    _contactInfoData
                        .addAll({'telephone': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['contactInfo'] == null
                      ? ''
                      : _customerDetail['contactInfo']['email']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_addressContactPersonFocusNode);
                  },
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
                    _contactInfoData
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

  Widget _customerFormAddressInfoContainer() {
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
                'ADDRESS INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                TextFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? ''
                      : _customerDetail['addressInfo']['contactPerson']
                          .toString()
                          .replaceAll('null', ''),
                  autofocus: true,
                  focusNode: _addressContactPersonFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _addressContactPersonFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_addressFocusNode);
                  },
                  onSaved: (val) {
                    _addressInfoData
                        .addAll({'contactPerson': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? ''
                      : _customerDetail['addressInfo']['address']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _addressFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'DoorNo/Street',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _addressFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_cityFocusNode);
                  },
                  onSaved: (val) {
                    _addressInfoData
                        .addAll({'address': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? ''
                      : _customerDetail['addressInfo']['city']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _cityFocusNode,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _cityFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_pincodeFocusNode);
                  },
                  onSaved: (val) {
                    _addressInfoData.addAll({'city': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? ''
                      : _customerDetail['addressInfo']['pincode']
                          .toString()
                          .replaceAll('null', ''),
                  focusNode: _pincodeFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _pincodeFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_countryFocusNode);
                  },
                  onSaved: (val) {
                    _addressInfoData
                        .addAll({'pincode': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                AutocompleteFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? null
                      : utils.cast<Map<String, dynamic>>(
                          _customerDetail['addressInfo']['country']),
                  focusNode: _countryFocusNode,
                  controller: _countryTextEditingController,
                  labelText: 'Country',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  autocompleteCallback: (pattern) async {
                    return _getCountryList(pattern);
                  },
                  onSaved: (val) {
                    _addressInfoData.addAll(
                        {'country': val == null ? null : val['defaultName']});
                  },
                  validator: null,
                ),
                SizedBox(
                  height: 15.0,
                ),
                AutocompleteFormField(
                  initialValue: _customerDetail['addressInfo'] == null
                      ? null
                      : utils.cast<Map<String, dynamic>>(
                          _customerDetail['addressInfo']['state']),
                  focusNode: _stateFocusNode,
                  controller: _stateTextEditingController,
                  labelText: 'State',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  autocompleteCallback: (pattern) async {
                    return _getStateList(pattern);
                  },
                  onSaved: (val) {
                    _addressInfoData.addAll(
                        {'state': val == null ? null : val['defaultName']});
                  },
                  validator: null,
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
            customerName.isEmpty ? 'Add Customer' : customerName,
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
                      _customerFormGeneralInfoContainer(),
                      _customerFormGSTInfoContainer(),
                      _customerFormOtherInfoContainer(),
                      _customerFormContactInfoContainer(),
                      _customerFormAddressInfoContainer(),
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
