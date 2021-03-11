import 'package:auditplusmobile/providers/administration/preference_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemOpeningScreen extends StatefulWidget {
  @override
  _InventoryItemOpeningScreenState createState() =>
      _InventoryItemOpeningScreenState();
}

class _InventoryItemOpeningScreenState
    extends State<InventoryItemOpeningScreen> {
  BuildContext _screenContext;
  InventoryItemProvider _inventoryItemProvider;
  PreferenceProvider _preferenceProvider;
  TenantAuth _tenantAuth;
  String inventoryId = '';
  String inventoryName = '';
  Map _selectedBranch = {};
  List _inventoryOpeningList = [];
  bool _isLoading = true;
  Map arguments = {};
  Map<String, dynamic> _preferenceData = {};

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _preferenceProvider = Provider.of<PreferenceProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    _getInventoryOpening();
    super.didChangeDependencies();
  }

  Future<List> _getInventoryOpening() async {
    try {
      _selectedBranch = _tenantAuth.selectedBranch;
      final data = await _inventoryItemProvider.getInventoryOpening(
        inventoryId,
        _selectedBranch['id'],
      );
      final preference = await _preferenceProvider.getInventoryPreference(
        _selectedBranch['id'],
      );
      setState(() {
        _isLoading = false;
        _addInventoryOpening(data);
        _preferenceData.addAll(preference);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        return [];
      });
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
    return _inventoryOpeningList;
  }

  void _addInventoryOpening(List response) {
    _inventoryOpeningList.addAll(
      response.map(
        (e) {
          return {
            'isExpanded': false,
            'id': e['id'],
            'batchNo': e['batchNo'],
            'mrp': double.parse('${e['mrp']}'),
            'pRate': double.parse('${e['pRate']}'),
            'sRate': double.parse('${e['sRate']}'),
            'expMonth': e['expMonth'],
            'expYear': e['expYear'],
            'unitPrecision':
                e['unitPrecision'] == null ? 0 : e['unitPrecision'],
            'unit': e['unit'],
            'qty': e['qty'],
          };
        },
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_selectedBranch['name'] != 'Select Branch') {
      try {
        List invoices = [];
        invoices.addAll(_inventoryOpeningList.map(
          (e) {
            return {
              'id': e['id'].toString().isEmpty ? null : e['id'],
              'batchNo': e['batchNo'],
              'mrp': double.parse('${e['mrp']}'),
              'pRate': double.parse('${e['pRate']}'),
              'sRate': double.parse('${e['sRate']}'),
              'expMonth': e['expMonth'] == null || e['expMonth'] == ''
                  ? null
                  : int.parse(e['expMonth'].toString()),
              'expYear': e['expYear'] == null || e['expYear'] == ''
                  ? null
                  : int.parse(e['expYear'].toString()),
              'unitPrecision': e['unitPrecision'],
              'unit': e['unit']['id'],
              'qty': double.parse(e['qty'].toString()),
            };
          },
        ).toList());
        await _inventoryItemProvider.setInventoryOpening(
          inventoryId,
          _selectedBranch['id'],
          invoices,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Inventory Opening added Successfully');
        Future.delayed(Duration(seconds: 1)).then(
          (value) => Navigator.of(context).pop(
            arguments,
          ),
        );
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _inventoryOpeningContainer() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 4.0,
              ),
              child: Text(
                inventoryName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Visibility(
                    child: _inventoryOpeningListContainer(),
                    visible: _inventoryOpeningList.isNotEmpty,
                  ),
            SizedBox(
              height: 60.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _inventoryOpeningListContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              16.0,
              4.0,
              70.0,
              4.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BATCH',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      'QUANTITY',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      'UNIT',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'S.RATE',
                        style: Theme.of(context).textTheme.headline4,
                        children: [
                          TextSpan(
                            text: '(TAX INCL)',
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                _preferenceData['enableExp'] == true &&
                        _preferenceData['expRequired'] == true
                    ? Container(
                        padding: EdgeInsets.fromLTRB(
                          10.0,
                          4.0,
                          15.0,
                          4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'EXPIRY',
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                    text: '(MM/YYYY)',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'P.RATE',
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                    text: '(TAX EXCL)',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'MRP',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(
                          10.0,
                          4.0,
                          15.0,
                          4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'P.RATE',
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                    text: '(TAX EXCL)',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: 20.0,
                              ),
                              child: Text(
                                'MRP',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ExpansionPanelList(
            elevation: 1,
            expandedHeaderPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _inventoryOpeningList[panelIndex]['isExpanded'] = !isExpanded;
              });
            },
            children: [
              ..._inventoryOpeningList.map(
                (e) {
                  return ExpansionPanel(
                    headerBuilder: (_, bool isExpanded) {
                      return ListTile(
                        title: Column(
                          children: [
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    Text(
                                      e['batchNo'] == null ? '' : e['batchNo'],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                      ),
                                      child: Text(
                                        e['qty'] == null
                                            ? ''
                                            : double.parse(e['qty'].toString())
                                                .toStringAsFixed(
                                                  e['unitPrecision'].round(),
                                                )
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    Text(
                                      e['unit'] == null
                                          ? ''
                                          : e['unit']['name'],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      e['sRate'] == null
                                          ? ''
                                          : double.parse(e['sRate'].toString())
                                              .toStringAsFixed(2)
                                              .toString(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.end,
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
                                _preferenceData['enableExp'] == true &&
                                        _preferenceData['expRequired'] == true
                                    ? TableRow(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              e['expMonth'] == null &&
                                                      e['expYear'] == null
                                                  ? ''
                                                  : e['expMonth'].toString() +
                                                      '/' +
                                                      e['expYear'].toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Text(
                                              e['pRate'] == null
                                                  ? ''
                                                  : double.parse(
                                                          e['pRate'].toString())
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 10.0,
                                            ),
                                            child: Text(
                                              e['mrp'] == null
                                                  ? ''
                                                  : double.parse(
                                                          e['mrp'].toString())
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        ],
                                      )
                                    : TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 20.0,
                                            ),
                                            child: Text(
                                              e['pRate'] == null
                                                  ? ''
                                                  : double.parse(
                                                          e['pRate'].toString())
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 20.0,
                                            ),
                                            child: Text(
                                              e['mrp'] == null
                                                  ? ''
                                                  : double.parse(
                                                          e['mrp'].toString())
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        ],
                                      ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              e['isExpanded'] = false;
                            });
                            Navigator.of(context).pushNamed(
                              '/inventory/manage/inventory-item/opening/form',
                              arguments: {
                                'formData': {
                                  'isExpanded': e['isExpanded'],
                                  'id': e['id'],
                                  'batchNo': e['batchNo'],
                                  'mrp': e['mrp'],
                                  'pRate': e['pRate'],
                                  'sRate': e['sRate'],
                                  'expMonth': e['expMonth'],
                                  'expYear': e['expYear'],
                                  'unitPrecision': e['unitPrecision'],
                                  'unit': e['unit'],
                                  'qty': e['qty'],
                                  'inventoryName': inventoryName,
                                  'inventoryId': inventoryId,
                                  'branch': _selectedBranch,
                                },
                              },
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _inventoryOpeningList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _inventoryOpeningList.addAll({value});
                                  });
                                }
                              },
                            );
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _inventoryOpeningList.removeWhere(
                                  (element) => element['id'] == e['id']);
                            });
                          },
                          color: Theme.of(context).primaryColor,
                        ),
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
    );
  }

  Widget _addInventoryOpeningButtonWidget() {
    return Visibility(
      child: SizedBox(
        height: 45,
        child: ElevatedButton.icon(
          label: Text(
            'Add Inventory Opening',
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
          onPressed: () => Navigator.of(context).pushNamed(
            '/inventory/manage/inventory-item/opening/form',
            arguments: {
              'formData': {
                'isExpanded': false,
                'id': '',
                'batchNo': '',
                'mrp': '',
                'pRate': '',
                'sRate': '',
                'expMonth': '',
                'expYear': '',
                'unitPrecision': '',
                'unit': '',
                'qty': '',
                'inventoryName': inventoryName,
                'inventoryId': inventoryId,
                'branch': _selectedBranch,
              },
            },
          ).then(
            (value) {
              if (value != null) {
                Map data = value;
                setState(() {
                  _inventoryOpeningList
                      .removeWhere((element) => element['id'] == data['id']);
                  _inventoryOpeningList.addAll({data});
                });
              }
            },
          ),
        ),
      ),
      visible: _selectedBranch['name'] != 'Select Branch',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Opening',
            ),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBranch = value['branchInfo'];
                    _isLoading = true;
                    _inventoryOpeningList.clear();
                  });
                  _getInventoryOpening();
                }
              },
              inventoryHead: _selectedBranch['inventoryHead'],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _onSubmit(),
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
          return _inventoryOpeningContainer();
        },
      ),
      floatingActionButton: _addInventoryOpeningButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
