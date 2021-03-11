import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/user/user_regenerate_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _userData = Map();
  UserProvider _userProvider;
  String userId;
  String userName;
  List<String> _menuList = [
    'Assign Branches',
    'Password Regeneration',
    'Deactivate User',
  ];
  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    userId = arguments['id'];
    userName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getUser() async {
    try {
      _userData = await _userProvider.getUser(userId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Username': _userData['name'],
          'AliasName': _userData['aliasName'],
          'Role': _userData['role']['name'],
          'Remote Access':
              _userData['allowRemoteAccess'] == true ? 'YES' : 'NO',
          'Is Accountant': _userData['isAccountant'] == true ? 'YES' : 'NO',
        },
        'CONTACT INFO': {
          'Email': _userData['email'],
          'Mobile': _userData['mobile'],
          'Address': _userData['address'],
        },
      },
    );
  }

  void _menuAction(String menu) {
    if (menu == 'Assign Branches') {
      Navigator.of(context).pushNamed(
        '/administration/manage/user/assign-branches',
        arguments: {
          'id': userId,
          'displayName': userName,
        },
      );
    } else if (menu == 'Password Regeneration') {
      showUserRegeneratePasswordBottomSheet(
        screenContext: _screenContext,
        detail: _userData,
      );
    } else if (menu == 'Deactivate User') {
      utils.showAlertDialog(
        _screenContext,
        _deactivateUser,
        'Deactivate User?',
        'Are you sure want to deactivate',
      );
    }
  }

  Future<void> _deactivateUser() async {
    try {
      await _userProvider.deactivateUser(userId);
      utils.showSuccessSnackbar(
          _screenContext, 'User Deactivated Successfully');
      Future.delayed(Duration(seconds: 2)).then((value) =>
          Navigator.of(_screenContext)
              .pushReplacementNamed('/administration/manage/user'));
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userName,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              '/administration/manage/user/form',
              arguments: {
                'id': userId,
                'displayName': userName,
                'detail': _userData,
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
        future: _getUser(),
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
