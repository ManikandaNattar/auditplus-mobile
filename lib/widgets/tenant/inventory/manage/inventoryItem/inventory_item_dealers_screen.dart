import 'dart:io';

import 'package:auditplusmobile/providers/inventory/vendor_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemDealersScreen extends StatefulWidget {
  @override
  _InventoryItemDealersScreenState createState() =>
      _InventoryItemDealersScreenState();
}

class _InventoryItemDealersScreenState
    extends State<InventoryItemDealersScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _vendorTextEditingController = TextEditingController();
  FocusNode _vendorFocusNode = FocusNode();
  BuildContext _screenContext;
  InventoryItemProvider _inventoryItemProvider;
  VendorProvider _vendorProvider;
  Map arguments = {};
  List _dealersList = [];
  String inventoryId = '';
  String inventoryName = '';
  String vendorId = '';
  List _selectedVendors = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _vendorProvider = Provider.of<VendorProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    _getDealersList();
    super.didChangeDependencies();
  }

  Future<List> _getDealersList() async {
    final data = await _inventoryItemProvider.getDealers(inventoryId);
    setState(() {
      _isLoading = false;
      _dealersList.addAll(data);
    });
    return _dealersList;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _vendorTextEditingController.clear();
      _formKey.currentState.save();
      Navigator.of(context).pop(
        arguments,
      );
      try {
        await _inventoryItemProvider.setDealers(
          inventoryId,
          vendorId,
        );
        utils.showSuccessSnackbar(_screenContext, 'Dealers added Successfully');
        setState(() {
          _isLoading = true;
          _dealersList.clear();
          vendorId = '';
        });
        _getDealersList();
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Future<void> _onDelete() async {
    if (_selectedVendors.isNotEmpty) {
      try {
        await _inventoryItemProvider.removeDealers(
          inventoryId,
          _selectedVendors,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Dealers removed Successfully');
        setState(() {
          _isLoading = true;
          _dealersList.clear();
          _selectedVendors.clear();
        });
        _getDealersList();
      } on HttpException catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Future<void> _setDealersPreferred() async {
    try {
      await _inventoryItemProvider.setDealersPreferred(
        inventoryId,
        vendorId,
      );
      utils.showSuccessSnackbar(
          _screenContext, 'Dealers Preferred Successfully');
      setState(() {
        _isLoading = true;
        _dealersList.clear();
        vendorId = '';
      });
      _getDealersList();
    } on HttpException catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Widget _dealersListContainer() {
    return ListView(
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
        Divider(
          thickness: 0.5,
        ),
        ..._dealersList.map(
          (e) {
            return Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity(
                    horizontal: 0,
                    vertical: -4,
                  ),
                  title: Text(
                    e['name'],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  subtitle: Text(
                    e['shortName'],
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  leading: Visibility(
                    child: Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    visible: _dealersList[0] == e,
                  ),
                  trailing: Visibility(
                    child: IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: null,
                    ),
                    visible: _selectedVendors.contains(e['id']),
                  ),
                  onTap: () {
                    if (_selectedVendors.isEmpty) {
                      setState(() {
                        vendorId = e['id'];
                      });
                      utils.showAlertDialog(
                        _screenContext,
                        () => _setDealersPreferred(),
                        'SET AS PREFERRED',
                        'Are you sure',
                      );
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      if (_selectedVendors.contains(e['id'])) {
                        _selectedVendors.remove(e['id']);
                      } else {
                        _selectedVendors.add(e['id']);
                      }
                    });
                  },
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            );
          },
        ).toList()
      ],
    );
  }

  Widget _assignVendorButtonWidget() {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        label: Text(
          'Assign Vendor',
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
        onPressed: () => _showAssignVendorBottomSheet(context: _screenContext),
      ),
    );
  }

  Future<dynamic> _showAssignVendorBottomSheet({
    BuildContext context,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: _showVendorAutocompleteForm(),
        );
      },
    );
  }

  Widget _showVendorAutocompleteForm() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: VisualDensity(
              horizontal: 0,
              vertical: -4,
            ),
            contentPadding: EdgeInsets.all(0.0),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Dealers'.toUpperCase(),
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            trailing: TextButton(
              onPressed: () => _onSubmit(),
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Text(
              inventoryName.toUpperCase(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: _formKey,
            child: AutocompleteFormField(
              focusNode: _vendorFocusNode,
              controller: _vendorTextEditingController,
              autocompleteCallback: (pattern) {
                return _vendorProvider.vendorAutoComplete(
                  searchText: pattern,
                );
              },
              validator: (value) {
                if (vendorId.isEmpty && value == null) {
                  return 'Vendor should not be empty!';
                }
                return null;
              },
              labelText: 'Vendor',
              suggestionFormatter: (suggestion) => suggestion['name'],
              textFormatter: (selection) => selection['name'],
              onSaved: (val) {
                setState(() {
                  vendorId = vendorId.isEmpty ? val['id'] : vendorId;
                });
              },
              suffixIconWidget: Visibility(
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(
                    '/inventory/purchase/vendor/form',
                    arguments: {
                      'routeForm': 'InventoryDealersToVendor',
                      'id': inventoryId,
                      'displayName': inventoryName,
                      'detail': _dealersList,
                      'formInputName': _vendorTextEditingController.text,
                    },
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        arguments = value;
                        vendorId = arguments['routeFormArguments']['id'];
                        _vendorTextEditingController.text =
                            arguments['routeFormArguments']['name'];
                      });
                    }
                  }),
                ),
                visible: utils.checkMenuWiseAccess(
                  context,
                  ['inv.vend.cr'],
                ),
              ),
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
        title: Text('Dealers'),
        actions: [
          Visibility(
            child: IconButton(
              onPressed: () => _onDelete(),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            visible: _selectedVendors.isNotEmpty,
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          _screenContext = context;
          return _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _dealersListContainer();
        },
      ),
      floatingActionButton: _assignVendorButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
