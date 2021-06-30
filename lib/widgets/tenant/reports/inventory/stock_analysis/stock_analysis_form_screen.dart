import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockAnalysisFormScreen extends StatefulWidget {
  @override
  _StockAnalysisFormScreenState createState() =>
      _StockAnalysisFormScreenState();
}

enum StockAnalysisGroupBy {
  Inventory,
  Section,
  Branch,
  Manufacturer,
}

class _StockAnalysisFormScreenState extends State<StockAnalysisFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  StockAnalysisGroupBy _stockAnalysisGroupBy = StockAnalysisGroupBy.Inventory;
  FocusNode _manufacturerFocusNode = FocusNode();
  FocusNode _sectionFocusNode = FocusNode();
  FocusNode _inventoryFocusNode = FocusNode();
  TextEditingController _inventoryTextEditingController =
      TextEditingController();
  TextEditingController _manufacturerTextEditingController =
      TextEditingController();
  TextEditingController _sectionTextEditingController = TextEditingController();
  InventoryItemProvider _inventoryItemProvider;
  ManufacturerProvider _manufacturerProvider;
  SectionProvider _sectionProvider;
  List<Map<String, dynamic>> _selectedManufacturerList = [];
  List _selectedManufacturerIdList = [];
  List<Map<String, dynamic>> _selectedInventoryList = [];
  List _selectedInventoryIdList = [];
  List<Map<String, dynamic>> _selectedSectionList = [];
  List _selectedSectionIdList = [];
  Map arguments = {};
  List _rptInventoryHeads = [];

  @override
  void dispose() {
    _sectionTextEditingController.dispose();
    _manufacturerTextEditingController.dispose();
    _inventoryTextEditingController.dispose();
    _manufacturerFocusNode.dispose();
    _sectionFocusNode.dispose();
    _inventoryFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _manufacturerProvider = Provider.of<ManufacturerProvider>(context);
    _sectionProvider = Provider.of<SectionProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      _getFormData();
    }
  }

  void _getFormData() {
    _stockAnalysisGroupBy = arguments['stockAnalysisGroupBy'] == ''
        ? _stockAnalysisGroupBy
        : arguments['stockAnalysisGroupBy'];
    _selectedManufacturerList = arguments['manufacturerList'] == ''
        ? _selectedManufacturerList
        : arguments['manufacturerList'];
    _selectedInventoryList = arguments['inventoryList'] == ''
        ? _selectedInventoryList
        : arguments['inventoryList'];
    _selectedSectionList = arguments['sectionList'] == ''
        ? _selectedSectionList
        : arguments['sectionList'];
    _selectedManufacturerIdList = arguments['manufacturer'] == ''
        ? _selectedManufacturerIdList
        : arguments['manufacturer'];
    _selectedInventoryIdList = arguments['inventory'] == ''
        ? _selectedInventoryIdList
        : arguments['inventory'];
    _selectedSectionIdList = arguments['section'] == ''
        ? _selectedSectionIdList
        : arguments['section'];
    List _rptBranchList = arguments['rptBranchList'];
    for (int i = 0; i <= _rptBranchList.length - 1; i++) {
      _rptInventoryHeads.add(_rptBranchList[i]['inventoryHead']);
    }
  }

  void _onSearch() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _formData = {
        'stockAnalysisGroupBy': _stockAnalysisGroupBy,
        'inventory': _selectedInventoryIdList,
        'inventoryList': _selectedInventoryList,
        'manufacturerList': _selectedManufacturerList,
        'manufacturer': _selectedManufacturerIdList,
        'section': _selectedSectionIdList,
        'sectionList': _selectedSectionList,
      };
      Navigator.of(context).pop(_formData);
    }
  }

  void _getSelectedManufacturerList() {
    if (_selectedManufacturerList.isNotEmpty) {
      for (int i = 0; i <= _selectedManufacturerList.length - 1; i++) {
        if (_selectedManufacturerList[i]['id'] != '-1') {
          if (_selectedManufacturerIdList
              .where((element) => element == _selectedManufacturerList[i]['id'])
              .isEmpty) {
            _selectedManufacturerIdList.add(_selectedManufacturerList[i]['id']);
          }
        }
      }
    }
  }

  void _getSelectedSectionList() {
    if (_selectedSectionList.isNotEmpty) {
      for (int i = 0; i <= _selectedSectionList.length - 1; i++) {
        if (_selectedSectionList[i]['id'] != '-1') {
          if (_selectedSectionIdList
              .where((element) => element == _selectedSectionList[i]['id'])
              .isEmpty) {
            _selectedSectionIdList.add(_selectedSectionList[i]['id']);
          }
        }
      }
    }
  }

  void _getSelectedInventoryList() {
    if (_selectedInventoryList.isNotEmpty) {
      for (int i = 0; i <= _selectedInventoryList.length - 1; i++) {
        if (_selectedInventoryList[i]['id'] != '-1') {
          if (_selectedInventoryIdList
              .where((element) => element == _selectedInventoryList[i]['id'])
              .isEmpty) {
            _selectedInventoryIdList.add(_selectedInventoryList[i]['id']);
          }
        }
      }
    }
  }

  Widget _stockAnalysisFormGeneralInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'GENERAL INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'GroupBy',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: DropdownButton<StockAnalysisGroupBy>(
                      isExpanded: true,
                      value: _stockAnalysisGroupBy,
                      onChanged: (StockAnalysisGroupBy newValue) {
                        setState(() {
                          _stockAnalysisGroupBy = newValue;
                          arguments['stockAnalysisGroupBy'] = '';
                        });
                      },
                      items: StockAnalysisGroupBy.values.map(
                        (StockAnalysisGroupBy stockAnalysisGroupBy) {
                          return DropdownMenuItem<StockAnalysisGroupBy>(
                            value: stockAnalysisGroupBy,
                            child: Text(
                              stockAnalysisGroupBy.toString().split('.').last,
                              style: TextStyle(
                                color: stockAnalysisGroupBy ==
                                        _stockAnalysisGroupBy
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stockAnalysisFormManufacturerContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'MANUFACTURER INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              AutocompleteFormField(
                autoFocus: false,
                focusNode: _manufacturerFocusNode,
                controller: _manufacturerTextEditingController,
                labelText: 'Manufacturer',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                validator: (_) {
                  return null;
                },
                onSaved: (_) {
                  _getSelectedManufacturerList();
                },
                autocompleteCallback: (pattern) async {
                  return _manufacturerProvider.manufacturerAutoComplete(
                    searchText: pattern,
                  );
                },
                onSelected: (value) {
                  _manufacturerTextEditingController.clear();
                  setState(() {
                    _selectedManufacturerList.add(value);
                    arguments['inventory'] = '';
                    arguments['inventoryList'] = '';
                    arguments['manufacturerList'] = '';
                    arguments['manufacturer'] = '';
                    arguments['section'] = '';
                    arguments['sectionList'] = '';
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      ..._selectedManufacturerList
                          .map(
                            (e) => Chip(
                              label: Text(
                                e['name'],
                              ),
                              labelStyle: Theme.of(context).textTheme.button,
                              backgroundColor: Theme.of(context).primaryColor,
                              deleteIcon: Icon(Icons.clear),
                              deleteIconColor:
                                  Theme.of(context).textTheme.button.color,
                              onDeleted: () {
                                setState(
                                  () {
                                    _selectedManufacturerList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedManufacturerIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedManufacturerList.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stockAnalysisFormSectionContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'SECTION INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              AutocompleteFormField(
                autoFocus: false,
                focusNode: _sectionFocusNode,
                controller: _sectionTextEditingController,
                labelText: 'Section',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                validator: (_) {
                  return null;
                },
                onSaved: (_) {
                  _getSelectedSectionList();
                },
                autocompleteCallback: (pattern) async {
                  return _sectionProvider.sectionAutoComplete(
                    searchText: pattern,
                  );
                },
                onSelected: (value) {
                  _sectionTextEditingController.clear();
                  setState(() {
                    _selectedSectionList.add(value);
                    arguments['inventory'] = '';
                    arguments['inventoryList'] = '';
                    arguments['manufacturerList'] = '';
                    arguments['manufacturer'] = '';
                    arguments['section'] = '';
                    arguments['sectionList'] = '';
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      ..._selectedSectionList
                          .map(
                            (e) => Chip(
                              label: Text(
                                e['name'],
                              ),
                              labelStyle: Theme.of(context).textTheme.button,
                              backgroundColor: Theme.of(context).primaryColor,
                              deleteIcon: Icon(Icons.clear),
                              deleteIconColor:
                                  Theme.of(context).textTheme.button.color,
                              onDeleted: () {
                                setState(
                                  () {
                                    _selectedSectionList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedSectionIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedSectionList.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stockAnalysisFormInventoryContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'INVENTORY INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              AutocompleteFormField(
                autoFocus: false,
                focusNode: _inventoryFocusNode,
                controller: _inventoryTextEditingController,
                labelText: 'Inventory',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                validator: (_) {
                  return null;
                },
                onSaved: (_) {
                  _getSelectedInventoryList();
                },
                autocompleteCallback: (pattern) async {
                  return _inventoryItemProvider.inventoryItemAutoComplete(
                    searchText: pattern,
                    inventoryHeads: _rptInventoryHeads,
                  );
                },
                onSelected: (value) {
                  _inventoryTextEditingController.clear();
                  setState(() {
                    _selectedInventoryList.add(value);
                    arguments['inventory'] = '';
                    arguments['inventoryList'] = '';
                    arguments['manufacturerList'] = '';
                    arguments['manufacturer'] = '';
                    arguments['section'] = '';
                    arguments['sectionList'] = '';
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      ..._selectedInventoryList
                          .map(
                            (e) => Chip(
                              label: Text(
                                e['name'],
                              ),
                              labelStyle: Theme.of(context).textTheme.button,
                              backgroundColor: Theme.of(context).primaryColor,
                              deleteIcon: Icon(Icons.clear),
                              deleteIconColor:
                                  Theme.of(context).textTheme.button.color,
                              onDeleted: () {
                                setState(
                                  () {
                                    _selectedInventoryList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _selectedInventoryIdList.remove(e['id']);
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
                visible: _selectedInventoryList.isNotEmpty,
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
        title: Text(
          'Stock Analysis',
        ),
        actions: [
          TextButton(
            onPressed: () => _onSearch(),
            child: Text(
              'SEARCH',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _stockAnalysisFormGeneralInfoContainer(),
                Visibility(
                  child: _stockAnalysisFormInventoryContainer(),
                  visible:
                      _stockAnalysisGroupBy == StockAnalysisGroupBy.Inventory,
                ),
                Visibility(
                  child: _stockAnalysisFormManufacturerContainer(),
                  visible: _stockAnalysisGroupBy ==
                      StockAnalysisGroupBy.Manufacturer,
                ),
                Visibility(
                  child: _stockAnalysisFormSectionContainer(),
                  visible:
                      _stockAnalysisGroupBy == StockAnalysisGroupBy.Section,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
