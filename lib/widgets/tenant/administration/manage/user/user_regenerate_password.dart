import 'package:auditplusmobile/providers/administration/user_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import './../../../../../utils.dart' as utils;

Future<dynamic> showUserRegeneratePasswordBottomSheet({
  BuildContext screenContext,
  Map detail,
}) {
  return showModalBottomSheet(
    context: screenContext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return UserRegeneartePassword(detail, screenContext);
    },
  );
}

class UserRegeneartePassword extends StatefulWidget {
  final Map detail;
  final BuildContext screenContext;
  UserRegeneartePassword(this.detail, this.screenContext);
  @override
  _UserRegeneartePasswordState createState() => _UserRegeneartePasswordState();
}

class _UserRegeneartePasswordState extends State<UserRegeneartePassword> {
  Map arguments = {};
  String userId = '';
  String userName = '';
  Map _userPasswordData = {};
  UserProvider _userProvider;
  TenantAuth _tenantAuth;
  bool _isLoading = false;

  @override
  void initState() {
    userId = widget.detail['id'];
    userName = widget.detail['displayName'];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    super.didChangeDependencies();
  }

  Future<Map> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _userProvider.resetPassword(userId);
      setState(() {
        _userPasswordData = data;
        _isLoading = false;
      });
    } catch (error) {
      Navigator.of(context).pop();
      utils.handleErrorResponse(widget.screenContext, error.message, 'tenant');
    }
    return _userPasswordData;
  }

  Future<void> _showShareOption() async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
      'Hello Sir/Madam,\nYour ${_tenantAuth.organizationName} organization username is $userName & password is ${_userPasswordData['password']}\nThanks and Regards by Auditplus.',
      subject: 'Reg:Secrete Code Informations',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    ).then(
      (value) {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _generatePassword() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15.0,
          ),
          Text(
            _userPasswordData.isEmpty
                ? 'Hello user, need to generate your password? Click the button below.'
                : 'This password will not be displayed again, so please share it with the user',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 15.0,
          ),
          _isLoading == true
              ? CircularProgressIndicator()
              : _userPasswordData.isEmpty
                  ? Container(
                      height: 45.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _resetPassword();
                        },
                        child: Text(
                          'Generate Password',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 160,
                          child: OutlinedButton(
                            onPressed: null,
                            child: Text(
                              _userPasswordData['password'].toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => _showShareOption(),
                          ),
                        ),
                      ],
                    ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'GENERATE PASSWORD',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 0.0,
              ),
              child: _generatePassword(),
            ),
          ],
        ),
      ),
    );
  }
}
