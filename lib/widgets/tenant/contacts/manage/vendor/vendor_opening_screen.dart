import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/vendor_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class VendorOpeningScreen extends StatefulWidget {
  @override
  _VendorOpeningScreenState createState() => _VendorOpeningScreenState();
}

class _VendorOpeningScreenState extends State<VendorOpeningScreen> {
  BuildContext _screenContext;
  VendorProvider _vendorProvider;
  TenantAuth _tenantAuth;
  String vendorId = '';
  String vendorName = '';
  String branchId = '';
  String branchName = '';
  bool _isLoading = true;
  List _vendorOpeningList = [];
  Map arguments = {};
  Map selectedBranch = {};

  @override
  void didChangeDependencies() {
    _vendorProvider = Provider.of<VendorProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    vendorId = arguments['id'];
    vendorName = arguments['displayName'];
    _getVendorOpening();
    super.didChangeDependencies();
  }

  Future<List> _getVendorOpening() async {
    selectedBranch = _tenantAuth.selectedBranch;
    branchId = selectedBranch['id'];
    branchName = selectedBranch['name'];
    final data = await _vendorProvider.getVendorOpening(branchId, vendorId);
    setState(() {
      _isLoading = false;
      _addVendorOpening(data);
    });
    return _vendorOpeningList;
  }

  void _addVendorOpening(List response) {
    _vendorOpeningList.addAll(
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
        invoices.addAll(_vendorOpeningList.map(
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
        await _vendorProvider.setVendorOpening(
          branchId,
          vendorId,
          invoices,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Vendor Opening added Successfully');
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

  Widget _vendorOpeningFormContainer() {
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
                vendorName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Visibility(
                    child: _vendorOpeningListContainer(),
                    visible: _vendorOpeningList.isNotEmpty,
                  ),
            SizedBox(
              height: 60.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _vendorOpeningListContainer() {
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
                  padding: EdgeInsets.only(right: 60.0),
                  child: Text(
                    'REF.NO',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 60.0),
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
            expandedHeaderPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _vendorOpeningList[panelIndex]['isExpanded'] = !isExpanded;
              });
            },
            children: [
              ..._vendorOpeningList.map(
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
                                  'openingFormName': 'Vendor Opening',
                                  'id': e['id'],
                                  'refNo': e['refNo'],
                                  'effDate': e['effDate'],
                                  'credit': e['credit'],
                                  'debit': e['debit'],
                                  'openingBranch': branchName,
                                  'openingCustomer': vendorName,
                                  'isExpanded': e['isExpanded'],
                                },
                              },
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _vendorOpeningList.removeWhere(
                                        (element) => element['id'] == e['id']);
                                    _vendorOpeningList.addAll({value});
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
                              _vendorOpeningList.removeWhere(
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

  Widget _addVendorOpeningButtonWidget() {
    return Visibility(
      child: SizedBox(
        height: 45,
        child: ElevatedButton.icon(
          label: Text(
            'Add Vendor Opening',
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
                'openingFormName': 'Vendor Opening',
                'refNo': '',
                'effDate': '',
                'credit': '',
                'debit': '',
                'openingBranch': branchName,
                'openingCustomer': vendorName,
              },
            },
          ).then(
            (value) {
              if (value != null) {
                Map data = value;
                setState(() {
                  _vendorOpeningList.removeWhere(
                      (element) => element['id'] == data['id'].toString());
                  _vendorOpeningList.addAll({value});
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
              'Vendor Opening',
            ),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    selectedBranch = value['branchInfo'];
                    branchId = selectedBranch['id'];
                    branchName = selectedBranch['name'];
                    _isLoading = true;
                    _vendorOpeningList.clear();
                  });
                  _getVendorOpening();
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
          return _vendorOpeningFormContainer();
        },
      ),
      floatingActionButton: _addVendorOpeningButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
