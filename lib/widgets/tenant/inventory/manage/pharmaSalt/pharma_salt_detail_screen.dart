import 'package:auditplusmobile/providers/inventory/pharma_salt_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class PharmaSaltDetailScreen extends StatefulWidget {
  @override
  _PharmaSaltDetailScreenState createState() => _PharmaSaltDetailScreenState();
}

class _PharmaSaltDetailScreenState extends State<PharmaSaltDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _saltData = Map();
  PharmaSaltProvider _pharmaSaltProvider;
  String saltId;
  String saltName;
  @override
  void didChangeDependencies() {
    _pharmaSaltProvider = Provider.of<PharmaSaltProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    saltId = arguments['id'];
    saltName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getPharmaSalt() async {
    try {
      _saltData = await _pharmaSaltProvider.getPharmaSalt(saltId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _saltData['name'],
          'AliasName': _saltData['aliasName'],
        },
      },
    );
  }

  Future<void> _deletePharmaSalt() async {
    try {
      await _pharmaSaltProvider.deletePharmaSalt(saltId);
      utils.showSuccessSnackbar(_screenContext, 'Salt Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/pharma-salt'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          saltName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/pharma-salt/form',
                arguments: {
                  'id': saltId,
                  'displayName': saltName,
                  'detail': _saltData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.pharmaSalt.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deletePharmaSalt,
                  'Delete Salt?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.pharmaSalt.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getPharmaSalt(),
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
