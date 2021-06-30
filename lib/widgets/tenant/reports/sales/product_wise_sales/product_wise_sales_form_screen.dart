import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:auditplusmobile/widgets/shared/date_picker_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../constants.dart' as constants;
import './../../../../../utils.dart' as utils;

class ProductWiseSalesFormScreen extends StatefulWidget {
  @override
  _ProductWiseSalesFormScreenState createState() =>
      _ProductWiseSalesFormScreenState();
}

class _ProductWiseSalesFormScreenState
    extends State<ProductWiseSalesFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _branchFocusNode = FocusNode();
  TextEditingController _fromDateFieldController = TextEditingController();
  TextEditingController _toDateFieldController = TextEditingController();
  TextEditingController _branchTextEditingController = TextEditingController();
  TenantAuth _tenantAuth;
  Map _userSelectedBranch = {};
  Map _selectedBranch = {};
  List<Map<String, dynamic>> _assignedBranches = [];
  List<Map<String, dynamic>> _filterBranches = [];
  Map arguments = {};
  String fromDate = '';
  String toDate = '';

  @override
  void dispose() {
    _branchTextEditingController.dispose();
    _branchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tenantAuth = Provider.of<TenantAuth>(context);
    _userSelectedBranch = _tenantAuth.selectedBranch;
    _assignedBranches = _tenantAuth.assignedBranches;
    arguments = ModalRoute.of(context).settings.arguments;
    _getFormData();
  }

  void _getFormData() {
    _fromDateFieldController.text = _fromDateFieldController.text.isEmpty
        ? arguments['fromDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : arguments['fromDate']
        : _fromDateFieldController.text;
    _toDateFieldController.text = _toDateFieldController.text.isEmpty
        ? arguments['toDate'].toString().isEmpty
            ? constants.defaultDate.format(DateTime.now())
            : arguments['toDate']
        : _toDateFieldController.text;
    _branchTextEditingController.text = arguments['branch'] == ''
        ? _userSelectedBranch['name']
        : arguments['branch']['name'];
    _branchTextEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _branchTextEditingController.text.length,
      ),
    );
  }

  void _onSearch() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map _formData = {
        'fromDate': fromDate,
        'toDate': toDate,
        'branch': _selectedBranch,
      };
      Navigator.of(context).pop(_formData);
    }
  }

  List<Map<String, dynamic>> getBranchList(String query) {
    _filterBranches = [];
    for (int i = 0; i <= _assignedBranches.length - 1; i++) {
      String name = _assignedBranches[i]['name'];
      if (query.isEmpty) {
        _filterBranches.add(_assignedBranches[i]);
      } else {
        if (name
            .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
            .toLowerCase()
            .startsWith(query
                .replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), '')
                .toLowerCase())) {
          _filterBranches.add(_assignedBranches[i]);
        }
      }
    }
    return _filterBranches;
  }

  Widget _productWiseSalesFormDateContainer() {
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
                'DATE INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              DatePickerFormField(
                title: 'From Date',
                controller: _fromDateFieldController,
                onSaved: (value) {
                  fromDate = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              DatePickerFormField(
                title: 'To Date',
                controller: _toDateFieldController,
                onSaved: (value) {
                  toDate = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productWiseSalesFormBranchContainer() {
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
                'BRANCH INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 10.0,
              ),
              AutocompleteFormField(
                initialValue: utils.cast<Map<String, dynamic>>(
                  arguments['branch'] == ''
                      ? _userSelectedBranch
                      : arguments['branch'],
                ),
                autoFocus: false,
                focusNode: _branchFocusNode,
                controller: _branchTextEditingController,
                labelText: 'Branch',
                suggestionFormatter: (suggestion) => suggestion['name'],
                textFormatter: (selection) => selection['name'],
                validator: (value) {
                  if (value == null) {
                    return 'Branch should not be empty!';
                  }
                  return null;
                },
                onSaved: (val) {
                  _selectedBranch = val;
                },
                autocompleteCallback: (pattern) async {
                  return getBranchList(pattern);
                },
                onSelected: (val) {
                  if (val != null) {
                    arguments['branch'] = '';
                  }
                },
              ),
              SizedBox(
                height: 15.0,
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
          'Product wise Sales',
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
                _productWiseSalesFormDateContainer(),
                _productWiseSalesFormBranchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
