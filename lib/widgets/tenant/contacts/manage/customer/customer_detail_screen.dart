import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/detail/detail_card.dart';
import '../../../../../providers/contacts/customer_provider.dart';
import '../../../../../utils.dart' as utils;

class CustomerDetailScreen extends StatefulWidget {
  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _customerData = Map();
  CustomerProvider _customerProvider;
  String customerId;
  String customerName;
  List _menuList = [];
  @override
  void initState() {
    _checkVisibility();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    customerId = arguments['id'];
    customerName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getCustomer() async {
    try {
      _customerData = await _customerProvider.getCustomer(customerId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _customerData['name'],
          'AliasName': _customerData['aliasName'],
        },
        'GST INFO': {
          'GST NO': _customerData['gstInfo']['gstNo'],
          'Registration Type': _customerData['gstInfo']['regType']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _customerData['gstInfo']['regType']['name'],
          'Location': _customerData['gstInfo']['location']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _customerData['gstInfo']['location']['name'],
        },
        'ADDRESS INFO': {
          'Contact Person': _customerData['addressInfo']['contactPerson'],
          'Address': _customerData['addressInfo']['address'],
          'Pincode': _customerData['addressInfo']['pincode'],
          'City': _customerData['addressInfo']['city'],
          'State': _customerData['addressInfo']['state']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _customerData['addressInfo']['state']['name'],
          'Country': _customerData['addressInfo']['country']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _customerData['addressInfo']['country']['name'],
        },
        'CONTACT INFO': {
          'Contact Person': _customerData['contactInfo']['contactPerson'],
          'Mobile': _customerData['contactInfo']['mobile'],
          'Alternate Mobile': _customerData['contactInfo']['alternateMobile'],
          'Telephone': _customerData['contactInfo']['telephone'],
          'Email': _customerData['contactInfo']['email'],
        },
        'OTHER INFO': {
          'Aadhar NO': _customerData['otherInfo']['aadharNo'],
          'PAN.NO': _customerData['otherInfo']['panNo'],
        },
        'CUSTOMER GROUP INFO': {
          'Customer Group': _customerData.keys.contains('customerGroup')
              ? _customerData['customerGroup']['name']
              : null,
        },
      },
    );
  }

  Future<void> _deleteCustomer() async {
    try {
      await _customerProvider.deleteCustomer(customerId);
      utils.showSuccessSnackbar(
          _screenContext, 'Customer Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/contacts/manage/customer'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(context, ['contacts.customer.opening'])) {
      _menuList.add('Customer Opening');
    }
    if (utils.checkMenuWiseAccess(context, ['contacts.customer.delete'])) {
      _menuList.add('Delete Customer');
    }
  }

  void _menuAction(String menu) {
    if (menu == 'Customer Opening') {
      Navigator.of(context).pushNamed(
        '/contacts/manage/customer/opening',
        arguments: {
          'id': customerId,
          'displayName': customerName,
        },
      );
    } else if (menu == 'Delete Customer') {
      utils.showAlertDialog(
        _screenContext,
        _deleteCustomer,
        'Delete Customer?',
        'Are you sure want to delete',
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          customerName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/contacts/manage/customer/form',
                arguments: {
                  'id': customerId,
                  'displayName': customerName,
                  'detail': _customerData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.customer.update',
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _menuAction(value),
            itemBuilder: (BuildContext context) {
              return _menuList.map(
                (menu) {
                  return PopupMenuItem<String>(
                    value: menu,
                    child: Text(
                      menu,
                    ),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCustomer(),
        builder: (BuildContext context, snapShot) {
          _screenContext = context;
          return snapShot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: DetailCard(
                      _buildDetailPage(),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
