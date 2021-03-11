import 'package:auditplusmobile/providers/contacts/patient_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/detail/detail_card.dart';
import '../../../../../utils.dart' as utils;

class PatientDetailScreen extends StatefulWidget {
  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _patientData = Map();
  PatientProvider _patientProvider;
  String patientId;
  String patientName;
  @override
  void didChangeDependencies() {
    _patientProvider = Provider.of<PatientProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    patientId = arguments['id'];
    patientName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getPatient() async {
    try {
      _patientData = await _patientProvider.getPatient(patientId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _patientData['name'],
          'AliasName': _patientData['aliasName'],
          'Customer': _patientData['customer']['name'],
        },
      },
    );
  }

  Future<void> _deletePatient() async {
    try {
      await _patientProvider.deletePatient(patientId);
      utils.showSuccessSnackbar(_screenContext, 'Patient Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/contacts/manage/patient'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          patientName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/contacts/manage/patient/form',
                arguments: {
                  'id': patientId,
                  'displayName': patientName,
                  'detail': _patientData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.patient.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deletePatient,
                  'Delete Patient?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.patient.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getPatient(),
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
