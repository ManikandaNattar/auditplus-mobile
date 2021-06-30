import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/filter_key_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class InventoryFilterForm extends StatefulWidget {
  @override
  _InventoryFilterFormState createState() => _InventoryFilterFormState();
}

class _InventoryFilterFormState extends State<InventoryFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  SectionProvider _sectionProvider;
  ManufacturerProvider _manufacturerProvider;
  TaxProvider _taxProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasNameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aliasNameFocusNode = FocusNode();
  final FocusNode _barcodeFocusNode = FocusNode();
  final FocusNode _sectionFocusNode = FocusNode();
  final FocusNode _manufacturerFocusNode = FocusNode();
  final FocusNode _taxFocusNode = FocusNode();
  final FocusNode _hsnCodeFocusNode = FocusNode();
  String nameFilterKey;
  String aliasNameFilterKey;
  String barcodeFilterKey;
  String hsnCodeFilterKey;
  Map _formData = Map();
  List _taxList = [];
  List _filterTaxList = [];

  @override
  void dispose() {
    _barcodeFocusNode.dispose();
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _sectionFocusNode.dispose();
    _manufacturerFocusNode.dispose();
    _taxFocusNode.dispose();
    _hsnCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _sectionProvider = Provider.of<SectionProvider>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _manufacturerProvider = Provider.of<ManufacturerProvider>(context);
    _formData = ModalRoute.of(context).settings.arguments;
    _getFormData();
    super.didChangeDependencies();
  }

  void _getFormData() {
    _nameController.text = _formData['name'];
    _aliasNameController.text = _formData['aliasName'];
    _barcodeController.text = _formData['barcode'];
    _sectionController.text =
        _formData['section'] == '' || _formData['section'] == null
            ? ''
            : _formData['section']['name'];
    _manufacturerController.text =
        _formData['manufacturer'] == '' || _formData['manufacturer'] == null
            ? ''
            : _formData['manufacturer']['name'];
    _taxController.text = _formData['tax'] == '' || _formData['tax'] == null
        ? ''
        : _formData['tax']['displayName'];
    _hsnCodeController.text = _formData['hsnCode'];
    nameFilterKey = _formData['nameFilterKey'];
    aliasNameFilterKey = _formData['aliasNameFilterKey'];
    barcodeFilterKey = _formData['barcodeFilterKey'];
    hsnCodeFilterKey = _formData['hsnCodeFilterKey'];
  }

  Future<List> _getTaxList(String query) async {
    _filterTaxList.clear();
    if (_taxList.isEmpty) {
      _taxList = await _taxProvider.taxAutoComplete();
    }
    if (query.toString().isNotEmpty) {
      for (int i = 0; i <= _taxList.length - 1; i++) {
        String name = _taxList[i]['displayName'];
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .startsWith(query.toLowerCase())) {
          _filterTaxList.add(_taxList[i]);
        }
      }
    } else {
      _filterTaxList = _taxList;
    }
    return _filterTaxList;
  }

  Widget _buildFilterForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              FilterKeyFormField(
                labelName: 'Name',
                filterType: 'text',
                autoFocus: true,
                filterKey: nameFilterKey,
                textEditingController: _nameController,
                focusNode: _nameFocusNode,
                nextFocusNode: _formData['filterFormName'] == 'Inventory'
                    ? _barcodeFocusNode
                    : _aliasNameFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['name'] = val;
                },
                buttonOnPressed: (val) {
                  nameFilterKey = val;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: FilterKeyFormField(
                  labelName: 'AliasName',
                  filterType: 'text',
                  autoFocus: false,
                  filterKey: aliasNameFilterKey,
                  textEditingController: _aliasNameController,
                  focusNode: _aliasNameFocusNode,
                  nextFocusNode: _barcodeFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    _formData['aliasName'] = val;
                  },
                  buttonOnPressed: (val) {
                    aliasNameFilterKey = val;
                  },
                ),
                visible: _formData['filterFormName'] != 'Inventory',
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: FilterKeyFormField(
                  labelName: 'Barcode',
                  filterType: 'text',
                  autoFocus: false,
                  filterKey: barcodeFilterKey,
                  textEditingController: _barcodeController,
                  focusNode: _barcodeFocusNode,
                  nextFocusNode: _hsnCodeFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    _formData['barcode'] = val;
                  },
                  buttonOnPressed: (val) {
                    barcodeFilterKey = val;
                  },
                ),
                visible: _formData['filterFormName'] == 'Inventory',
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: FilterKeyFormField(
                  labelName: 'HSN Code',
                  filterKey: hsnCodeFilterKey,
                  filterType: 'text',
                  autoFocus: false,
                  textEditingController: _hsnCodeController,
                  focusNode: _hsnCodeFocusNode,
                  nextFocusNode: _sectionFocusNode,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    _formData['hsnCode'] = val;
                  },
                  buttonOnPressed: (val) {
                    hsnCodeFilterKey = val;
                  },
                ),
                visible: _formData['filterFormName'] == 'Inventory',
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: AutocompleteFormField(
                  initialValue:
                      utils.cast<Map<String, dynamic>>(_formData['section']),
                  focusNode: _sectionFocusNode,
                  controller: _sectionController,
                  autocompleteCallback: (pattern) {
                    return _sectionProvider.sectionAutoComplete(
                      searchText: pattern,
                    );
                  },
                  validator: null,
                  labelText: 'Section',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  onSaved: (val) {
                    if (val != null) {
                      _formData['section'] = _sectionController.text.isEmpty
                          ? _formData['section'] = ''
                          : val;
                    }
                  },
                ),
                visible: _formData['filterFormName'] == 'Inventory',
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: AutocompleteFormField(
                  initialValue: utils
                      .cast<Map<String, dynamic>>(_formData['manufacturer']),
                  focusNode: _manufacturerFocusNode,
                  controller: _manufacturerController,
                  autocompleteCallback: (pattern) {
                    return _manufacturerProvider.manufacturerAutoComplete(
                      searchText: pattern,
                    );
                  },
                  validator: null,
                  labelText: 'Manufacturer',
                  suggestionFormatter: (suggestion) => suggestion['name'],
                  textFormatter: (selection) => selection['name'],
                  onSaved: (val) {
                    if (val != null) {
                      _formData['manufacturer'] =
                          _manufacturerController.text.isEmpty
                              ? _formData['manufacturer'] = ''
                              : val;
                    }
                  },
                ),
                visible: _formData['filterFormName'] == 'Inventory',
              ),
              SizedBox(
                height: 15.0,
              ),
              Visibility(
                child: AutocompleteFormField(
                  initialValue:
                      utils.cast<Map<String, dynamic>>(_formData['tax']),
                  focusNode: _taxFocusNode,
                  controller: _taxController,
                  autocompleteCallback: (pattern) {
                    return _getTaxList(
                      pattern,
                    );
                  },
                  validator: null,
                  labelText: 'Tax',
                  suggestionFormatter: (suggestion) =>
                      suggestion['displayName'],
                  textFormatter: (selection) => selection['displayName'],
                  onSaved: (val) {
                    if (val != null) {
                      _formData['tax'] = _taxController.text.isEmpty
                          ? _formData['tax'] = ''
                          : val;
                    }
                  },
                ),
                visible: _formData['filterFormName'] == 'Inventory',
              ),
            ],
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
          title: Text(_formData['filterFormName']),
          actions: [
            TextButton(
              onPressed: () {
                _formKey.currentState.save();
                _formData['nameFilterKey'] = nameFilterKey;
                _formData['aliasNameFilterKey'] = aliasNameFilterKey;
                _formData['barcodeFilterKey'] = barcodeFilterKey;
                _formData['hsnCodeFilterKey'] = hsnCodeFilterKey;
                _formData['isAdvancedFilter'] = 'true';
                Navigator.of(context).pop(_formData);
              },
              child: Text(
                'SEARCH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
        body: _buildFilterForm(context),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
    );
  }
}
