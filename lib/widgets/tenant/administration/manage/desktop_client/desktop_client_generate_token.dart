import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import './../../../../../providers/auth/tenant_auth_provider.dart';

Future<dynamic> showDektopClientGenerateTokenBottomSheet({
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
      return DesktopClientGenerateToken(detail);
    },
  );
}

class DesktopClientGenerateToken extends StatefulWidget {
  final Map detail;
  DesktopClientGenerateToken(this.detail);
  @override
  _DesktopClientGenerateTokenState createState() =>
      _DesktopClientGenerateTokenState();
}

class _DesktopClientGenerateTokenState
    extends State<DesktopClientGenerateToken> {
  Map arguments = {};
  String desktopClientId = '';
  String desktopClientName = '';
  Map _accessKey = {};
  DesktopClientProvider _desktopClientProvider;
  TenantAuth _tenantAuth;
  bool _isLoading = false;

  @override
  void initState() {
    desktopClientId = widget.detail['id'];
    desktopClientName = widget.detail['displayName'];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    super.didChangeDependencies();
  }

  Future<Map> _getAccessToken() async {
    setState(() {
      _isLoading = true;
    });
    final data =
        await _desktopClientProvider.generateRegistrationCode(desktopClientId);
    setState(() {
      _accessKey = data;
      _isLoading = false;
    });
    return _accessKey;
  }

  Future<void> _showShareOption() async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
      'Hello Sir/Madam,\nYour ${_tenantAuth.organizationName} organization $desktopClientName client access key is ${_accessKey['registrationCode']}.\nThis is valid only ten minutes so quickly add to your client.\nThanks and Regards by Auditplus.',
      subject: 'Reg:Client Access Key',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    ).then(
      (value) {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _generateToken() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15.0,
          ),
          Text(
            _accessKey.isEmpty
                ? '$desktopClientName client doesnot connect for this organization, so click the button get your access registration key'
                : 'Take the registration key below and enter in your $desktopClientName client registration page. This access key is valid only ten minutes so quickly add to your client.',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 15.0,
          ),
          _isLoading == true
              ? CircularProgressIndicator()
              : _accessKey.isEmpty
                  ? Container(
                      height: 45.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _getAccessToken();
                        },
                        child: Text(
                          'Generate your access token',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          child: OutlinedButton(
                            onPressed: null,
                            child: Text(
                              _accessKey['registrationCode'].toString(),
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
                        'GENERATE TOKEN',
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
              child: _generateToken(),
            ),
          ],
        ),
      ),
    );
  }
}
