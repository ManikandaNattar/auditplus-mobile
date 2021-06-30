import 'package:auditplusmobile/providers/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../utils.dart' as utils;

class OrganizationForm extends StatefulWidget {
  @override
  _OrganizationFormState createState() => _OrganizationFormState();
}

Future<void> getOrganization(OrganizationProvider organizationProvider,
    String organizationName, BuildContext context) async {
  try {
    await organizationProvider.getOrganization(organizationName);
  } catch (error) {
    utils.handleErrorResponse(context, error.message, 'tenant');
  }
}

class _OrganizationFormState extends State<OrganizationForm> {
  final _form = GlobalKey<FormState>();
  var _organization = {'name': ''};
  OrganizationProvider _organizationProvider;
  TextEditingController _organizationInputController = TextEditingController();
  bool isLoading = false;

  void _saveForm() {
    setState(() {
      isLoading = true;
    });
    getOrganization(
      _organizationProvider,
      _organizationInputController.text.trim(),
      context,
    ).then((value) {
      if (_form.currentState.validate()) {
        _form.currentState.save();
        Navigator.of(context).pop(_organization);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _organizationProvider = Provider.of<OrganizationProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            controller: _organizationInputController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Organization Name should not be empty';
              }
              // if (_organizationProvider.organization['error'] != null) {
              //   return 'Organization not found';
              // }
              return null;
            },
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Organization Name',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _saveForm(),
            onSaved: (value) {
              _organization.update('name', (_) => value.trim());
            },
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 20.0,
          ),
          if (isLoading == true)
            CircularProgressIndicator()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    child: Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _saveForm),
              ],
            ),
        ],
      ),
    );
  }
}
