import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/filter_key_form_field.dart';

class ContactsFilterForm extends StatefulWidget {
  @override
  _ContactsFilterFormState createState() => _ContactsFilterFormState();
}

class _ContactsFilterFormState extends State<ContactsFilterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aliasNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  String nameFilterKey;
  String aliasNameFilterKey;
  String emailFilterKey;
  String mobileFilterKey;
  Map _formData = Map();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _nameFocusNode.dispose();
    _aliasNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _formData = ModalRoute.of(context).settings.arguments;
    _nameController.text = _formData['name'];
    _aliasNameController.text = _formData['aliasName'];
    _emailController.text = _formData['email'];
    _mobileController.text = _formData['mobile'];
    nameFilterKey = _formData['nameFilterKey'];
    aliasNameFilterKey = _formData['aliasNameFilterKey'];
    emailFilterKey = _formData['emailFilterKey'];
    mobileFilterKey = _formData['mobileFilterKey'];
    super.didChangeDependencies();
  }

  Widget _buildFilterForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            FilterKeyFormField(
              labelName: 'Name',
              autoFocus: true,
              filterType: 'text',
              filterKey: nameFilterKey,
              textEditingController: _nameController,
              focusNode: _nameFocusNode,
              nextFocusNode: _aliasNameFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                _formData['name'] = val;
              },
              buttonOnPressed: (val) {
                nameFilterKey = val;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            FilterKeyFormField(
              labelName: 'AliasName',
              filterType: 'text',
              autoFocus: false,
              filterKey: aliasNameFilterKey,
              textEditingController: _aliasNameController,
              focusNode: _aliasNameFocusNode,
              nextFocusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                _formData['aliasName'] = val;
              },
              buttonOnPressed: (val) {
                aliasNameFilterKey = val;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            Visibility(
              child: FilterKeyFormField(
                labelName: 'Email',
                filterType: 'text',
                autoFocus: false,
                filterKey: emailFilterKey,
                textEditingController: _emailController,
                focusNode: _emailFocusNode,
                nextFocusNode: _mobileFocusNode,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  _formData['email'] = val;
                },
                buttonOnPressed: (val) {
                  emailFilterKey = val;
                },
              ),
              visible: _formData['filterFormName'] == 'Customer' ||
                      _formData['filterFormName'] == 'Vendor'
                  ? true
                  : false,
            ),
            SizedBox(
              height: 15.0,
            ),
            Visibility(
              child: FilterKeyFormField(
                labelName: 'Mobile',
                filterKey: mobileFilterKey,
                filterType: 'text',
                autoFocus: false,
                textEditingController: _mobileController,
                focusNode: _mobileFocusNode,
                nextFocusNode: null,
                textInputAction: TextInputAction.done,
                onChanged: (val) {
                  _formData['mobile'] = val;
                },
                buttonOnPressed: (val) {
                  mobileFilterKey = val;
                },
              ),
              visible: _formData['filterFormName'] == 'Customer' ? true : false,
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
          title: Text(_formData['filterFormName']),
          actions: [
            TextButton(
              onPressed: () {
                _formData['nameFilterKey'] = nameFilterKey;
                _formData['aliasNameFilterKey'] = aliasNameFilterKey;
                _formData['emailFilterKey'] = emailFilterKey;
                _formData['mobileFilterKey'] = mobileFilterKey;
                _formData['isAdvancedFilter'] = 'true';
                Navigator.of(context).pop(_formData);
              },
              child: Text(
                'SEARCH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
        body: _buildFilterForm(context),
      ),
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
    );
  }
}
