import 'package:auditplusmobile/providers/accounting/cost_category_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CostCategoryDetailScreen extends StatefulWidget {
  @override
  _CostCategoryDetailScreenState createState() =>
      _CostCategoryDetailScreenState();
}

class _CostCategoryDetailScreenState extends State<CostCategoryDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _costCategoryData = Map();
  CostCategoryProvider _costCategoryProvider;
  String costCategoryId;
  String costCategoryName;
  @override
  void didChangeDependencies() {
    _costCategoryProvider = Provider.of<CostCategoryProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    costCategoryId = arguments['id'];
    costCategoryName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getCostCategory() async {
    try {
      _costCategoryData =
          await _costCategoryProvider.getCostCategory(costCategoryId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _costCategoryData['name'],
          'AliasName': _costCategoryData['aliasName'],
        },
      },
    );
  }

  Future<void> _deleteCostCategory() async {
    try {
      await _costCategoryProvider.deleteCostCategory(costCategoryId);
      utils.showSuccessSnackbar(
          _screenContext, 'Cost category Deleted Successfully');
      Navigator.of(_screenContext)
          .pushReplacementNamed('/accounts/manage/cost-category');
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          costCategoryName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/accounts/manage/cost-category/form',
                arguments: {
                  'id': costCategoryId,
                  'displayName': costCategoryName,
                  'detail': _costCategoryData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.ccat.up',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteCostCategory,
                  'Delete Cost Category?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'ac.ccat.dl',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCostCategory(),
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
