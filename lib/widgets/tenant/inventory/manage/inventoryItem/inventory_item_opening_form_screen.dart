import 'package:auditplusmobile/providers/administration/preference_provider.dart';

import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/providers/qsearch_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemOpeningFormScreen extends StatefulWidget {
  @override
  _InventoryItemOpeningFormScreenState createState() =>
      _InventoryItemOpeningFormScreenState();
}

class _InventoryItemOpeningFormScreenState
    extends State<InventoryItemOpeningFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  PreferenceProvider _preferenceProvider;
  QSearchProvider _qSearchProvider;
  UnitProvider _unitProvider;
  TaxProvider _taxProvider;
  FocusNode _batchNoFocusNode = FocusNode();
  FocusNode _expiryFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _unitFocusNode = FocusNode();
  FocusNode _rateFocusNode = FocusNode();
  FocusNode _mrpFocusNode = FocusNode();
  FocusNode _sRateFocusNode = FocusNode();
  TextEditingController _unitTextEditingController = TextEditingController();
  TextEditingController _mrpTextEditingController = TextEditingController();
  TextEditingController _sRateTextEditingController = TextEditingController();
  TextEditingController _expiryDateTextEditingController =
      TextEditingController();
  List _unitList = [];
  List _filterUnitList = [];
  List _unitConversionList = [];
  Map<String, dynamic> _inventoryInfo = {};
  Map<String, dynamic> _preferenceData = {};
  Map<String, dynamic> _formData = Map();
  Map arguments = Map();
  bool _isLoading = true;

  @override
  void dispose() {
    _batchNoFocusNode.dispose();
    _expiryFocusNode.dispose();
    _quantityFocusNode.dispose();
    _unitFocusNode.dispose();
    _rateFocusNode.dispose();
    _mrpFocusNode.dispose();
    _sRateFocusNode.dispose();
    _unitTextEditingController.dispose();
    _mrpTextEditingController.dispose();
    _sRateTextEditingController.dispose();
    _expiryDateTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _preferenceProvider = Provider.of<PreferenceProvider>(context);
    _unitProvider = Provider.of<UnitProvider>(context);
    _qSearchProvider = Provider.of<QSearchProvider>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getInventoryInfo();
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _getInventoryInfo() async {
    if (_inventoryInfo.isEmpty) {
      _formData = arguments['formData'];
      _mrpTextEditingController.text =
          _formData['mrp'] == null ? '' : _formData['mrp'].toString();
      _sRateTextEditingController.text =
          _formData['sRate'] == null ? '' : _formData['sRate'].toString();
      _unitTextEditingController.text =
          _formData['unit'] == '' ? '' : _formData['unit']['name'];
      _expiryDateTextEditingController.text = _formData['expiry'];
      final data = await _qSearchProvider.getInventoryInfo(
        _formData['inventoryId'],
        _formData['branch']['id'],
      );
      final preference = await _preferenceProvider.getPreference(
        _formData['branch']['id'],
        ['inventory'],
      );
      setState(() {
        _isLoading = false;
        _inventoryInfo.addAll(data);
        _preferenceData.addAll(preference['inventory']);
      });
    }
    return _inventoryInfo;
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      _formData['unitPrecision'] = _inventoryInfo['unitPrecision'];
      _formKey.currentState.save();
      Navigator.of(context).pop(_formData);
    }
  }

  Future<List> _getUnitList(String query) async {
    _filterUnitList.clear();
    if (_unitList.isEmpty) {
      List _unitData = await _unitProvider.unitAutoComplete(searchText: '');
      _unitConversionList = _inventoryInfo['units'];
      if (_unitConversionList != null && _unitConversionList.isNotEmpty) {
        for (int i = 0; i <= _unitConversionList.length - 1; i++) {
          _unitList.addAll(
            _unitData.where(
              (element) => element['id'] == _unitConversionList[i]['unit'],
            ),
          );
        }
      } else {
        _unitList.addAll(_unitData);
      }
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _unitList.length - 1; i++) {
        String name = _unitList[i]['name'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .startsWith(query.toLowerCase())) {
          _filterUnitList.add(_unitList[i]);
        }
      }
    } else {
      _filterUnitList = _unitList;
    }
    return _filterUnitList;
  }

  Future<void> _getSaleRate(double pRate) async {
    double sRate;
    List _gstList = await _taxProvider.taxAutoComplete();
    Map _gstRatio = _gstList
        .where((element) => element['name'] == _inventoryInfo['tax'])
        .map((e) => e['ratio'])
        .single as Map;
    if (_inventoryInfo['sMargin'] == null) {
      sRate = 0.00;
    } else {
      final cgst = _gstRatio['cgst'];
      final sgst = _gstRatio['sgst'];
      double rate =
          (((pRate / (1 - (_inventoryInfo['sMargin'] / 100))) * 100) / 100);
      sRate = rate * (1 + (cgst / 100) + (sgst / 100));
    }
    _mrpTextEditingController.text =
        double.parse(sRate.toStringAsFixed(2)).toString();
    _sRateTextEditingController.text =
        double.parse(sRate.toStringAsFixed(2)).toString();
  }

  Widget _inventoryItemOpeningFormContainer() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formData['inventoryName'].toUpperCase(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      _formData['branch']['name'].toUpperCase(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
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
                            Visibility(
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: _formData['batchNo'] == null
                                        ? ''
                                        : _formData['batchNo'],
                                    readOnly: _formData['batchNo']
                                        .toString()
                                        .isNotEmpty,
                                    autofocus:
                                        _formData['batchNo'].toString().isEmpty,
                                    focusNode: _batchNoFocusNode,
                                    decoration: InputDecoration(
                                      labelText: 'Batch',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () {
                                      _batchNoFocusNode.unfocus();
                                      FocusScope.of(context).requestFocus(
                                        _preferenceData['enableExp'] &&
                                                _preferenceData[
                                                        'expRequired'] ==
                                                    true
                                            ? _expiryFocusNode
                                            : _quantityFocusNode,
                                      );
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Batch should not be empty!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      if (val.isNotEmpty) {
                                        _formData['batchNo'] = val;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                              visible:
                                  _formData['isBatchWiseInventory'] == true,
                            ),
                            Visibility(
                              child: Column(
                                children: [
                                  DatePickerFormField(
                                    title: 'Expiry Date',
                                    controller:
                                        _expiryDateTextEditingController,
                                    onSaved: (value) {
                                      _formData['expiry'] = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                              visible: _preferenceData['enableExp'] &&
                                  _preferenceData['expRequired'] &&
                                  _formData['isBatchWiseInventory'],
                            ),
                            TextFormField(
                              initialValue: _formData['qty'] == null
                                  ? ''
                                  : _formData['qty'].toString(),
                              focusNode: _quantityFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _quantityFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_unitFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Quantity should not be empty!';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                if (val.isNotEmpty) {
                                  _formData['qty'] = val;
                                }
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            AutocompleteFormField(
                              initialValue: utils.cast<Map<String, dynamic>>(
                                _formData['unit'],
                              ),
                              autoFocus: false,
                              focusNode: _unitFocusNode,
                              controller: _unitTextEditingController,
                              autocompleteCallback: (pattern) {
                                return _getUnitList(pattern);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Unit should not be empty!';
                                }
                                return null;
                              },
                              labelText: 'Unit',
                              suggestionFormatter: (suggestion) =>
                                  suggestion['name'],
                              textFormatter: (selection) => selection['name'],
                              onSaved: (val) {
                                _formData['unit'] = val;
                              },
                              onSelected: (val) {
                                _formData['unitConv'] = _unitConversionList
                                    .where(
                                      (element) => element['unit'] == val['id'],
                                    )
                                    .single['conversion'];
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              initialValue: _formData['rate'] == null
                                  ? ''
                                  : _formData['rate'].toString(),
                              focusNode: _rateFocusNode,
                              decoration: InputDecoration(
                                labelText: 'P.Rate(TAX EXCL.)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _rateFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_mrpFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Rate should not be empty!';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                if (val.isNotEmpty) {
                                  _formData['rate'] = val;
                                }
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  _mrpTextEditingController.text = '0.00';
                                  _sRateTextEditingController.text = '0.00';
                                } else {
                                  _getSaleRate(double.parse(value));
                                }
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: _mrpTextEditingController,
                              focusNode: _mrpFocusNode,
                              decoration: InputDecoration(
                                labelText: 'MRP',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _mrpFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_sRateFocusNode);
                              },
                              onSaved: (val) {
                                _formData['mrp'] = val;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'MRP should not be empty!';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _sRateTextEditingController.text = value;
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: _sRateTextEditingController,
                              focusNode: _sRateFocusNode,
                              decoration: InputDecoration(
                                labelText: 'S.Rate(TAX INCL.)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              onSaved: (val) {
                                _formData['sRate'] = val;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'S.Rate should not be empty!';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _mrpTextEditingController.text = value;
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Opening'),
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
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _inventoryItemOpeningFormContainer(),
    );
  }
}
