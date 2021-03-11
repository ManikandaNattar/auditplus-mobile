import 'package:auditplusmobile/providers/inventory/manufacturer_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class ManufacturerDetailScreen extends StatefulWidget {
  @override
  _ManufacturerDetailScreenState createState() =>
      _ManufacturerDetailScreenState();
}

class _ManufacturerDetailScreenState extends State<ManufacturerDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _manufacturerData = Map();
  ManufacturerProvider _manufacturerProvider;
  String manufacturerId;
  String manufacturerName;
  @override
  void didChangeDependencies() {
    _manufacturerProvider = Provider.of<ManufacturerProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    manufacturerId = arguments['id'];
    manufacturerName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getManufacturer() async {
    try {
      _manufacturerData =
          await _manufacturerProvider.getManufacturer(manufacturerId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _manufacturerData['name'],
          'AliasName': _manufacturerData['aliasName'],
        },
        'CONTACT INFO': {
          'Mobile': _manufacturerData['mobile'],
          'Telephone': _manufacturerData['telephone'],
          'Email': _manufacturerData['email'],
        },
      },
    );
  }

  Future<void> _deleteManufacturer() async {
    try {
      await _manufacturerProvider.deleteManufacturer(manufacturerId);
      utils.showSuccessSnackbar(
          _screenContext, 'Manufacturer Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/manufacturer'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          manufacturerName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/manufacturer/form',
                arguments: {
                  'id': manufacturerId,
                  'displayName': manufacturerName,
                  'detail': _manufacturerData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.manufacturer.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteManufacturer,
                  'Delete Manufacturer?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.manufacturer.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getManufacturer(),
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
