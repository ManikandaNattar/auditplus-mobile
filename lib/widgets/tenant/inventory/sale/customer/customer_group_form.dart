import 'package:auditplusmobile/providers/inventory/customer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

Future<dynamic> showCustomerGroupForm({
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
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: CustomerGroupForm(screenContext),
      );
    },
  );
}

class CustomerGroupForm extends StatefulWidget {
  final BuildContext _screenContext;
  CustomerGroupForm(this._screenContext);
  @override
  _CustomerGroupFormState createState() => _CustomerGroupFormState();
}

class _CustomerGroupFormState extends State<CustomerGroupForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CustomerProvider _customerProvider;
  List _customerGroupList = [];
  Map<String, List> _customerGroups = {};
  TextEditingController _customerGroupController = TextEditingController();
  bool _isloading = true;
  String customerGroupId = '';

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _getCustomerGroupList();
    super.didChangeDependencies();
  }

  Future<List> _getCustomerGroupList() async {
    if (_customerGroupList.isEmpty) {
      _customerGroupList = await _customerProvider.getCustomerGroup();
    }
    setState(() {
      _isloading = false;
    });
    return _customerGroupList;
  }

  void _addCustomerGroup(String id, String name) {
    _customerGroupList.removeWhere((element) => element['id'] == id);
    Map<String, String> map = {};
    id.isEmpty
        ? map.addAll({'name': name.trim()})
        : map.addAll({'id': id, 'name': name.trim()});
    setState(() {
      _customerGroupList.addAll({map});
      customerGroupId = '';
    });
  }

  Future<void> _onSubmit() async {
    try {
      _customerGroups.addAll({'customerGroups': _customerGroupList});
      await _customerProvider.createCustomerGroup(_customerGroups);
      Navigator.of(context).pop();
      utils.showSuccessSnackbar(
          widget._screenContext, 'Customer Group Created Successfully');
    } catch (error) {
      Navigator.of(context).pop();
      utils.handleErrorResponse(widget._screenContext, error.message, 'tenant');
    }
  }

  Widget showCustomerGroupList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Wrap(
            spacing: 5.0,
            children: [
              ..._customerGroupList
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
                            customerGroupId = e['id'];
                            _customerGroupController.text = e['name'];
                            _customerGroupController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: _customerGroupController.text.length,
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
                        'Customer Group',
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
                        _addCustomerGroup(
                          customerGroupId,
                          _customerGroupController.text,
                        );
                        _customerGroupController.clear();
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
                  controller: _customerGroupController,
                  decoration: InputDecoration(
                    labelText: 'Customer Group',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _addCustomerGroup(
                            customerGroupId,
                            _customerGroupController.text,
                          );
                          _customerGroupController.clear();
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Customer Group should not be empty!';
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
                  : showCustomerGroupList(),
            ),
          ],
        ),
      ),
    );
  }
}
