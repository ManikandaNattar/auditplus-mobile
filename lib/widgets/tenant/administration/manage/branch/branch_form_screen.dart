import 'package:auditplusmobile/providers/accounting/account_provider.dart';
import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/providers/common_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/branch/inventory_head_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class BranchFormScreen extends StatefulWidget {
  @override
  _BranchFormScreenState createState() => _BranchFormScreenState();
}

class _BranchFormScreenState extends State<BranchFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  BranchProvider _branchProvider;
  TaxProvider _taxProvider;
  CommonProvider _commonProvider;
  AccountProvider _accountProvider;

  String branchId = '';
  String branchName = '';
  bool _pharmacyRetail = false;
  Map regTypeInitialValue = {};
  TextEditingController _regTypeTextEditingController = TextEditingController();
  TextEditingController _stateTextEditingController = TextEditingController();
  TextEditingController _inventoryHeadTextEditingController =
      TextEditingController();
  TextEditingController _locationTextEditingController =
      TextEditingController();
  TextEditingController _accountTextEditingController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _inventoryHeadFocusNode = FocusNode();
  FocusNode _regTypeFocusNode = FocusNode();
  FocusNode _gstNoFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();
  FocusNode _licenseNumberFocusNode = FocusNode();
  FocusNode _primaryMobileFocusNode = FocusNode();
  FocusNode _secondaryMobileFocusNode = FocusNode();
  FocusNode _telephoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _pincodeFocusNode = FocusNode();
  FocusNode _stateFocusNode = FocusNode();
  List _inventoryHeadList = [];
  List _filterInventoryHeadList = [];
  List _regTypeList = [];
  List _filterRegTypeList = [];
  List _locationList = [];
  List _filterLocationList = [];
  List _stateList = [];
  List _filterStateList = [];
  String name = '';
  Map<String, dynamic> _branchDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _branchData = {};
  Map<String, dynamic> _gstInfoData = {};
  Map<String, dynamic> _otherInfoData = {};
  Map<String, dynamic> _contactInfoData = {};
  Map<String, dynamic> _addressInfoData = {};
  String accountId = '';

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _inventoryHeadFocusNode.dispose();
    _regTypeFocusNode.dispose();
    _gstNoFocusNode.dispose();
    _locationFocusNode.dispose();
    _licenseNumberFocusNode.dispose();
    _primaryMobileFocusNode.dispose();
    _secondaryMobileFocusNode.dispose();
    _telephoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _cityFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _stateFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _branchProvider = Provider.of<BranchProvider>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _commonProvider = Provider.of<CommonProvider>(context);
    _accountProvider = Provider.of<AccountProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      branchId = arguments['id'];
      branchName = arguments['displayName'];
      _getBranch();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getBranch() {
    _branchDetail = arguments['detail'];
    regTypeInitialValue = _branchDetail['gstInfo']['regType'];
    _pharmacyRetail = _branchDetail['features']['pharmacyRetail'];
    _inventoryHeadTextEditingController.text =
        _branchDetail.keys.contains('inventoryHead')
            ? _branchDetail['inventoryHead']['name']
            : '';
    _accountTextEditingController.text = _branchDetail.keys.contains('account')
        ? _branchDetail['account']['name']
        : '';
    _regTypeTextEditingController.text = _branchDetail['gstInfo']['regType']
            .toString()
            .replaceAll('null', '')
            .isEmpty
        ? ''
        : _branchDetail['gstInfo']['regType']['name'];
    _locationTextEditingController.text = _branchDetail['gstInfo']['location']
            .toString()
            .replaceAll('null', '')
            .isEmpty
        ? ''
        : _branchDetail['gstInfo']['location']['name'];
    _stateTextEditingController.text =
        _branchDetail.keys.contains('addressInfo')
            ? _branchDetail['addressInfo']['state']['name']
            : '';
    return _branchDetail;
  }

  Future<List> _getInventoryHeadList(String query) async {
    _filterInventoryHeadList.clear();
    _inventoryHeadList = await _branchProvider.getInventoryHead();
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _inventoryHeadList.length - 1; i++) {
        String name = _inventoryHeadList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .contains(query.toLowerCase())) {
          _filterInventoryHeadList.add(_inventoryHeadList[i]);
        }
      }
    } else {
      _filterInventoryHeadList = _inventoryHeadList;
    }
    return _filterInventoryHeadList;
  }

  Future<List> _getRegistrationTypeList(String query) async {
    _filterRegTypeList.clear();
    if (_regTypeList.isEmpty) {
      _regTypeList =
          await _taxProvider.getRegistrationType(registerType: 'branch');
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

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        _branchData.addAll({
          'gstInfo': _gstInfoData,
          'otherInfo': _otherInfoData,
          'contactInfo': _contactInfoData,
          'addressInfo': _addressInfoData,
          'features': {'pharmacyRetail': _pharmacyRetail}
        });
        if (branchId.isEmpty) {
          await _branchProvider.createBranch(_branchData);
          utils.showSuccessSnackbar(
              _screenContext, 'Branch Created Successfully');
        } else {
          await _branchProvider.updateBranch(branchId, _branchData);
          utils.showSuccessSnackbar(
              _screenContext, 'Branch updated Successfully');
        }
        Navigator.of(_screenContext)
            .pushReplacementNamed('/administration/manage/branch');
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _branchFormGeneralInfoContainer() {
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
                    initialValue: name.isEmpty ? _branchDetail['name'] : name,
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
                        _branchData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _branchDetail['aliasName']
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
                        _branchData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _branchDetail['displayName'],
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
                          .requestFocus(_inventoryHeadFocusNode);
                    },
                    onSaved: (val) {
                      _branchData.addAll({
                        'displayName': val.isEmpty ? _branchData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                        _branchDetail['inventoryHead']),
                    focusNode: _inventoryHeadFocusNode,
                    controller: _inventoryHeadTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _getInventoryHeadList(pattern);
                    },
                    validator: (val) {
                      if (val == null) {
                        return 'Inventory Head should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Inventory Head',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _branchData.addAll(
                          {'inventoryHead': val == null ? null : val['id']});
                    },
                    suffixIconWidget: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => showInventoryHeadForm(
                        screenContext: _screenContext,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _branchDetail['account'],
                    ),
                    autoFocus: false,
                    controller: _accountTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _accountProvider.accountAutocomplete(
                        searchText: pattern,
                        accountType: [
                          "BRANCH_TRANSFER",
                        ],
                      );
                    },
                    validator: (val) {
                      if (accountId.isEmpty && val == null) {
                        return 'Account should not be empty';
                      }
                      return null;
                    },
                    labelText: 'Account',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _branchData.addAll({
                        'account': accountId.isEmpty ? val['id'] : accountId
                      });
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/accounts/manage/account/form',
                          arguments: {
                            'routeForm': 'BranchToAccount',
                            'id': branchId,
                            'displayName': branchName,
                            'detail': _branchDetail,
                            'formInputName': _accountTextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              accountId = arguments['routeFormArguments']['id'];
                              _accountTextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        [
                          'ac.ac.cr',
                        ],
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

  Widget _branchFormGSTInfoContainer() {
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
                  TextFormField(
                    initialValue: _branchDetail['gstInfo'] == null
                        ? ''
                        : _branchDetail['gstInfo']['gstNo']
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
                      FocusScope.of(context).requestFocus(_locationFocusNode);
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
                      _gstInfoData.addAll({'gstNo': val.isEmpty ? null : val});
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: _branchDetail.isEmpty
                        ? null
                        : utils.cast<Map<String, dynamic>>(
                            _branchDetail['gstInfo']['location']),
                    focusNode: _locationFocusNode,
                    controller: _locationTextEditingController,
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchFormOtherInfoContainer() {
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
                  initialValue: _branchDetail['otherInfo'] == null
                      ? ''
                      : _branchDetail['otherInfo']['licenseNo']
                          .toString()
                          .replaceAll('null', ''),
                  autofocus: true,
                  focusNode: _licenseNumberFocusNode,
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    _otherInfoData
                        .addAll({'licenseNo': val.isEmpty ? null : val});
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

  Widget _branchFormContactInfoContainer() {
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
                  initialValue: _branchDetail['contactInfo'] == null
                      ? ''
                      : _branchDetail['contactInfo']['mobile']
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
                  initialValue: _branchDetail['contactInfo'] == null
                      ? ''
                      : _branchDetail['contactInfo']['alternateMobile']
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
                  initialValue: _branchDetail['contactInfo'] == null
                      ? ''
                      : _branchDetail['contactInfo']['telephone']
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
                  initialValue: _branchDetail['contactInfo'] == null
                      ? ''
                      : _branchDetail['contactInfo']['email']
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
                    FocusScope.of(context).requestFocus(_addressFocusNode);
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

  Widget _branchFormAddressInfoContainer() {
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
                  initialValue: _branchDetail['addressInfo'] == null
                      ? ''
                      : _branchDetail['addressInfo']['address']
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
                  initialValue: _branchDetail['addressInfo'] == null
                      ? ''
                      : _branchDetail['addressInfo']['city']
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
                  initialValue: _branchDetail['addressInfo'] == null
                      ? ''
                      : _branchDetail['addressInfo']['pincode']
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
                    FocusScope.of(context).requestFocus(_stateFocusNode);
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
                  initialValue: _branchDetail.isEmpty ||
                          !_branchDetail.keys.contains('addressInfo')
                      ? null
                      : utils.cast<Map<String, dynamic>>(
                          _branchDetail['addressInfo']['state']),
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

  Widget _branchFormFeaturesInfoContainer() {
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
              title: Text(
                'FEATURES INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(4),
                  title: Text(
                    'Pharmacy Retail',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  value: _pharmacyRetail,
                  onChanged: (val) {
                    setState(() {
                      _pharmacyRetail = val;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
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
            branchName.isEmpty ? 'Add Branch' : branchName,
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
                      _branchFormGeneralInfoContainer(),
                      _branchFormGSTInfoContainer(),
                      _branchFormContactInfoContainer(),
                      _branchFormAddressInfoContainer(),
                      _branchFormOtherInfoContainer(),
                      _branchFormFeaturesInfoContainer()
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
