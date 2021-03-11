import 'package:auditplusmobile/providers/inventory/unit_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './../../../../../utils.dart' as utils;

class UnitDetailScreen extends StatefulWidget {
  @override
  _UnitDetailScreenState createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _unitData = Map();
  UnitProvider _unitProvider;
  String unitId;
  String unitName;
  @override
  void didChangeDependencies() {
    _unitProvider = Provider.of<UnitProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    unitId = arguments['id'];
    unitName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getUnit() async {
    try {
      _unitData = await _unitProvider.getUnit(unitId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _unitData['name'],
          'AliasName': _unitData['aliasName'],
          'UQC': _unitData['uqc'] == null ? '' : _unitData['uqc']['code']
        },
      },
    );
  }

  Future<void> _deleteUnit() async {
    try {
      await _unitProvider.deleteUnit(unitId);
      utils.showSuccessSnackbar(_screenContext, 'Unit Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/unit'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          unitName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/unit/form',
                arguments: {
                  'id': unitId,
                  'displayName': unitName,
                  'detail': _unitData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.unit.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteUnit,
                  'Delete Unit?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.unit.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getUnit(),
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
