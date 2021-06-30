import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class DesktopClientFormScreen extends StatefulWidget {
  @override
  _DesktopClientFormScreenState createState() =>
      _DesktopClientFormScreenState();
}

class _DesktopClientFormScreenState extends State<DesktopClientFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  DesktopClientProvider _desktopClientProvider;
  String desktopClientId = '';
  String desktopClientName = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _displayNameFocusNode = FocusNode();
  Map<String, dynamic> _desktopClientDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _desktopClientData = {};
  @override
  void dispose() {
    _nameFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      desktopClientId = arguments['id'];
      desktopClientName = arguments['displayName'];
      _getDesktopClient();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getDesktopClient() {
    _desktopClientDetail = arguments['detail'];
    return _desktopClientDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        if (desktopClientId.isEmpty) {
          await _desktopClientProvider.createDesktopClient(_desktopClientData);
          utils.showSuccessSnackbar(
              _screenContext, 'Desktop Client Created Successfully');
        } else {
          await _desktopClientProvider.updateDesktopClient(
              desktopClientId, _desktopClientData);
          utils.showSuccessSnackbar(
              _screenContext, 'Desktop Client updated Successfully');
        }
        Navigator.of(_screenContext)
            .pushReplacementNamed('/administration/manage/desktop-client');
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _desktopClientFormGeneralInfoContainer() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Text(
                'GENERAL INFO',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _desktopClientDetail['name'],
                    focusNode: _nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _nameFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_displayNameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _desktopClientData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _desktopClientDetail['displayName'],
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    onSaved: (val) {
                      _desktopClientData.addAll({
                        'displayName':
                            val.isEmpty ? _desktopClientData['name'] : val
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            desktopClientName.isEmpty
                ? 'Add Desktop Client'
                : desktopClientName,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _onSubmit();
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            _screenContext = context;
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _desktopClientFormGeneralInfoContainer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      onWillPop: () async {
        utils.showAlertDialog(
          context,
          () => Navigator.of(context).pop(),
          'Discard Changes?',
          'Changes will be discarded once you leave this page',
        );
        return true;
      },
    );
  }
}
