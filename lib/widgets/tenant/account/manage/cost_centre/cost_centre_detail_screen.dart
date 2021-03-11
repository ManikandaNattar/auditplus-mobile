import 'package:auditplusmobile/providers/accounting/cost_centre_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CostCentreDetailScreen extends StatefulWidget {
  @override
  _CostCentreDetailScreenState createState() => _CostCentreDetailScreenState();
}

class _CostCentreDetailScreenState extends State<CostCentreDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _costCentreData = Map();
  CostCentreProvider _costCentreProvider;
  String costCentreId;
  String costCentreName;
  @override
  void didChangeDependencies() {
    _costCentreProvider = Provider.of<CostCentreProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    costCentreId = arguments['id'];
    costCentreName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getCostCentre() async {
    try {
      _costCentreData = await _costCentreProvider.getCostCentre(costCentreId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _costCentreData['name'],
          'AliasName': _costCentreData['aliasName'],
          'Category': _costCentreData['category']['name'],
        },
      },
    );
  }

  Future<void> _deleteCostCentre() async {
    try {
      await _costCentreProvider.deleteCostCentre(costCentreId);
      utils.showSuccessSnackbar(
          _screenContext, 'Cost Centre Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/accounts/manage/cost-centre'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          costCentreName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/manage/cost-centre/form',
                arguments: {
                  'id': costCentreId,
                  'displayName': costCentreName,
                  'detail': _costCentreData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'accounting.costCentre.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteCostCentre,
                  'Delete Cost Centre?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'accounting.costCentre.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCostCentre(),
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
