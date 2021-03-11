import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

Future<dynamic> showInventoryHeadForm({
  BuildContext screenContext,
}) {
  return showModalBottomSheet(
    context: screenContext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return Container(
        height: MediaQuery.of(screenContext).size.height * 0.89,
        child: InventoryHeadFormScreen(
          screenContext,
        ),
      );
    },
  );
}

class InventoryHeadFormScreen extends StatefulWidget {
  final BuildContext _screenContext;
  InventoryHeadFormScreen(
    this._screenContext,
  );
  @override
  _InventoryHeadFormScreenState createState() =>
      _InventoryHeadFormScreenState();
}

class _InventoryHeadFormScreenState extends State<InventoryHeadFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BranchProvider _branchProvider;
  List _inventoryHeadList = [];
  Map<String, List> _inventoryHeads = {};
  TextEditingController _inventoryHeadController = TextEditingController();
  bool _isloading = true;
  String inventoryHeadId = '';

  @override
  void didChangeDependencies() {
    _branchProvider = Provider.of<BranchProvider>(context);
    _getInventoryHeadList();
    super.didChangeDependencies();
  }

  Future<List> _getInventoryHeadList() async {
    if (_inventoryHeadList.isEmpty) {
      _inventoryHeadList = await _branchProvider.getInventoryHead();
    }
    setState(() {
      _isloading = false;
    });
    return _inventoryHeadList;
  }

  void _addInventoryHead(String id, String name) {
    _inventoryHeadList.removeWhere((element) => element['id'] == id);
    Map<String, String> map = {};
    id.isEmpty
        ? map.addAll({'name': name.trim()})
        : map.addAll({'id': id, 'name': name.trim()});
    setState(() {
      _inventoryHeadList.addAll({map});
      inventoryHeadId = '';
    });
  }

  Future<void> _onSubmit() async {
    try {
      _inventoryHeads.addAll({'inventoryHeads': _inventoryHeadList});
      await _branchProvider.createInventoryHead(_inventoryHeads);
      Navigator.of(context).pop();
      utils.showSuccessSnackbar(
          widget._screenContext, 'Inventory Head Created Successfully');
    } catch (error) {
      Navigator.of(context).pop();
      utils.handleErrorResponse(widget._screenContext, error.message, 'tenant');
    }
  }

  Widget showInventoryHeadList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Wrap(
            spacing: 5.0,
            children: [
              ..._inventoryHeadList
                  .map(
                    (e) => Chip(
                      label: Text(
                        e['name'],
                      ),
                      labelStyle: Theme.of(context).textTheme.button,
                      backgroundColor: Theme.of(context).primaryColor,
                      deleteIcon: Icon(Icons.edit),
                      deleteIconColor: Theme.of(context).textTheme.button.color,
                      onDeleted: () {
                        setState(
                          () {
                            inventoryHeadId = e['id'];
                            _inventoryHeadController.text = e['name'];
                            _inventoryHeadController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: _inventoryHeadController.text.length,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Inventory Head',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _addInventoryHead(
                          inventoryHeadId,
                          _inventoryHeadController.text,
                        );
                        _inventoryHeadController.clear();
                        _onSubmit();
                      }
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 0.0,
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _inventoryHeadController,
                  decoration: InputDecoration(
                    labelText: 'Inventory Head',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _addInventoryHead(
                            inventoryHeadId,
                            _inventoryHeadController.text,
                          );
                          _inventoryHeadController.clear();
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Inventory Head should not be empty!';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: _isloading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : showInventoryHeadList(),
            ),
          ],
        ),
      ),
    );
  }
}
