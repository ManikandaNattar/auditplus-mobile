import 'package:auditplusmobile/providers/administration/warehouse_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class WarehouseDetailScreen extends StatefulWidget {
  @override
  _WarehouseDetailScreenState createState() => _WarehouseDetailScreenState();
}

class _WarehouseDetailScreenState extends State<WarehouseDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _warehouseData = Map();
  WarehouseProvider _warehouseProvider;
  String warehouseId;
  String warehouseName;
  @override
  void didChangeDependencies() {
    _warehouseProvider = Provider.of<WarehouseProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    warehouseId = arguments['id'];
    warehouseName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getWarehouse() async {
    try {
      _warehouseData = await _warehouseProvider.getWarehouse(warehouseId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _warehouseData['name'],
          'AliasName': _warehouseData['aliasName'],
        },
        'ADDRESS INFO': {
          'Address': _warehouseData['addressInfo']['address'],
          'Pincode': _warehouseData['addressInfo']['pincode'],
          'City': _warehouseData['addressInfo']['city'],
          'State': _warehouseData['addressInfo']['state']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _warehouseData['addressInfo']['state']['name'],
        },
        'CONTACT INFO': {
          'Mobile': _warehouseData['contactInfo']['mobile'],
          'Telephone': _warehouseData['contactInfo']['telephone'],
          'Email': _warehouseData['contactInfo']['email'],
        },
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          warehouseName,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              '/administration/manage/warehouse/form',
              arguments: {
                'id': warehouseId,
                'displayName': warehouseName,
                'detail': _warehouseData,
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getWarehouse(),
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
