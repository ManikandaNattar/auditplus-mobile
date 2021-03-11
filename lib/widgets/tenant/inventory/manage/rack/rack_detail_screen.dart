import 'package:auditplusmobile/providers/inventory/rack_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class RackDetailScreen extends StatefulWidget {
  @override
  _RackDetailScreenState createState() => _RackDetailScreenState();
}

class _RackDetailScreenState extends State<RackDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _rackData = Map();
  RackProvider _rackProvider;
  String rackId;
  String rackName;
  @override
  void didChangeDependencies() {
    _rackProvider = Provider.of<RackProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    rackId = arguments['id'];
    rackName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getRack() async {
    try {
      _rackData = await _rackProvider.getRack(rackId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _rackData['name'],
          'AliasName': _rackData['aliasName'],
        },
      },
    );
  }

  Future<void> _deleteRack() async {
    try {
      await _rackProvider.deleteRack(rackId);
      utils.showSuccessSnackbar(_screenContext, 'Rack Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/rack'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          rackName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/rack/form',
                arguments: {
                  'id': rackId,
                  'displayName': rackName,
                  'detail': _rackData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.rack.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteRack,
                  'Delete Rack?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.rack.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getRack(),
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
