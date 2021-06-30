import 'package:auditplusmobile/providers/inventory/vendor_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/detail/detail_card.dart';
import '../../../../../utils.dart' as utils;

class VendorDetailScreen extends StatefulWidget {
  @override
  _VendorDetailScreenState createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _vendorData = Map();
  VendorProvider _vendorProvider;
  String vendorId;
  String vendorName;

  @override
  void didChangeDependencies() {
    _vendorProvider = Provider.of<VendorProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    vendorId = arguments['id'];
    vendorName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getVendor() async {
    try {
      _vendorData = await _vendorProvider.getVendor(vendorId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _vendorData['name'],
          'AliasName': _vendorData['aliasName'],
          'ShortName': _vendorData['shortName'],
        },
        'GST INFO': {
          'GST NO': _vendorData['gstInfo']['gstNo'],
          'Registration Type': _vendorData['gstInfo']['regType']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _vendorData['gstInfo']['regType']['name'],
          'Location': _vendorData['gstInfo']['location']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _vendorData['gstInfo']['location']['name'],
        },
        'ADDRESS INFO': _vendorData['addressInfo'] == null
            ? null
            : {
                'Contact Person':
                    _vendorData['addressInfo']['contactPerson'] == null
                        ? null
                        : _vendorData['addressInfo']['contactPerson'],
                'Address': _vendorData['addressInfo']['address'] == null
                    ? null
                    : _vendorData['addressInfo']['address'],
                'Pincode': _vendorData['addressInfo']['pincode'] == null
                    ? null
                    : _vendorData['addressInfo']['pincode'],
                'City': _vendorData['addressInfo']['city'] == null
                    ? null
                    : _vendorData['addressInfo']['city'],
                'State': _vendorData['addressInfo']['state'] == null
                    ? null
                    : _vendorData['addressInfo']['state']['name'],
                'Country': _vendorData['addressInfo']['country'] == null
                    ? null
                    : _vendorData['addressInfo']['country']['name'],
              },
        'CONTACT INFO': _vendorData['contactInfo'] == null
            ? null
            : {
                'Contact Person':
                    _vendorData['contactInfo']['contactPerson'] == null
                        ? null
                        : _vendorData['contactInfo']['contactPerson'],
                'Mobile': _vendorData['contactInfo']['mobile'] == null
                    ? null
                    : _vendorData['contactInfo']['mobile'],
                'Alternate Mobile':
                    _vendorData['contactInfo']['alternateMobile'] == null
                        ? null
                        : _vendorData['contactInfo']['alternateMobile'],
                'Telephone': _vendorData['contactInfo']['telephone'] == null
                    ? null
                    : _vendorData['contactInfo']['telephone'],
                'Email': _vendorData['contactInfo']['email'] == null
                    ? null
                    : _vendorData['contactInfo']['email'],
              },
        'OTHER INFO': _vendorData['otherInfo'] == null
            ? null
            : {
                'Aadhar NO': _vendorData['otherInfo']['aadharNo'] == null
                    ? null
                    : _vendorData['otherInfo']['aadharNo'],
                'PAN.NO': _vendorData['otherInfo']['panNo'] == null
                    ? null
                    : _vendorData['otherInfo']['panNo'],
              },
      },
    );
  }

  Future<void> _deleteVendor() async {
    try {
      await _vendorProvider.deleteVendor(vendorId);
      utils.showSuccessSnackbar(_screenContext, 'Vendor Deleted Successfully');
      Navigator.of(_screenContext)
          .pushReplacementNamed('/inventory/purchase/vendor');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vendorName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/purchase/vendor/form',
                arguments: {
                  'id': vendorId,
                  'displayName': vendorName,
                  'detail': _vendorData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inv.vend.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteVendor,
                  'Delete Vendor?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inv.vend.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getVendor(),
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
