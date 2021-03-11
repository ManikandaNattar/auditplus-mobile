import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:auditplusmobile/providers/inventory/pharma_salt_provider.dart';
import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemFormScreen extends StatefulWidget {
  @override
  _InventoryItemFormScreenState createState() =>
      _InventoryItemFormScreenState();
}

class _InventoryItemFormScreenState extends State<InventoryItemFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  SectionProvider _sectionProvider;
  UnitProvider _unitProvider;
  TaxProvider _taxProvider;
  ManufacturerProvider _manufacturerProvider;
  InventoryItemProvider _inventoryItemProvider;
  PharmaSaltProvider _pharmaSaltProvider;
  TenantAuth _tenantAuth;
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _sectionFocusNode = FocusNode();
  FocusNode _unitFocusNode = FocusNode();
  FocusNode _decimalFocusNode = FocusNode();
  FocusNode _taxFocusNode = FocusNode();
  FocusNode _manufacturerFocusNode = FocusNode();
  FocusNode _hsnCodeFocusNode = FocusNode();
  FocusNode _saltFocusNode = FocusNode();
  FocusNode _barcodeFocusNode = FocusNode();
  TextEditingController _sectionTextEditingController = TextEditingController();
  TextEditingController _manufacturerTextEditingController =
      TextEditingController();
  TextEditingController _unitTextEditingController = TextEditingController();
  TextEditingController _taxTextEditingController = TextEditingController();
  TextEditingController _saltTextEditingController = TextEditingController();
  Map<String, dynamic> _inventoryItemDetail = {};
  Map arguments = {};
  Map<String, dynamic> _inventoryItemData = {};
  List _saltList = [];
  List<String> _saltIdArrayList = [];
  Map _selectedBranch = {};
  String sectionId = '';
  String manufactuerId = '';
  String unitId = '';
  String inventoryItemId = '';
  String inventoryItemName = '';
  int decimalvalue = 0;
  bool _enableMultipleBatches = false;
  bool _allowNegativeStock = false;
  bool _scheduleH = false;
  bool _scheduleH1 = false;
  bool _narcotics = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _sectionFocusNode.dispose();
    _unitFocusNode.dispose();
    _decimalFocusNode.dispose();
    _taxFocusNode.dispose();
    _manufacturerFocusNode.dispose();
    _hsnCodeFocusNode.dispose();
    _saltFocusNode.dispose();
    _barcodeFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _sectionProvider = Provider.of<SectionProvider>(context);
    _unitProvider = Provider.of<UnitProvider>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _manufacturerProvider = Provider.of<ManufacturerProvider>(context);
    _pharmaSaltProvider = Provider.of<PharmaSaltProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      inventoryItemId = arguments['id'];
      inventoryItemName = arguments['displayName'];
      _getInventory();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getInventory() {
    if (_inventoryItemDetail.isEmpty) {
      _inventoryItemDetail = arguments['detail'];
      _saltList = _inventoryItemDetail['salts'];
      decimalvalue = _inventoryItemDetail['precision'];
      _enableMultipleBatches = _inventoryItemDetail['bwd'];
      _allowNegativeStock = _inventoryItemDetail['allowNegativeStock'];
      _scheduleH = _inventoryItemDetail['scheduleH'];
      _scheduleH1 = _inventoryItemDetail['scheduleH1'];
      _narcotics = _inventoryItemDetail['narcotics'];
      _sectionTextEditingController.text =
          _inventoryItemDetail['section'] == null
              ? ''
              : _inventoryItemDetail['section']['name'];
      _unitTextEditingController.text = _inventoryItemDetail['unit'] == null
          ? ''
          : _inventoryItemDetail['unit']['name'];
      _manufacturerTextEditingController.text =
          _inventoryItemDetail['manufacturer'] == null
              ? ''
              : _inventoryItemDetail['manufacturer']['name'];
      _taxTextEditingController.text = _inventoryItemDetail['tax'] == null
          ? ''
          : _inventoryItemDetail['tax']['name'];
    }
    return _inventoryItemDetail;
  }

  void _getSelectedSaltList() {
    if (_saltList.isNotEmpty) {
      for (int i = 0; i <= _saltList.length - 1; i++) {
        _saltIdArrayList.add(_saltList[i]['id']);
      }
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _inventoryItemData['head'] = _selectedBranch['inventoryHead'];
      _inventoryItemData['bwd'] = _enableMultipleBatches;
      _inventoryItemData['allowNegativeStock'] = _allowNegativeStock;
      _inventoryItemData['scheduleH'] = _scheduleH;
      _inventoryItemData['scheduleH1'] = _scheduleH1;
      _inventoryItemData['narcotics'] = _narcotics;
      _inventoryItemData['salts'] = _saltIdArrayList;
      try {
        if (inventoryItemId.isEmpty) {
          await _inventoryItemProvider.createInventory(_inventoryItemData);
          utils.showSuccessSnackbar(
            _screenContext,
            'Inventory Created Successfully',
          );
        } else {
          await _inventoryItemProvider.updateInventory(
            inventoryItemId,
            _inventoryItemData,
          );
          utils.showSuccessSnackbar(
            _screenContext,
            'Inventory updated Successfully',
          );
        }
        Future.delayed(Duration(seconds: 1)).then(
          (value) => Navigator.of(_screenContext).pushReplacementNamed(
            '/inventory/manage/inventory-item',
          ),
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _inventoryItemFormGeneralInfoContainer() {
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
                    initialValue: _inventoryItemDetail['name'],
                    focusNode: _nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: _nameFocusNode.hasFocus == true
                          ? TextStyle(
                              color: Theme.of(context).errorColor,
                            )
                          : null,
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
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _inventoryItemData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _inventoryItemDetail['displayName'],
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
                      FocusScope.of(context).requestFocus(_unitFocusNode);
                    },
                    onSaved: (val) {
                      _inventoryItemData.addAll({
                        'displayName':
                            val.isEmpty ? _inventoryItemData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: inventoryItemId.isEmpty
                            ? AutocompleteFormField(
                                autoFocus: false,
                                focusNode: _unitFocusNode,
                                controller: _unitTextEditingController,
                                autocompleteCallback: (pattern) {
                                  return _unitProvider.unitAutoComplete(
                                    searchText: pattern,
                                  );
                                },
                                validator: (value) {
                                  if (unitId.isEmpty && value == null) {
                                    return 'Unit should not be empty';
                                  }
                                  return null;
                                },
                                labelText: 'Unit',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                                suggestionFormatter: (suggestion) =>
                                    suggestion['name'],
                                textFormatter: (selection) => selection['name'],
                                onSaved: (val) {
                                  _inventoryItemData.addAll(
                                    {
                                      'unit':
                                          unitId.isEmpty ? val['id'] : unitId
                                    },
                                  );
                                },
                                suffixIconWidget: Visibility(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        '/inventory/manage/unit/form',
                                        arguments: {
                                          'routeForm': 'InventoryToUnit',
                                          'id': inventoryItemId,
                                          'displayName': inventoryItemName,
                                          'detail': _inventoryItemData,
                                          'formInputName':
                                              _unitTextEditingController.text,
                                        },
                                      ).then((value) {
                                        _unitFocusNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_decimalFocusNode);
                                        if (value != null) {
                                          setState(() {
                                            Map data = value;
                                            unitId = data['routeFormArguments']
                                                ['id'];
                                            _unitTextEditingController.text =
                                                data['routeFormArguments']
                                                    ['name'];
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  visible: utils.checkMenuWiseAccess(
                                    context,
                                    ['inventory.unit.create'],
                                  ),
                                ),
                              )
                            : TextFormField(
                                readOnly: true,
                                initialValue: _unitTextEditingController.text,
                                decoration: InputDecoration(
                                  labelText: 'Unit',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.grey),
                                onSaved: (val) {
                                  _inventoryItemData.addAll({'unit': val});
                                },
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                        width: 100.0,
                        height: 55.0,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Decimal',
                            border: OutlineInputBorder(),
                          ),
                          focusNode: _decimalFocusNode,
                          style: Theme.of(context).textTheme.subtitle1,
                          value: decimalvalue,
                          items:
                              <int>[0, 1, 2, 3, 4].map<DropdownMenuItem<int>>(
                            (int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              decimalvalue = val;
                            });
                          },
                          onSaved: (newValue) {
                            _inventoryItemData['precision'] = newValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _inventoryItemDetail['tax'],
                    ),
                    focusNode: _taxFocusNode,
                    controller: _taxTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _taxProvider.taxAutoComplete(
                        searchText: pattern,
                      );
                    },
                    validator: (val) {
                      if (val == null) {
                        return 'Tax should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Tax',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _inventoryItemData.addAll(
                        {'tax': val == null ? null : val['id']},
                      );
                    },
                    onSelected: (_) {
                      _inventoryItemDetail['tax'] = {};
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

  Widget _inventoryItemFormProductInfoContainer() {
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
                'PRODUCT INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                AutocompleteFormField(
                  initialValue: utils.cast<Map<String, dynamic>>(
                    _inventoryItemDetail['section'],
                  ),
                  focusNode: _sectionFocusNode,
                  controller: _sectionTextEditingController,
                  labelText: 'Section',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  validator: null,
                  autocompleteCallback: (pattern) async {
                    return _sectionProvider.sectionAutoComplete(
                      searchText: pattern,
                    );
                  },
                  onSaved: (val) {
                    _inventoryItemData.addAll({
                      'section': sectionId.isEmpty
                          ? val == null
                              ? null
                              : val['id']
                          : sectionId
                    });
                  },
                  onSelected: (_) {
                    _inventoryItemDetail['section'] = {};
                  },
                  suffixIconWidget: Visibility(
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/inventory/manage/section/form',
                          arguments: {
                            'routeForm': 'InventoryToSection',
                            'id': inventoryItemId,
                            'displayName': inventoryItemName,
                            'detail': _inventoryItemData,
                            'formInputName': _sectionTextEditingController.text,
                          },
                        ).then((value) {
                          _sectionFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_manufacturerFocusNode);
                          if (value != null) {
                            setState(() {
                              Map data = value;
                              sectionId = data['routeFormArguments']['id'];
                              _sectionTextEditingController.text =
                                  data['routeFormArguments']['name'];
                            });
                          }
                        });
                      },
                    ),
                    visible: utils.checkMenuWiseAccess(
                      context,
                      ['inventory.section.create'],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                AutocompleteFormField(
                  initialValue: utils.cast<Map<String, dynamic>>(
                    _inventoryItemDetail['manufacturer'],
                  ),
                  focusNode: _manufacturerFocusNode,
                  controller: _manufacturerTextEditingController,
                  labelText: 'Manufacturer',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  validator: null,
                  autocompleteCallback: (pattern) async {
                    return _manufacturerProvider.manufacturerAutoComplete(
                      searchText: pattern,
                    );
                  },
                  onSaved: (val) {
                    _inventoryItemData.addAll({
                      'manufacturer': manufactuerId.isEmpty
                          ? val == null
                              ? null
                              : val['id']
                          : manufactuerId
                    });
                  },
                  onSelected: (_) {
                    _inventoryItemDetail['manufacturer'] = {};
                  },
                  suffixIconWidget: Visibility(
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/inventory/manage/manufacturer/form',
                          arguments: {
                            'routeForm': 'InventoryToManufacturer',
                            'id': inventoryItemId,
                            'displayName': inventoryItemName,
                            'detail': _inventoryItemData,
                            'formInputName':
                                _manufacturerTextEditingController.text,
                          },
                        ).then((value) {
                          _manufacturerFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_barcodeFocusNode);
                          if (value != null) {
                            setState(() {
                              Map data = value;
                              manufactuerId = data['routeFormArguments']['id'];
                              _manufacturerTextEditingController.text =
                                  data['routeFormArguments']['name'];
                            });
                          }
                        });
                      },
                    ),
                    visible: utils.checkMenuWiseAccess(
                      context,
                      ['inventory.manufacturer.create'],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _inventoryItemDetail['barcode']
                      .toString()
                      .replaceAll('null', ''),
                  focusNode: _barcodeFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Barcode',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _barcodeFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_hsnCodeFocusNode);
                  },
                  onSaved: (val) {
                    _inventoryItemData
                        .addAll({'barcode': val.isEmpty ? null : val});
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: _inventoryItemDetail['hsnCode']
                      .toString()
                      .replaceAll('null', ''),
                  focusNode: _hsnCodeFocusNode,
                  decoration: InputDecoration(
                    labelText: 'HSN Code',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.subtitle1,
                  onSaved: (val) {
                    _inventoryItemData
                        .addAll({'hsnCode': val.isEmpty ? null : val});
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

  Widget _inventoryItemFormConfigurationInfoContainer() {
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
                'CONFIGURATION INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(4),
                  title: Text(
                    'Enable Multiple Batches',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  value: _enableMultipleBatches,
                  onChanged: (val) {
                    setState(() {
                      _enableMultipleBatches = val;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(4),
                  title: Text(
                    'Allow Negative Stock',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  value: _allowNegativeStock,
                  onChanged: (val) {
                    setState(() {
                      _allowNegativeStock = val;
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

  Widget _inventoryItemFormSaltInfoContainer() {
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
                'SALT INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              children: [
                AutocompleteFormField(
                  autoFocus: false,
                  focusNode: _saltFocusNode,
                  controller: _saltTextEditingController,
                  labelText: 'Salt',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  validator: null,
                  onSaved: (_) {
                    _getSelectedSaltList();
                  },
                  autocompleteCallback: (pattern) async {
                    List data =
                        await _pharmaSaltProvider.pharmaSaltAutoComplete(
                      searchText: pattern,
                    );
                    if (_saltList.isNotEmpty) {
                      for (int i = 0; i <= _saltList.length - 1; i++) {
                        data.removeWhere(
                          (elm) => elm['id'] == _saltList[i]['id'],
                        );
                      }
                    }
                    return data;
                  },
                  onSelected: (value) {
                    _saltTextEditingController.clear();
                    setState(() {
                      _saltList.add(value);
                    });
                  },
                  suffixIconWidget: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/inventory/manage/pharma-salt/form',
                        arguments: {
                          'routeForm': 'InventoryToSalt',
                          'id': inventoryItemId,
                          'displayName': inventoryItemName,
                          'detail': _inventoryItemData,
                          'formInputName': _saltTextEditingController.text,
                        },
                      ).then((value) {
                        _saltFocusNode.nextFocus();
                        if (value != null) {
                          Map data = value;
                          setState(() {
                            _saltList.add(data['routeFormArguments']);
                          });
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Wrap(
                      spacing: 5.0,
                      children: [
                        ..._saltList
                            .map(
                              (e) => Chip(
                                label: Text(
                                  e['displayName'],
                                ),
                                labelStyle: Theme.of(context).textTheme.button,
                                backgroundColor: Theme.of(context).primaryColor,
                                deleteIcon: Icon(Icons.clear),
                                deleteIconColor:
                                    Theme.of(context).textTheme.button.color,
                                onDeleted: () {
                                  setState(
                                    () {
                                      _saltList.removeWhere((element) =>
                                          element['id'] == e['id']);
                                      _saltIdArrayList.remove(e['id']);
                                    },
                                  );
                                },
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  visible: _saltList.isNotEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inventoryItemFormDrugsClassificationContainer() {
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
                'DRUGS CLASSIFICATION',
                style: Theme.of(context).textTheme.headline1,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(4),
                        title: Text(
                          'Schedule H',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        value: _scheduleH,
                        onChanged: (val) {
                          setState(() {
                            _scheduleH = val;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          'Schedule H1',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        value: _scheduleH1,
                        onChanged: (val) {
                          setState(() {
                            _scheduleH1 = val;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(4),
                        title: Text(
                          'Narcotics',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        value: _narcotics,
                        onChanged: (val) {
                          setState(() {
                            _narcotics = val;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkVisiblityForPharmacyFeaturesMenu() {
    return Visibility(
      child: Column(
        children: [
          _inventoryItemFormDrugsClassificationContainer(),
          _inventoryItemFormSaltInfoContainer(),
        ],
      ),
      visible: utils.checkFeatures(context, 'pharmacy'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            inventoryItemName.isEmpty ? 'Add Inventory' : inventoryItemName,
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
                      _inventoryItemFormGeneralInfoContainer(),
                      _inventoryItemFormProductInfoContainer(),
                      _inventoryItemFormConfigurationInfoContainer(),
                      _checkVisiblityForPharmacyFeaturesMenu(),
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
