import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class BranchDetailScreen extends StatefulWidget {
  @override
  _BranchDetailScreenState createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _branchData = Map();
  BranchProvider _branchProvider;
  String branchId;
  String branchName;
  List<String> _menuList = [
    'Assign Users',
    'Assign Clients',
  ];
  @override
  void didChangeDependencies() {
    _branchProvider = Provider.of<BranchProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    branchId = arguments['id'];
    branchName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getBranch() async {
    try {
      _branchData = await _branchProvider.getBranch(branchId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _branchData['name'],
          'AliasName': _branchData['aliasName'],
        },
        'GST INFO': {
          'GST NO': _branchData['gstInfo']['gstNo'],
          'Registration Type': _branchData['gstInfo']['regType']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _branchData['gstInfo']['regType']['name'],
          'Location': _branchData['gstInfo']['location']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _branchData['gstInfo']['location']['name'],
        },
        'ADDRESS INFO': {
          'Address': _branchData['addressInfo']['address'],
          'Pincode': _branchData['addressInfo']['pincode'],
          'City': _branchData['addressInfo']['city'],
          'State': _branchData['addressInfo']['state']
                  .toString()
                  .replaceAll('null', '')
                  .isEmpty
              ? null
              : _branchData['addressInfo']['state']['name'],
        },
        'CONTACT INFO': {
          'Mobile': _branchData['contactInfo']['mobile'],
          'Alternate Mobile': _branchData['contactInfo']['alternateMobile'],
          'Telephone': _branchData['contactInfo']['telephone'],
          'Email': _branchData['contactInfo']['email'],
        },
        'OTHER INFO': {
          'License Number': _branchData['otherInfo']['licenseNo'],
        },
      },
    );
  }

  void _menuAction(String menu) {
    if (menu == 'Assign Users') {
      Navigator.of(context).pushNamed(
        '/administration/manage/branch/assign-users',
        arguments: {
          'id': branchId,
          'displayName': branchName,
          'detail': _branchData,
        },
      );
    } else if (menu == 'Assign Clients') {
      Navigator.of(context).pushNamed(
        '/administration/manage/branch/assign-clients',
        arguments: {
          'id': branchId,
          'displayName': branchName,
          'detail': _branchData,
        },
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          branchName,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              '/administration/manage/branch/form',
              arguments: {
                'id': branchId,
                'displayName': branchName,
                'detail': _branchData,
              },
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _menuAction(value),
            itemBuilder: (BuildContext context) {
              return _menuList.map(
                (menu) {
                  return PopupMenuItem<String>(
                    value: menu,
                    child: Text(
                      menu,
                    ),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getBranch(),
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
