import 'package:auditplusmobile/providers/accounting/cost_category_provider.dart';
import 'package:auditplusmobile/providers/accounting/cost_centre_provider.dart';
import 'package:auditplusmobile/widgets/shared/autocomplete_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CostCentreFormScreen extends StatefulWidget {
  @override
  _CostCentreFormScreenState createState() => _CostCentreFormScreenState();
}

class _CostCentreFormScreenState extends State<CostCentreFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  CostCentreProvider _costCentreProvider;
  CostCategoryProvider _costCategoryProvider;
  String costCentreId = '';
  String costCentreName = '';
  String name = '';
  String categoryId = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _aliasNameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  FocusNode _categoryFocusNode = FocusNode();
  TextEditingController _categoryTextEditingController =
      TextEditingController();
  Map<String, dynamic> _costCentreDetail = {};
  Map arguments = {};
  Map<String, dynamic> _costCentreData = {};

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _categoryFocusNode.dispose();
    _categoryTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _costCentreProvider = Provider.of<CostCentreProvider>(context);
    _costCategoryProvider = Provider.of<CostCategoryProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (arguments['routeForm'] == null) {
        costCentreId = arguments['id'];
        costCentreName = arguments['displayName'];
        _getCostCentre();
      } else {
        name = arguments['formInputName'];
      }
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getCostCentre() {
    _costCentreDetail = arguments['detail'];
    _categoryTextEditingController.text = _costCentreDetail['category'] == null
        ? ''
        : _costCentreDetail['category']['name'];
    return _costCentreDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> responseData = {};
      try {
        if (costCentreId.isEmpty) {
          responseData =
              await _costCentreProvider.createCostCentre(_costCentreData);
          utils.showSuccessSnackbar(
              _screenContext, 'Cost Centre Created Successfully');
        } else {
          await _costCentreProvider.updateCostCentre(
            costCentreId,
            _costCentreData,
          );
          utils.showSuccessSnackbar(
              _screenContext, 'Cost Centre updated Successfully');
        }
        if (arguments == null || arguments['routeForm'] == null) {
          Navigator.of(_screenContext)
              .pushReplacementNamed('/accounts/manage/cost-centre');
        } else {
          arguments['routeFormArguments'] = responseData;
          Navigator.of(_screenContext).pop(
            arguments,
          );
        }
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _costCentreFormGeneralInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                'GENERAL INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue:
                        name.isEmpty ? _costCentreDetail['name'] : name,
                    focusNode: _nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _nameFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_aliasNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _costCentreData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _costCentreDetail['aliasName']
                        .toString()
                        .replaceAll('null', ''),
                    focusNode: _aliasNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Alias Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _aliasNameFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _costCentreData.addAll({'aliasName': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _costCentreDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _displayNameFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_categoryFocusNode);
                    },
                    onSaved: (val) {
                      _costCentreData.addAll({
                        'displayName':
                            val.isEmpty ? _costCentreData['name'] : val
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AutocompleteFormField(
                    initialValue: utils.cast<Map<String, dynamic>>(
                      _costCentreDetail['category'],
                    ),
                    focusNode: _categoryFocusNode,
                    controller: _categoryTextEditingController,
                    autocompleteCallback: (pattern) {
                      return _costCategoryProvider.costCategoryAutocomplete(
                        searchText: pattern,
                      );
                    },
                    validator: (val) {
                      if (categoryId.isEmpty && val == null) {
                        return 'Cost Category should not be empty!';
                      }
                      return null;
                    },
                    labelText: 'Cost Category',
                    labelStyle: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                    suggestionFormatter: (suggestion) => suggestion['name'],
                    textFormatter: (selection) => selection['name'],
                    onSaved: (val) {
                      _costCentreData.addAll(
                        {
                          'category': categoryId.isEmpty
                              ? val == null
                                  ? null
                                  : val['id']
                              : categoryId
                        },
                      );
                    },
                    suffixIconWidget: Visibility(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/accounts/manage/cost-category/form',
                            arguments: {
                              'routeForm': 'CostCentreToCostCategory',
                              'id': costCentreId,
                              'displayName': costCentreName,
                              'detail': _costCentreData,
                              'formInputName':
                                  _categoryTextEditingController.text,
                            },
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                Map data = value;
                                categoryId = data['routeFormArguments']['id'];
                                _categoryTextEditingController.text =
                                    data['routeFormArguments']['name'];
                              });
                            }
                          });
                        },
                      ),
                    ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            costCentreName.isEmpty ? 'Add Cost Centre' : costCentreName,
          ),
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
          builder: (context) {
            _screenContext = context;
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _costCentreFormGeneralInfoContainer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      onWillPop: () async {
        utils.showAlertDialog(
          context,
          () => Navigator.of(context).pop(),
          'Discard Changes?',
          'Changes will be discarded once you leave this page',
        );
        return true;
      },
    );
  }
}
