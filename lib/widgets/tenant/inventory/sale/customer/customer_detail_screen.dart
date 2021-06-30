import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/detail/detail_card.dart';
import '../../../../../providers/inventory/customer_provider.dart';
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
        'ADDRESS INFO': _customerData['addressInfo'] == null
            ? null
            : {
                'Contact Person':
                    _customerData['addressInfo']['contactPerson'] == null
                        ? null
                        : _customerData['addressInfo']['contactPerson'],
                'Address': _customerData['addressInfo']['address'] == null
                    ? null
                    : _customerData['addressInfo']['address'],
                'Pincode': _customerData['addressInfo']['pincode'] == null
                    ? null
                    : _customerData['addressInfo']['pincode'],
                'City': _customerData['addressInfo']['city'] == null
                    ? null
                    : _customerData['addressInfo']['city'],
                'State': _customerData['addressInfo']['state'] == null
                    ? null
                    : _customerData['addressInfo']['state']['name'],
                'Country': _customerData['addressInfo']['country'] == null
                    ? null
                    : _customerData['addressInfo']['country']['name'],
              },
        'CONTACT INFO': _customerData['contactInfo'] == null
            ? null
            : {
                'Contact Person':
                    _customerData['contactInfo']['contactPerson'] == null
                        ? null
                        : _customerData['contactInfo']['contactPerson'],
                'Mobile': _customerData['contactInfo']['mobile'] == null
                    ? null
                    : _customerData['contactInfo']['mobile'],
                'Alternate Mobile':
                    _customerData['contactInfo']['alternateMobile'] == null
                        ? null
                        : _customerData['contactInfo']['alternateMobile'],
                'Telephone': _customerData['contactInfo']['telephone'] == null
                    ? null
                    : _customerData['contactInfo']['telephone'],
                'Email': _customerData['contactInfo']['email'] == null
                    ? null
                    : _customerData['contactInfo']['email'],
              },
        'OTHER INFO': _customerData['otherInfo'] == null
            ? null
            : {
                'Aadhar NO': _customerData['otherInfo']['aadharNo'] == null
                    ? null
                    : _customerData['otherInfo']['aadharNo'],
                'PAN.NO': _customerData['otherInfo']['panNo'] == null
                    ? null
                    : _customerData['otherInfo']['panNo'],
              },
        'CUSTOMER GROUP INFO': {
          'Customer Group': _customerData['group'] != null ||
                  !_customerData.keys.contains('group')
              ? _customerData['group']['name']
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
      Navigator.of(_screenContext)
          .pushReplacementNamed('/inventory/sale/customer');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
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
                '/inventory/sale/customer/form',
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
                'inv.cus.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteCustomer,
                  'Delete Customer?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inv.cus.dl',
              ],
            ),
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
