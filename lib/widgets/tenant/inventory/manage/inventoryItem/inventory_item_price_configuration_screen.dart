import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/providers/contacts/customer_provider.dart';
import 'package:auditplusmobile/providers/inventory/inventory_item_provider.dart';
import 'package:auditplusmobile/widgets/shared/app_bar_branch_selection.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class InventoryItemPriceConfigurationScreen extends StatefulWidget {
  @override
  _InventoryItemPriceConfigurationScreenState createState() =>
      _InventoryItemPriceConfigurationScreenState();
}

class _InventoryItemPriceConfigurationScreenState
    extends State<InventoryItemPriceConfigurationScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey();
  BuildContext _screenContext;
  InventoryItemProvider _inventoryItemProvider;
  TenantAuth _tenantAuth;
  CustomerProvider _customerProvider;
  FocusNode _defaultMarginRatioFocusNode = FocusNode();
  FocusNode _defaultDiscountRatioFocusNode = FocusNode();
  Map arguments = {};
  Map _selectedBranch = {};
  TabController _tabController;
  Map _priceConfigData = {};
  Map<String, dynamic> _priceConfigDetail = {};
  Map _saleDiscountData = {};
  Map _customerDiscountData = {};
  List _customerGroupList = [];
  String inventoryId = '';
  String inventoryName = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _defaultDiscountRatioFocusNode.dispose();
    _defaultMarginRatioFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _inventoryItemProvider = Provider.of<InventoryItemProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _customerProvider = Provider.of<CustomerProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    inventoryId = arguments['id'];
    inventoryName = arguments['displayName'];
    _selectedBranch = _tenantAuth.selectedBranch;
    _getCustomerGroupList();
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _getPriceConfig() async {
    _priceConfigDetail = await _inventoryItemProvider.getPriceConfiguration(
      inventoryId,
      _selectedBranch['id'],
    );
    if (_priceConfigDetail['sDiscount'] != null &&
        _priceConfigDetail['sDiscount']['cRatio'] != null) {
      _customerDiscountData.addAll(_priceConfigDetail['sDiscount']['cRatio']);
    }
    return _priceConfigDetail;
  }

  Future<List> _getCustomerGroupList() async {
    _customerGroupList = await _customerProvider.getCustomerGroup();
    return _customerGroupList;
  }

  Future<void> _onSubmit() async {
    if (_selectedBranch['name'] != 'Select Branch') {
      _formKey.currentState.save();
      try {
        _saleDiscountData['cRatio'] = _customerDiscountData;
        _priceConfigData['sDiscount'] = _saleDiscountData;
        _priceConfigData['branch'] = {
          'id': _selectedBranch['id'],
          'name': _selectedBranch['name'],
        };
        await _inventoryItemProvider.setPriceConfiguration(
          inventoryId,
          _selectedBranch['id'],
          _priceConfigData,
        );
        utils.showSuccessSnackbar(
            _screenContext, 'Discount added Successfully');
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

  Widget _priceConfigFormContainer() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                inventoryName.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              initialValue: _priceConfigDetail['sMargin']
                  .toString()
                  .replaceAll('null', ''),
              focusNode: _defaultMarginRatioFocusNode,
              decoration: InputDecoration(
                labelText: 'Default Margin Ratio (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.subtitle1,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                _defaultMarginRatioFocusNode.unfocus();
                FocusScope.of(context)
                    .requestFocus(_defaultDiscountRatioFocusNode);
              },
              onSaved: (val) {
                _priceConfigData['sMargin'] =
                    val.isEmpty ? null : double.parse(val);
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              initialValue: _priceConfigDetail['sDiscount'] == null
                  ? ''
                  : _priceConfigDetail['sDiscount']['ratio']
                      .toString()
                      .replaceAll('null', ''),
              focusNode: _defaultDiscountRatioFocusNode,
              decoration: InputDecoration(
                labelText: 'Default Discount Ratio (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.subtitle1,
              onSaved: (val) {
                _saleDiscountData['ratio'] =
                    val.isEmpty ? null : double.parse(val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerGroupListContainer() {
    return ListView(
      children: [
        ..._customerGroupList.map(
          (e) {
            return Column(
              children: [
                SizedBox(
                  height: 5.0,
                ),
                ListTile(
                  visualDensity: VisualDensity(
                    horizontal: 0,
                    vertical: -4,
                  ),
                  title: Text(
                    e['name'],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _showCustomerBasedDiscountBottomSheet(
                        context: _screenContext,
                        ratio: _priceConfigDetail['sDiscount'] == null ||
                                _priceConfigDetail['sDiscount']['cRatio'] ==
                                    null
                            ? '0'
                            : _getCustomerRatio(e['id']),
                        customerGroupId: e['id'],
                        customerGroup: e['name'],
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 0.75,
                ),
              ],
            );
          },
        ).toList(),
      ],
    );
  }

  String _getCustomerRatio(String customerGroupId) {
    String cRatio = '';
    _priceConfigDetail.forEach((key, value) {
      if (key == 'sDiscount') {
        Map customerGroupRatio = value['cRatio'];
        customerGroupRatio.forEach((key, value) {
          if (key == customerGroupId) {
            cRatio = value.toString();
          }
        });
      }
    });
    return cRatio;
  }

  Future<dynamic> _showCustomerBasedDiscountBottomSheet({
    BuildContext context,
    String ratio,
    String customerGroupId,
    String customerGroup,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: false,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.89,
          child: _showCustomerBasedDiscountForm(
            ratio,
            customerGroupId,
            customerGroup,
          ),
        );
      },
    );
  }

  Widget _showCustomerBasedDiscountForm(
    String ratio,
    String customerGroupId,
    String customerGroup,
  ) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  'Add Customer Based Discount Ratio'.toUpperCase(),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
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
              customerGroup.toUpperCase(),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            initialValue: _customerDiscountData[customerGroupId] == null
                ? ratio
                : _customerDiscountData[customerGroupId].toString(),
            autofocus: true,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.subtitle1,
            onChanged: (value) {
              ratio = value;
            },
            decoration: InputDecoration(
              labelText: 'Customer Based Discount Ratio (%)',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  _customerDiscountData.addAll(
                    {
                      customerGroupId: double.parse(
                        ratio.toString(),
                      ),
                    },
                  );
                  Navigator.of(context).pop();
                },
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
            Text('Price Configuration'),
            AppBarBranchSelection(
              selectedBranch: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBranch = value['branchInfo'];
                    _priceConfigDetail.clear();
                  });
                  _getPriceConfig();
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
        future: _getPriceConfig(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    children: [
                      _priceConfigFormContainer(),
                      TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.people),
                            text: 'Customer Based Discount',
                          ),
                          Tab(
                            icon: Icon(Icons.plus_one),
                            text: 'Quantity Based Discount',
                          )
                        ],
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _customerGroupListContainer(),
                            ShowDataEmptyImage(),
                          ],
                          controller: _tabController,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
