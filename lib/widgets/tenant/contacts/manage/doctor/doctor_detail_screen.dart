import 'package:auditplusmobile/providers/contacts/doctor_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/detail/detail_card.dart';
import '../../../../../utils.dart' as utils;

class DoctorDetailScreen extends StatefulWidget {
  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _doctorData = Map();
  DoctorProvider _doctorProvider;
  String doctorId;
  String doctorName;
  @override
  void didChangeDependencies() {
    _doctorProvider = Provider.of<DoctorProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    doctorId = arguments['id'];
    doctorName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getDoctor() async {
    try {
      _doctorData = await _doctorProvider.getDoctor(doctorId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _doctorData['name'],
          'AliasName': _doctorData['aliasName'],
          'LicenseNumber': _doctorData['licenseNumber'],
        },
      },
    );
  }

  Future<void> _deleteDoctor() async {
    try {
      await _doctorProvider.deleteDoctor(doctorId);
      utils.showSuccessSnackbar(_screenContext, 'Doctor Deleted Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/contacts/manage/doctor'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctorName,
        ),
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                '/contacts/manage/doctor/form',
                arguments: {
                  'id': doctorId,
                  'displayName': doctorName,
                  'detail': _doctorData,
                },
              ),
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.doctor.update',
              ],
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                utils.showAlertDialog(
                  _screenContext,
                  _deleteDoctor,
                  'Delete Doctor?',
                  'Are you sure want to delete',
                );
              },
            ),
            visible: utils.checkMenuWiseAccess(
              context,
              [
                'contacts.doctor.delete',
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getDoctor(),
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
