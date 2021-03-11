import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/rack_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemAssignRacksScreen extends StatefulWidget {
  @override
  _InventoryItemAssignRacksScreenState createState() =>
      _InventoryItemAssignRacksScreenState();
}

class _InventoryItemAssignRacksScreenState
    extends State<InventoryItemAssignRacksScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  BuildContext _screenContext;
  TextEditingController _rack1TextEditingController = TextEditingController();
  TextEditingController _rack2TextEditingController = TextEditingController();
  TextEditingController _rack3TextEditingController = TextEditingController();
  TextEditingController _rack4TextEditingController = TextEditingController();
  InventoryItemProvider _inventoryItemProvider;
  TenantAuth _tenantAuth;
  RackProvider _rackProvider;
  FocusNode _rack1FocusNode = FocusNode();
  FocusNode _rack2FocusNode = FocusNode();
  FocusNode _rack3FocusNode = FocusNode();
  FocusNode _rack4FocusNode = FocusNode();
  Map arguments = {};
  Map _selectedBranch = {};
  Map _assingedRacksData = {};
  Map<String, dynamic> _assingedRacksDetail = {};
  String inventoryId = '';
  String inventoryName = '';
  String rack1Id = '';
  String rack2Id = '';
  String rack3Id = '';
  String rack4Id = '';

  @override
  void dispose() {
    _rack1FocusNode.dispose();
    _rack2FocusNode.dispose();
    _rack3FocusNode.dispose();
    _rack4FocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _rackProvider = Provider.of<RackProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    _selectedBranch = _tenantAuth.selectedBranch;
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _getAssingedRacks() async {
    _assingedRacksDetail = await _inventoryItemProvider.getAssignedRacks(
      inventoryId,
      _selectedBranch['id'],
    );
    _rack1TextEditingController.text = _assingedRacksDetail['rack1'] == null
        ? _rack1TextEditingController.text
        : _assingedRacksDetail['rack1']['name'];
    _rack2TextEditingController.text = _assingedRacksDetail['rack2'] == null
        ? _rack2TextEditingController.text
        : _assingedRacksDetail['rack2']['name'];
    _rack3TextEditingController.text = _assingedRacksDetail['rack3'] == null
        ? _rack3TextEditingController.text
        : _assingedRacksDetail['rack3']['name'];
    _rack4TextEditingController.text = _assingedRacksDetail['rack4'] == null
        ? _rack4TextEditingController.text
        : _assingedRacksDetail['rack4']['name'];
    return _assingedRacksDetail;
  }

  Future<void> _onSubmit() async {
    if (_selectedBranch['name'] != 'Select Branch') {
      _formKey.currentState.save();
      try {
        _assingedRacksData['branch'] = {
          'id': _selectedBranch['id'],
          'name': _selectedBranch['name'],
        };
        await _inventoryItemProvider.setAssignedRacks(
          inventoryId,
          _selectedBranch['id'],
          _assingedRacksData,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Racks assigned Successfully');
        setState(() {
          _assingedRacksDetail.clear();
        });
        _getAssingedRacks();
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _assignRacksForm() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Text(
                      'GENERAL INFO',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _assingedRacksDetail['rack1'],
                    ),
                    autoFocus: false,
                    focusNode: _rack1FocusNode,
                    controller: _rack1TextEditingController,
                    autocompleteCallback: (pattern) {
                      return _rackProvider.rackAutoComplete(
                        searchText: pattern,
                      );
                    },
                    validator: null,
                    labelText: 'Rack1',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _assingedRacksData['rack1'] = rack1Id.isEmpty
                          ? val == null
                              ? _assingedRacksDetail['rack1']
                              : val['id']
                          : rack1Id;
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/inventory/manage/rack/form',
                          arguments: {
                            'routeForm': 'InventoryAssignRacksToRack',
                            'id': inventoryId,
                            'displayName': inventoryName,
                            'detail': _assingedRacksData,
                            'formInputName': _rack1TextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              rack1Id = arguments['routeFormArguments']['id'];
                              _rack1TextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        ['inventory.rack.create'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _assingedRacksDetail['rack2'],
                    ),
                    autoFocus: false,
                    focusNode: _rack2FocusNode,
                    controller: _rack2TextEditingController,
                    autocompleteCallback: (pattern) {
                      return _rackProvider.rackAutoComplete(
                        searchText: pattern,
                      );
                    },
                    validator: null,
                    labelText: 'Rack2',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _assingedRacksData['rack2'] = rack2Id.isEmpty
                          ? val == null
                              ? _assingedRacksDetail['rack2']
                              : val['id']
                          : rack2Id;
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/inventory/manage/rack/form',
                          arguments: {
                            'routeForm': 'InventoryAssignRacksToRack',
                            'id': inventoryId,
                            'displayName': inventoryName,
                            'detail': _assingedRacksData,
                            'formInputName': _rack2TextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              rack2Id = arguments['routeFormArguments']['id'];
                              _rack2TextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        ['inventory.rack.create'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _assingedRacksDetail['rack3'],
                    ),
                    autoFocus: false,
                    focusNode: _rack3FocusNode,
                    controller: _rack3TextEditingController,
                    autocompleteCallback: (pattern) {
                      return _rackProvider.rackAutoComplete(
                        searchText: pattern,
                      );
                    },
                    validator: null,
                    labelText: 'Rack3',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _assingedRacksData['rack3'] = rack3Id.isEmpty
                          ? val == null
                              ? _assingedRacksDetail['rack3']
                              : val['id']
                          : rack3Id;
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/inventory/manage/rack/form',
                          arguments: {
                            'routeForm': 'InventoryAssignRacksToRack',
                            'id': inventoryId,
                            'displayName': inventoryName,
                            'detail': _assingedRacksData,
                            'formInputName': _rack3TextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              rack3Id = arguments['routeFormArguments']['id'];
                              _rack3TextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        ['inventory.rack.create'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _assingedRacksDetail['rack4'],
                    ),
                    autoFocus: false,
                    focusNode: _rack4FocusNode,
                    controller: _rack4TextEditingController,
                    autocompleteCallback: (pattern) {
                      return _rackProvider.rackAutoComplete(
                        searchText: pattern,
                      );
                    },
                    validator: null,
                    labelText: 'Rack4',
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _assingedRacksData['rack4'] = rack4Id.isEmpty
                          ? val == null
                              ? _assingedRacksDetail['rack4']
                              : val['id']
                          : rack4Id;
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/inventory/manage/rack/form',
                          arguments: {
                            'routeForm': 'InventoryAssignRacksToRack',
                            'id': inventoryId,
                            'displayName': inventoryName,
                            'detail': _assingedRacksData,
                            'formInputName': _rack4TextEditingController.text,
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              arguments = value;
                              rack4Id = arguments['routeFormArguments']['id'];
                              _rack4TextEditingController.text =
                                  arguments['routeFormArguments']['name'];
                            });
                          }
                        }),
                      ),
                      visible: utils.checkMenuWiseAccess(
                        context,
                        ['inventory.rack.create'],
                      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assign Racks'),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBranch = value['branchInfo'];
                    _assingedRacksDetail.clear();
                  });
                  _getAssingedRacks();
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
      body: FutureBuilder(
        future: _getAssingedRacks(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: _assignRacksForm(),
                  ),
                );
        },
      ),
    );
  }
}
