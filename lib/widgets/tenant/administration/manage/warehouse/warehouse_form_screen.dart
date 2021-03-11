import 'package:auditplusmobile/providers/administration/warehouse_provider.dart';
import 'package:auditplusmobile/providers/common_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class WarehouseFormScreen extends StatefulWidget {
  @override
  _WarehouseFormScreenState createState() => _WarehouseFormScreenState();
}

class _WarehouseFormScreenState extends State<WarehouseFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  WarehouseProvider _warehouseProvider;
  CommonProvider _commonProvider;
  String warehouseId = '';
  String warehouseName = '';
  TextEditingController _stateTextEditingController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _telephoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _pincodeFocusNode = FocusNode();
  FocusNode _stateFocusNode = FocusNode();
  List _stateList = [];
  List _filterStateList = [];
  Map<String, dynamic> _warehouseDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _warehouseData = {};
  Map<String, dynamic> _contactInfoData = {};
  Map<String, dynamic> _addressInfoData = {};

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _mobileFocusNode.dispose();
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
    _warehouseProvider = Provider.of<WarehouseProvider>(context);
    _commonProvider = Provider.of<CommonProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      warehouseId = arguments['id'];
      warehouseName = arguments['displayName'];
      _getWarehouse();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getWarehouse() {
    _warehouseDetail = arguments['detail'];
    _stateTextEditingController.text = _warehouseDetail['addressInfo']['state']
            .toString()
            .replaceAll('null', '')
            .isEmpty
        ? ''
        : _warehouseDetail['addressInfo']['state']['name'];
    return _warehouseDetail;
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

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        _warehouseData.addAll({
          'contactInfo': _contactInfoData,
          'addressInfo': _addressInfoData,
        });
        if (warehouseId.isEmpty) {
          await _warehouseProvider.createWarehouse(_warehouseData);
          utils.showSuccessSnackbar(
              _screenContext, 'Warehouse Created Successfully');
        } else {
          await _warehouseProvider.updateWarehouse(warehouseId, _warehouseData);
          utils.showSuccessSnackbar(
              _screenContext, 'Warehouse updated Successfully');
        }
        Future.delayed(Duration(seconds: 1)).then(
          (value) => Navigator.of(_screenContext)
              .pushReplacementNamed('/administration/manage/warehouse'),
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _warehouseFormGeneralInfoContainer() {
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
                    initialValue: _warehouseDetail['name'],
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
                        _warehouseData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _warehouseDetail['aliasName']
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
                        _warehouseData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _warehouseDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      _warehouseData.addAll({
                        'displayName':
                            val.isEmpty ? _warehouseData['name'] : val
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

  Widget _warehouseFormContactInfoContainer() {
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
                  initialValue: _warehouseDetail['contactInfo'] == null
                      ? ''
                      : _warehouseDetail['contactInfo']['mobile']
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
                    _contactInfoData
                        .addAll({'mobile': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  autofocus: true,
                  initialValue: _warehouseDetail['contactInfo'] == null
                      ? ''
                      : _warehouseDetail['contactInfo']['telephone']
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
                  initialValue: _warehouseDetail['contactInfo'] == null
                      ? ''
                      : _warehouseDetail['contactInfo']['email']
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

  Widget _warehouseFormAddressInfoContainer() {
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
                  autofocus: true,
                  initialValue: _warehouseDetail['addressInfo'] == null
                      ? ''
                      : _warehouseDetail['addressInfo']['address']
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
                  initialValue: _warehouseDetail['addressInfo'] == null
                      ? ''
                      : _warehouseDetail['addressInfo']['city']
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
                  initialValue: _warehouseDetail['addressInfo'] == null
                      ? ''
                      : _warehouseDetail['addressInfo']['pincode']
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
                  initialValue: _warehouseDetail.isEmpty
                      ? null
                      : utils.cast<Map<String, dynamic>>(
                          _warehouseDetail['addressInfo']['state']),
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
            warehouseName.isEmpty ? 'Add Warehouse' : warehouseName,
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
                      _warehouseFormGeneralInfoContainer(),
                      _warehouseFormContactInfoContainer(),
                      _warehouseFormAddressInfoContainer(),
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
