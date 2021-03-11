import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/customer_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class CustomerOpeningScreen extends StatefulWidget {
  @override
  _CustomerOpeningScreenState createState() => _CustomerOpeningScreenState();
}

class _CustomerOpeningScreenState extends State<CustomerOpeningScreen> {
  BuildContext _screenContext;
  CustomerProvider _customerProvider;
  TenantAuth _tenantAuth;
  String customerId = '';
  String customerName = '';
  String branchId = '';
  String branchName = '';
  bool _isLoading = true;
  List _customerOpeningList = [];
  Map arguments = {};
  Map selectedBranch = {};

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    customerId = arguments['id'];
    customerName = arguments['displayName'];
    _getCustomerOpening();
    super.didChangeDependencies();
  }

  Future<List> _getCustomerOpening() async {
    selectedBranch = _tenantAuth.selectedBranch;
    branchId = selectedBranch['id'];
    branchName = selectedBranch['name'];
    final data =
        await _customerProvider.getCustomerOpening(branchId, customerId);
    setState(() {
      _isLoading = false;
      _addCustomerOpening(data);
    });
    return _customerOpeningList;
  }

  void _addCustomerOpening(List response) {
    _customerOpeningList.addAll(
      response.map(
        (e) {
          return {
            'isExpanded': false,
            'id': e['id'],
            'effDate': e['effDate'],
            'credit': double.parse('${e['credit']}'),
            'debit': double.parse('${e['debit']}'),
            'refNo': e['refNo'],
          };
        },
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (branchName != 'Select Branch') {
      try {
        List invoices = [];
        invoices.addAll(_customerOpeningList.map(
          (e) {
            return {
              'id': e['id'],
              'effDate': e['effDate'],
              'credit': double.parse('${e['credit']}'),
              'debit': double.parse('${e['debit']}'),
              'refNo': e['refNo'],
            };
          },
        ).toList());
        await _customerProvider.setCustomerOpening(
          branchId,
          customerId,
          invoices,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Customer Opening added Successfully');
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

  Widget _customerOpeningFormContainer() {
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
                customerName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Visibility(
                    child: _customerOpeningListContainer(),
                    visible: _customerOpeningList.isNotEmpty,
                  ),
            SizedBox(
              height: 60.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _customerOpeningListContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'INV.DATE',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 60.0,
                  ),
                  child: Text(
                    'REF.NO',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 60.0,
                  ),
                  child: Text(
                    'AMOUNT',
                    style: Theme.of(context).textTheme.headline4,
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
            expandedHeaderPadding: EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 0.0,
            ),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _customerOpeningList[panelIndex]['isExpanded'] = !isExpanded;
              });
            },
            children: [
              ..._customerOpeningList.map(
                (e) {
                  return ExpansionPanel(
                    headerBuilder: (_, bool isExpanded) {
                      return ListTile(
                        title: Table(
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  constants.defaultDate.format(
                                    DateTime.parse(
                                      e['effDate'],
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.subtitle1,
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    e['refNo'] == null ? '' : e['refNo'],
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Text(
                                  e['credit'] == 0 || e['credit'] == '0'
                                      ? '${double.parse(e['debit'].toString()).toStringAsFixed(2).toString()} Dr'
                                      : '${double.parse(e['credit'].toString()).toStringAsFixed(2).toString()} Cr',
                                  style: Theme.of(context).textTheme.subtitle1,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
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
                              '/contacts/manage/contacts-opening-form',
                              arguments: {
                                'formData': {
                                  'openingFormName': 'Customer Opening',
                                  'id': e['id'],
                                  'refNo': e['refNo'],
                                  'effDate': e['effDate'],
                                  'credit': e['credit'],
                                  'debit': e['debit'],
                                  'openingBranch': branchName,
                                  'openingCustomer': customerName,
                                  'isExpanded': e['isExpanded'],
                                },
                              },
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _customerOpeningList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _customerOpeningList.addAll({value});
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
                              _customerOpeningList.removeWhere(
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

  Widget _addCustomerOpeningButtonWidget() {
    return Visibility(
      child: SizedBox(
        height: 45,
        child: ElevatedButton.icon(
          label: Text(
            'Add Customer Opening',
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
            '/contacts/manage/contacts-opening-form',
            arguments: {
              'formData': {
                'isExpanded': false,
                'openingFormName': 'Customer Opening',
                'refNo': '',
                'effDate': '',
                'credit': '',
                'debit': '',
                'openingBranch': branchName,
                'openingCustomer': customerName,
              },
            },
          ).then(
            (value) {
              if (value != null) {
                Map data = value;
                setState(() {
                  _customerOpeningList.removeWhere(
                      (element) => element['id'] == data['id'].toString());
                  _customerOpeningList.addAll({value});
                });
              }
            },
          ),
        ),
      ),
      visible: branchName != 'Select Branch',
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
              'Customer Opening',
            ),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    selectedBranch = value['branchInfo'];
                    branchId = selectedBranch['id'];
                    branchName = selectedBranch['name'];
                    _isLoading = true;
                    _customerOpeningList.clear();
                  });
                  _getCustomerOpening();
                }
              },
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
          return _customerOpeningFormContainer();
        },
      ),
      floatingActionButton: _addCustomerOpeningButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
