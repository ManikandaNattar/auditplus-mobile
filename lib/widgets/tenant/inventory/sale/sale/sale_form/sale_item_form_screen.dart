import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  TextEditingController _taxController = TextEditingController();
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  List _selectedBatches = [];
  List _taxList = [];
  List _filterTaxList = [];
  Map _selectedTax = {};

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _unitProvider = Provider.of<UnitProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _taxProvider = Provider.of<TaxProvider>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  // Future<List> _getTaxList() async {
  //   if (_taxList.isEmpty) {
  //     _taxList = await _taxProvider.taxAutoComplete();
  //     _filterTaxList = JsonDecoder().convert(json.encode(_taxList));
  //   }
  //   print(_filterTaxList);
  //   return _taxList;
  // }

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
                      if (val != null) {
                        Navigator.of(context).pushNamed(
                          '/inventory/sale/item/batches/detail',
                          arguments: {
                            'inventoryId': val['id'],
                            'inventoryName': val['name'],
                            'branch': _selectedBranch,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              _selectedBatches = value;
                            });
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    child: _batchDetail(),
                    visible: _selectedBatches.isNotEmpty,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyRateInfo() {
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
                'RATE INFO',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.subtitle1,
                          onSaved: (val) {},
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: AutocompleteFormField(
                          controller: _unitTextEditingController,
                          autoFocus: false,
                          autocompleteCallback: (pattern) {
                            return _unitProvider.unitAutoComplete(
                              searchText: pattern,
                            );
                          },
                          validator: null,
                          labelText: 'Unit',
                          suggestionFormatter: (suggestion) =>
                              suggestion['name'],
                          textFormatter: (selection) => selection['name'],
                          onSaved: (val) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Rate (Price / Unit)',
                      border: OutlineInputBorder(),
                      suffixText: 'Tax Incl',
                    ),
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {},
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

  Widget _totalInfo() {
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
                'TOTAL INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                children: [
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Subtotal',
                                style: Theme.of(context).textTheme.bodyText2,
                                children: [
                                  TextSpan(
                                    text: ' (Rate X Qty)',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200.0,
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
                    ],
                  ),
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
                            width: 200.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: Text('%'),
                                    ),
                                    keyboardType: TextInputType.number,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    onSaved: (val) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: Text('\u{20B9}'),
                                    ),
                                    keyboardType: TextInputType.number,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'Tax %',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: AutocompleteFormField(
                              outlineInputBorder: false,
                              autoFocus: false,
                              focusNode: null,
                              controller: _taxController,
                              autocompleteCallback: (pattern) {
                                return _getTaxList(pattern);
                              },
                              validator: (val) {
                                return null;
                              },
                              labelText: '',
                              labelStyle: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                              suggestionFormatter: (suggestion) =>
                                  suggestion['displayName'],
                              textFormatter: (selection) =>
                                  selection['displayName'],
                              onSaved: (val) {},
                              onSelected: (val) {
                                _selectedTax = val;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _batchDetail() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batch No',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'VC01',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expiry',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '05-06-2023',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '12',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MRP',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '86532325.25',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
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
                _qtyRateInfo(),
                _totalInfo(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _submitButton(),
    );
  }
}
