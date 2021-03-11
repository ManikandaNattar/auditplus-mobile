import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class SectionDetailScreen extends StatefulWidget {
  @override
  _SectionDetailScreenState createState() => _SectionDetailScreenState();
}

class _SectionDetailScreenState extends State<SectionDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _sectionData = Map();
  SectionProvider _sectionProvider;
  String sectionId;
  String sectionName;
  @override
  void didChangeDependencies() {
    _sectionProvider = Provider.of<SectionProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    sectionId = arguments['id'];
    sectionName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getSection() async {
    try {
      _sectionData = await _sectionProvider.getSection(sectionId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _sectionData['name'],
          'AliasName': _sectionData['aliasName'],
          'Parent Section': _sectionData['parentSection'] == null
              ? ''
              : _sectionData['parentSection']['name']
        },
      },
    );
  }

  Future<void> _deleteSection() async {
    try {
      await _sectionProvider.deleteSection(sectionId);
      utils.showSuccessSnackbar(_screenContext, 'Section Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/inventory/manage/section'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sectionName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/inventory/manage/section/form',
                arguments: {
                  'id': sectionId,
                  'displayName': sectionName,
                  'detail': _sectionData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.section.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteSection,
                  'Delete Section?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'inventory.section.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getSection(),
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
