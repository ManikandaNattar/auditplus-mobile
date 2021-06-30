import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './autocomplete_form_field.dart';

Future<dynamic> cashRegisterSelectionBottomSheet({
  BuildContext context,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: CashRegisterSelection(),
      );
    },
  );
}

class CashRegisterSelection extends StatefulWidget {
  @override
  _CashRegisterSelectionState createState() => _CashRegisterSelectionState();
}

class _CashRegisterSelectionState extends State<CashRegisterSelection> {
  CashRegisterProvider _cashRegisterProvider;
  TextEditingController _cashRegisterTextEditingController =
      TextEditingController();
  FocusNode _cashRegisterFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    _cashRegisterProvider = Provider.of<CashRegisterProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: VisualDensity(
              horizontal: 0,
              vertical: -4,
            ),
            contentPadding: EdgeInsets.all(0.0),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'SELECT CASH REGISTER',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          AutocompleteFormField(
            autoFocus: false,
            focusNode: _cashRegisterFocusNode,
            controller: _cashRegisterTextEditingController,
            autocompleteCallback: (pattern) {
              return _cashRegisterProvider.cashRegisterAutoComplete(
                searchText: pattern,
              );
            },
            validator: null,
            labelText: 'Cash Register',
            suggestionFormatter: (suggestion) => suggestion['name'],
            textFormatter: (selection) => selection['name'],
            onSaved: (_) {},
            onSelected: (val) {
              Navigator.of(context).pop(val);
            },
          ),
        ],
      ),
    );
  }
}
