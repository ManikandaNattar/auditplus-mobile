import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils.dart' as utils;

class InventoryItemUnitConversionFormScreen extends StatefulWidget {
  @override
  _InventoryItemUnitConversionFormScreenState createState() =>
      _InventoryItemUnitConversionFormScreenState();
}

class _InventoryItemUnitConversionFormScreenState
    extends State<InventoryItemUnitConversionFormScreen> {
  BuildContext _screenContext;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _unitTextEditingController = TextEditingController();
  FocusNode _unitFocusNode = FocusNode();
  FocusNode _conversionFocusNode = FocusNode();
  InventoryItemProvider _inventoryItemProvider;
  UnitProvider _unitProvider;
  String unitId = '';
  Map _unitConversionData = {};
  bool _preferredForPurchase = false;
  bool _preferredForSale = false;
  Map arguments = {};
  String inventoryId = '';
  String inventoryName = '';

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _unitProvider = Provider.of<UnitProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _unitConversionData['preferredForPurchase'] = _preferredForPurchase;
      _unitConversionData['preferredForSale'] = _preferredForSale;
      try {
        await _inventoryItemProvider.setUnitConversion(
          inventoryId,
          _unitConversionData,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Unit conversion added Successfully');
        Future.delayed(Duration(seconds: 1)).then(
          (value) {
            Navigator.of(context).pop(arguments);
          },
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _unitConversionFormContainer() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 0.0,
                ),
                child: Text(
                  inventoryName.toUpperCase(),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                elevation: 10.0,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
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
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            AutocompleteFormField(
                              focusNode: _unitFocusNode,
                              controller: _unitTextEditingController,
                              autocompleteCallback: (pattern) {
                                return _unitProvider.unitAutoComplete(
                                  searchText: pattern,
                                );
                              },
                              validator: (value) {
                                if (unitId.isEmpty && value == null) {
                                  return 'Unit should not be empty!';
                                }
                                return null;
                              },
                              labelText: 'Unit',
                              suggestionFormatter: (suggestion) =>
                                  suggestion['name'],
                              textFormatter: (selection) => selection['name'],
                              onSaved: (val) {
                                _unitConversionData = {
                                  'unit': unitId.isEmpty ? val['id'] : unitId
                                };
                              },
                              suffixIconWidget: Visibility(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pushNamed(
                                    '/inventory/manage/unit/form',
                                    arguments: {
                                      'routeForm':
                                          'InventoryUnitConversionToUnit',
                                      'id': inventoryId,
                                      'displayName': inventoryName,
                                      'detail': _unitConversionData,
                                      'formInputName':
                                          _unitTextEditingController.text,
                                    },
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        arguments = value;
                                        unitId = arguments['routeFormArguments']
                                            ['id'];
                                        _unitTextEditingController.text =
                                            arguments['routeFormArguments']
                                                ['name'];
                                      });
                                    }
                                  }),
                                ),
                                visible: utils.checkMenuWiseAccess(
                                  context,
                                  ['inventory.unit.create'],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              focusNode: _conversionFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Conversion',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.subtitle1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Conversion should not be empty!';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _unitConversionData
                                    .addAll({'conversion': double.parse(val)});
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'This conversion preferred for purchase',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              value: _preferredForPurchase,
                              onChanged: (val) {
                                setState(() {
                                  _preferredForPurchase = val;
                                });
                              },
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'This conversion preferred for sale',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              value: _preferredForSale,
                              onChanged: (val) {
                                setState(() {
                                  _preferredForSale = val;
                                });
                              },
                            ),
                          ],
                        ),
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
        title: Text('Unit Conversion'),
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
        builder: (BuildContext context) {
          _screenContext = context;
          return _unitConversionFormContainer();
        },
      ),
    );
  }
}
