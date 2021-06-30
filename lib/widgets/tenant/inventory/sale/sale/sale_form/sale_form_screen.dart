import 'package:auditplusmobile/providers/administration/warehouse_provider.dart';
// import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/inventory/customer_provider.dart';
import 'package:auditplusmobile/providers/inventory/doctor_provider.dart';
// import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/providers/inventory/sale_incharge_provider.dart';
// import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
// import 'package:auditplusmobile/providers/tax/tax_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../utils.dart' as utils;
import '../../../../../../constants.dart' as constants;

class SaleFormScreen extends StatefulWidget {
  @override
  _SaleFormScreenState createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  WarehouseProvider _warehouseProvider;
  CustomerProvider _customerProvider;
  DoctorProvider _doctorProvider;
  SaleInchargeProvider _saleInchargeProvider;
  // UnitProvider _unitProvider;
  // TaxProvider _taxProvider;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController _warehosueController = TextEditingController();
  TextEditingController _patientController = TextEditingController();
  TextEditingController _doctorController = TextEditingController();
  TextEditingController _inchargeController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  // TextEditingController _inventoryController = TextEditingController();
  // TextEditingController _unitController = TextEditingController();
  // TextEditingController _taxController = TextEditingController();
  // InventoryItemProvider _inventoryItemProvider;
  // TenantAuth _tenantAuth;
  // Map _selectedBranch = {};
  // List _selectedBatches = [];
  // List _taxList = [];
  // List _filterTaxList = [];
  // bool _removeIconVisibility = false;
  // int _rowCount = 1;
  List _saleItemList = [];

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _warehouseProvider = Provider.of<WarehouseProvider>(context);
    _doctorProvider = Provider.of<DoctorProvider>(context);
    _saleInchargeProvider = Provider.of<SaleInchargeProvider>(context);
    // _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    // _tenantAuth = Provider.of<TenantAuth>(context);
    // _selectedBranch = _tenantAuth.selectedBranch;
    // _unitProvider = Provider.of<UnitProvider>(context);
    // _taxProvider = Provider.of<TaxProvider>(context);
    if (_saleItemList.isEmpty) {
      _saleItemList = [
        {'id': 0},
      ];
    }
    super.didChangeDependencies();
  }

  // Future<List> _getTaxList(String query) async {
  //   _filterTaxList.clear();
  //   if (_taxList.isEmpty) {
  //     _taxList = await _taxProvider.taxAutoComplete();
  //   }
  //   if (query.toString().isNotEmpty) {
  //     for (int i = 0; i <= _taxList.length - 1; i++) {
  //       String name = _taxList[i]['displayName'];
  //       if (name
  //           .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase())) {
  //         _filterTaxList.add(_taxList[i]);
  //       }
  //     }
  //   } else {
  //     _filterTaxList = _taxList;
  //   }
  //   return _filterTaxList;
  // }

  Widget _otherInfoForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
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
                        'Other Info',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _refNoController,
                      decoration: InputDecoration(
                        labelText: 'Ref.No',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.subtitle1,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) {
                        if (val.isNotEmpty) {}
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      controller: _warehosueController,
                      autoFocus: false,
                      autocompleteCallback: (pattern) {
                        return _warehouseProvider.warehouseAutoComplete(
                            searchText: pattern);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Warehouse should not be empty!';
                        }
                        return null;
                      },
                      labelText: 'Warehouse',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {},
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      autoFocus: false,
                      controller: _inchargeController,
                      autocompleteCallback: (pattern) {
                        return _saleInchargeProvider.salesInchargeAutoComplete(
                            searchText: pattern);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Incharge should not be empty!';
                        }
                        return null;
                      },
                      labelText: 'Incharge',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {},
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      autoFocus: false,
                      controller: _customerController,
                      autocompleteCallback: (pattern) {
                        return _customerProvider.customerAutoComplete(
                            searchText: pattern);
                      },
                      validator: null,
                      labelText: 'Customer',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {
                        // _patientData.addAll(
                        //   {
                        //     'customer':
                        //         customerId.isEmpty ? val['id'] : customerId
                        //   },
                        // );
                      },
                      suffixIconWidget: Visibility(
                        child: IconButton(
                          padding: EdgeInsets.only(top: 8.0),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            '/inventory/sale/customer/form',
                            arguments: {
                              // 'routeForm': 'PatientToCustomer',
                              // 'id': patientId,
                              // 'displayName': patientName,
                              // 'detail': _patientData,
                              'formInputName': _customerController.text,
                            },
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                // arguments = value;
                                // customerId =
                                //     arguments['routeFormArguments']['id'];
                                // _customerTextEditingController.text =
                                //     arguments['routeFormArguments']['name'];
                              });
                            }
                          }),
                        ),
                        visible: utils.checkMenuWiseAccess(
                          context,
                          ['inv.cus.cr'],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _patientController,
                      decoration: InputDecoration(
                        labelText: 'Patient',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.subtitle1,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) {
                        if (val.isNotEmpty) {}
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    AutocompleteFormField(
                      autoFocus: false,
                      controller: _doctorController,
                      autocompleteCallback: (pattern) {
                        return _doctorProvider.doctorAutoComplete(
                          searchText: pattern,
                        );
                      },
                      validator: null,
                      labelText: 'Doctor',
                      suggestionFormatter: (suggestion) => suggestion['name'],
                      textFormatter: (selection) => selection['name'],
                      onSaved: (val) {},
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context).textTheme.subtitle1,
                      onSaved: (val) {},
                      maxLines: null,
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
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateController.text.isEmpty
          ? DateTime.now()
          : constants.defaultDate.parse(_dateController.text),
      firstDate: constants.firstDate,
      lastDate: constants.lastDate,
    ).then((result) {
      if (result == null) {
        return;
      }
      setState(() {
        _dateController.text = constants.defaultDate.format(result);
      });
    });
  }

  Widget _saleFormHeaderWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    _dateController.text.isEmpty
                        ? constants.defaultDate.format(DateTime.now())
                        : _dateController.text,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => _showDatePicker(),
              )
            ],
          ),
          TextButton.icon(
            onPressed: () => _otherInfoBottomSheet(context: context),
            icon: Icon(
              Icons.add,
              color: Colors.blue,
              size: 16.0,
            ),
            label: Text(
              'Other Info',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.blue,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _otherInfoBottomSheet({
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
          child: _otherInfoForm(),
        );
      },
    );
  }

  Widget _addInventoryItemButtonWidget() {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        label: Text(
          'Add Items',
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
        onPressed: () {
          Navigator.of(context).pushNamed('/inventory/sale/item/form');
        },
      ),
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
              'Add Sale',
            ),
            Row(
              children: [
                AppBarBranchSelection(
                  selectedBranch: (value) {
                    if (value != null) {
                      setState(() {
                        // _selectedBranch = value['branchInfo'];
                        _saleItemList.clear();
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _saleFormHeaderWidget(),
              Divider(
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _addInventoryItemButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
