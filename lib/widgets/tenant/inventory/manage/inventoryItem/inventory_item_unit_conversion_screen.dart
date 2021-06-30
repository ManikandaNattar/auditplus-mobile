import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils.dart' as utils;

class InventoryItemUnitConversionScreen extends StatefulWidget {
  @override
  _InventoryItemUnitConversionScreenState createState() =>
      _InventoryItemUnitConversionScreenState();
}

class _InventoryItemUnitConversionScreenState
    extends State<InventoryItemUnitConversionScreen> {
  BuildContext _screenContext;
  bool _isLoading = true;
  InventoryItemProvider _inventoryItemProvider;
  List _unitConversionList = [];
  Map arguments = {};
  Map _unitConversionData = {};
  String inventoryId = '';
  String inventoryName = '';
  bool _preferredChanged = false;
  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    _getUnitConversionList();
    super.didChangeDependencies();
  }

  Future<List> _getUnitConversionList() async {
    final data = await _inventoryItemProvider.getUnitConversion(inventoryId);
    setState(() {
      _isLoading = false;
      _addUnitConversion(data);
    });
    return _unitConversionList;
  }

  void _addUnitConversion(List response) {
    _unitConversionList.addAll(
      response.map(
        (e) {
          return {
            'isExpanded': false,
            'id': e['id'],
            'conversion': e['conversion'],
            'preferredForPurchase': e['preferredForPurchase'],
            'preferredForSale': e['preferredForSale'],
            'primary': e['primary'],
            'unitName': e['unitName'],
            'unitId': e['unitId']
          };
        },
      ),
    );
  }

  Future<void> _setUnitConversionPreferred() async {
    try {
      await _inventoryItemProvider.setUnitConversion(
        inventoryId,
        _unitConversionData,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Unit conversion added Successfully');
      Future.delayed(Duration(seconds: 1)).then(
        (value) {
          setState(() {
            _isLoading = true;
            _unitConversionList.clear();
            _unitConversionData.clear();
            _preferredChanged = false;
          });
          _getUnitConversionList();
        },
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Future<void> _deleteUnitConversionPreferred(int unitConversion) async {
    try {
      await _inventoryItemProvider.deleteUnitConversion(
        inventoryId,
        unitConversion,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Unit conversion removed Successfully');
      Future.delayed(Duration(seconds: 1)).then(
        (value) {
          setState(() {
            _isLoading = true;
            _unitConversionList.clear();
            _unitConversionData.clear();
            _preferredChanged = false;
          });
          _getUnitConversionList();
        },
      );
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _checkAlreadyExpanded(int listIndex) {
    for (int i = 0; i <= _unitConversionList.length - 1; i++) {
      final isExpanded = _unitConversionList[i]['isExpanded'];
      if (i != listIndex && isExpanded == true) {
        setState(() {
          _unitConversionList[i]['isExpanded'] = false;
        });
      }
    }
  }

  Widget _unitConversionListContainer(List data) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
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
                inventoryName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ExpansionPanelList(
              expandedHeaderPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              expansionCallback: (panelIndex, isExpanded) {
                _checkAlreadyExpanded(panelIndex);
                setState(() {
                  _unitConversionList[panelIndex]['isExpanded'] = !isExpanded;
                });
              },
              children: [
                ...data.map(
                  (e) {
                    return ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (_, bool isExpanded) {
                        return ListTile(
                          visualDensity: VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                          title: Text(
                            e['unitName'] == null ? '' : e['unitName'],
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          subtitle: Text(
                            e['conversion'].toString(),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        );
                      },
                      body: Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Preferred For Purchase',
                                style: TextStyle(fontSize: 13),
                              ),
                              value: e['preferredForPurchase'],
                              onChanged: (val) {
                                setState(() {
                                  _preferredChanged = true;
                                  e['preferredForPurchase'] = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Preferred For Sale',
                                style: TextStyle(fontSize: 13),
                              ),
                              value: e['preferredForSale'],
                              onChanged: (val) {
                                setState(() {
                                  _preferredChanged = true;
                                  e['preferredForSale'] = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (_preferredChanged) {
                                _unitConversionData = {
                                  'unit': e['unitId'],
                                  'conversion': e['conversion'],
                                  'preferredForPurchase':
                                      e['preferredForPurchase'],
                                  'preferredForSale': e['preferredForSale'],
                                };
                                _setUnitConversionPreferred();
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () {
                              _deleteUnitConversionPreferred(e['conversion']);
                            },
                          )
                        ],
                      ),
                      isExpanded: e['isExpanded'],
                    );
                  },
                ).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _addUnitConversionButtonWidget() {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        label: Text(
          'Add Unit Conversion',
          style: Theme.of(context).textTheme.button,
        ),
        icon: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: () => Navigator.of(context)
            .pushNamed(
          '/inventory/manage/inventory-item/unit-conversion/form',
          arguments: arguments,
        )
            .then((value) {
          if (value != null) {
            setState(() {
              _isLoading = true;
              _unitConversionList.clear();
            });
            _getUnitConversionList();
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Conversion'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _screenContext = context;
          return _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _unitConversionListContainer(_unitConversionList);
        },
      ),
      floatingActionButton: _addUnitConversionButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
