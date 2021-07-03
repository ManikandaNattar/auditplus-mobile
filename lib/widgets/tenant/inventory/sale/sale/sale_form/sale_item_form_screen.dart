import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/providers/qsearch_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../../constants.dart' as constants;

class SaleItemFormScreen extends StatefulWidget {
  @override
  _SaleItemFormScreenState createState() => _SaleItemFormScreenState();
}

class _SaleItemFormScreenState extends State<SaleItemFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _inventoryController = TextEditingController();
  InventoryItemProvider _inventoryItemProvider;
  UnitProvider _unitProvider;
  TaxProvider _taxProvider;
  TextEditingController _unitTextEditingController = TextEditingController();
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  Map _selectedInventory = {};
  List _selectedBatches = [];
  List _taxList = [];
  Map _selectedTax = {};
  QSearchProvider _qSearchProvider;
  List _inventoryBatches = [];
  bool _isLoading = false;
  bool _allowNegativeStock = false;
  List _unitList = [];
  Map _inventoryTax = {};
  double disc = 0.0;
  double discAmount = 0.0;
  List _unitConversionList = [];
  Map<String, dynamic> _inventoryInfo = {};
  Map<String, dynamic> _preferenceData = {};
  Map _selectedUnit = {};
  List _filterUnitList = [];

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _unitProvider = Provider.of<UnitProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    _qSearchProvider = Provider.of<QSearchProvider>(context);
    _getTaxList();
    super.didChangeDependencies();
  }

  Future<void> _getInventoryInfo() async {
    final response = await _qSearchProvider.getInventoryInfo(
      _selectedInventory['id'],
      _selectedBranch['id'],
    );
    setState(() {
      _inventoryInfo = response;
      _isLoading = false;
      _inventoryBatches = _inventoryInfo['batches'];
    });
  }

  Future<List> _getTaxList() async {
    if (_taxList.isEmpty) {
      final data = await _taxProvider.taxAutoComplete();
      setState(() {
        _taxList = data;
      });
    }
    return _taxList;
  }

  Future<List> _getUnitList(String query) async {
    print(1);
    _filterUnitList = [];
    if (_unitList.isEmpty) {
      print(2);
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

  Widget _itemInfo() {
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
                'ITEM INFO',
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
                  AutocompleteFormField(
                    outlineInputBorder: false,
                    floatingLabelBehaviour: true,
                    controller: _inventoryController,
                    autoFocus: false,
                    autocompleteCallback: (pattern) {
                      return _inventoryItemProvider.inventoryItemAutoComplete(
                        searchText: pattern,
                        inventoryHeads: [
                          _selectedBranch['inventoryHead'],
                        ],
                      );
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Inventory should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Inventory',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {},
                    onSelected: (val) {
                      setState(() {
                        _isLoading = true;
                        _selectedInventory = val;
                      });
                      _getInventoryInfo();
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    child: _totalInfo(),
                    visible: _selectedInventory.isNotEmpty,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalInfo() {
    return Container(
      child: Column(
        children: [
          Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Discount',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.bodyText1,
                            onSaved: (val) {},
                          ),
                        ),
                        Text(
                          '%',
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '\u{20B9}',
                          textAlign: TextAlign.start,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.bodyText1,
                            onSaved: (val) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Tax %',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                            style: Theme.of(context).textTheme.subtitle1,
                            value: _selectedTax['displayName'],
                            items: _taxList.map(
                              (value) {
                                return DropdownMenuItem(
                                  value: value['displayName'],
                                  child: Text(
                                    value['displayName'],
                                    style: TextStyle(
                                      color: _selectedTax['displayName'] ==
                                              value['displayName']
                                          ? Colors.blue
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedTax.addAll(
                                  _taxList
                                      .where((element) =>
                                          element['displayName'] == val)
                                      .single,
                                );
                              });
                            },
                            onSaved: (newValue) {},
                          ),
                        ),
                        // SizedBox(
                        //   width: 10.0,
                        // ),
                        // Text(
                        //   '\u{20B9}',
                        //   textAlign: TextAlign.start,
                        // ),
                        // Expanded(
                        //   child: TextFormField(
                        //     decoration: InputDecoration(
                        //       isDense: true,
                        //     ),
                        //     keyboardType: TextInputType.number,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyText1,
                        //     onSaved: (val) {},
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodyText1,
                    onSaved: (val) {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _batchInfo() {
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
                'BATCH INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ..._inventoryBatches.map(
              (e) {
                return Column(
                  children: [
                    Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          initialValue: e['sRate'].toString(),
                                          decoration: InputDecoration(
                                            labelText: 'Rate(Tax incl)',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Qty',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: AutocompleteFormField(
                                        isDense: true,
                                        autoFocus: false,
                                        focusNode: null,
                                        outlineInputBorder: false,
                                        floatingLabelBehaviour: true,
                                        controller: _unitTextEditingController,
                                        autocompleteCallback: (pattern) {
                                          return _getUnitList(pattern);
                                        },
                                        validator: null,
                                        labelText: 'Unit',
                                        suggestionFormatter: (suggestion) =>
                                            suggestion['name'],
                                        textFormatter: (selection) =>
                                            selection['name'],
                                        onSaved: (val) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: TextFormField(
                                        readOnly: true,
                                        initialValue: e['batchNo'],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Batch No',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: TextFormField(
                                        readOnly: true,
                                        initialValue:
                                            constants.defaultDate.format(
                                          DateTime.parse(e['expiry']),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Expiry',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          readOnly: true,
                                          initialValue: e['mrp'].toString(),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'MRP',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextFormField(
                                        readOnly: true,
                                        initialValue: e['closing'].toString(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Stock',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                );
              },
            ).toList(),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              child: Text(
                'SUBMIT',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: ElevatedButton(
              child: Text(
                'SUBMIT & ADD NEW',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {},
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
          'Add Item',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _itemInfo(),
                _isLoading == true
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Visibility(
                        child: _batchInfo(),
                        visible: _inventoryBatches.isNotEmpty,
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _submitButton(),
    );
  }
}
