import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:auditplusmobile/widgets/tenant/administration/manage/desktop_client/desktop_client_generate_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class DesktopClientDetailScreen extends StatefulWidget {
  @override
  _DesktopClientDetailScreenState createState() =>
      _DesktopClientDetailScreenState();
}

class _DesktopClientDetailScreenState extends State<DesktopClientDetailScreen> {
  BuildContext _screenContext;
  Map<String, dynamic> _desktopClientData = Map();
  DesktopClientProvider _desktopClientProvider;
  String desktopClientId;
  String desktopClientName;
  List<String> _menuList = [
    'Assign Branches',
    'Generate Token',
  ];
  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    Map arguments = ModalRoute.of(context).settings.arguments;
    desktopClientId = arguments['id'];
    desktopClientName = arguments['displayName'];
    super.didChangeDependencies();
  }

  Future<void> _getDesktopClient() async {
    try {
      _desktopClientData =
          await _desktopClientProvider.getDesktopClient(desktopClientId);
    } catch (error) {
      utils.handleErrorResponse(_screenContext, error.message, 'tenant');
    }
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'GENERAL INFO': {
          'Name': _desktopClientData['name'],
          'AliasName': _desktopClientData['aliasName'],
        },
      },
    );
  }

  void _menuAction(String menu) {
    if (menu == 'Assign Branches') {
      Navigator.of(context).pushNamed(
        '/administration/manage/desktop-client/assign-branches',
        arguments: {
          'id': desktopClientId,
          'displayName': desktopClientName,
        },
      );
    } else if (menu == 'Generate Token') {
      showDektopClientGenerateTokenBottomSheet(
        screenContext: _screenContext,
        detail: _desktopClientData,
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          desktopClientName,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              '/administration/manage/desktop-client/form',
              arguments: {
                'id': desktopClientId,
                'displayName': desktopClientName,
                'detail': _desktopClientData,
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
        future: _getDesktopClient(),
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
