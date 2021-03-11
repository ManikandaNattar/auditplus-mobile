import 'package:auditplusmobile/providers/contacts/vendor_provider.dart';
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
  List _menuList = [];

  @override
  void initState() {
    _checkVisibility();
    super.initState();
  }

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
        'ADDRESS INFO': {
          'Contact Person': _vendorData['addressInfo']['contactPerson'],
          'Address': _vendorData['addressInfo']['address'],
          'Pincode': _vendorData['addressInfo']['pincode'],
          'City': _vendorData['addressInfo']['city'],
          'State': _vendorData['addressInfo']['state']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _vendorData['addressInfo']['state']['name'],
          'Country': _vendorData['addressInfo']['country']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _vendorData['addressInfo']['country']['name'],
        },
        'CONTACT INFO': {
          'Contact Person': _vendorData['contactInfo']['contactPerson'],
          'Mobile': _vendorData['contactInfo']['mobile'],
          'Alternate Mobile': _vendorData['contactInfo']['alternateMobile'],
          'Telephone': _vendorData['contactInfo']['telephone'],
          'Email': _vendorData['contactInfo']['email'],
        },
        'OTHER INFO': {
          'Aadhar NO': _vendorData['otherInfo']['aadharNo'],
          'PAN.NO': _vendorData['otherInfo']['panNo'],
        },
      },
    );
  }

  Future<void> _deleteVendor() async {
    try {
      await _vendorProvider.deleteVendor(vendorId);
      utils.showSuccessSnackbar(_screenContext, 'Vendor Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/contacts/manage/vendor'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  void _checkVisibility() {
    if (utils.checkMenuWiseAccess(context, ['contacts.vendor.opening'])) {
      _menuList.add('Vendor Opening');
    }
    if (utils.checkMenuWiseAccess(context, ['contacts.vendor.delete'])) {
      _menuList.add('Delete Vendor');
    }
  }

  void _menuAction(String menu) {
    if (menu == 'Vendor Opening') {
      Navigator.of(context).pushNamed(
        '/contacts/manage/vendor/opening',
        arguments: {
          'id': vendorId,
          'displayName': vendorName,
        },
      );
    } else if (menu == 'Delete Vendor') {
      utils.showAlertDialog(
        _screenContext,
        _deleteVendor,
        'Delete Vendor?',
        'Are you sure want to delete',
      );
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
                '/contacts/manage/vendor/form',
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
                'contacts.vendor.update',
              ],
            ),
          ),
          Visibility(
            child: PopupMenuButton<String>(
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
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.vendor.opening',
                'contacts.vendor.delete',
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
