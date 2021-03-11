import 'package:auditplusmobile/providers/administration/sale_incharge_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class SaleInchargeFormScreen extends StatefulWidget {
  @override
  _SaleInchargeFormScreenState createState() => _SaleInchargeFormScreenState();
}

class _SaleInchargeFormScreenState extends State<SaleInchargeFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _screenContext;
  SaleInchargeProvider _saleInchargeProvider;
  String saleInchargeId = '';
  String saleInchargeName = '';
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _codeFocusNode = FocusNode();
  Map<String, dynamic> _saleInchargeDetail = Map();
  Map arguments = Map();
  Map<String, dynamic> _saleInchargeData = {};
  @override
  void dispose() {
    _nameFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _saleInchargeProvider = Provider.of<SaleInchargeProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      _getSaleIncharge();
    }
    super.didChangeDependencies();
  }

  Map<String, dynamic> _getSaleIncharge() {
    _saleInchargeDetail = arguments['detail'];
    saleInchargeId = _saleInchargeDetail['id'];
    saleInchargeName = _saleInchargeDetail['name'];
    return _saleInchargeDetail;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        if (saleInchargeId.isEmpty) {
          await _saleInchargeProvider.createSalesIncharge(_saleInchargeData);
          utils.showSuccessSnackbar(
              _screenContext, 'Sale Incharge Created Successfully');
        } else {
          await _saleInchargeProvider.updateSalesIncharge(
              saleInchargeId, _saleInchargeData);
          utils.showSuccessSnackbar(
              _screenContext, 'Sale Incharge updated Successfully');
        }
        Future.delayed(Duration(seconds: 1)).then((value) =>
            Navigator.of(_screenContext)
                .pushReplacementNamed('/administration/manage/sale-incharge'));
      } catch (error) {
        utils.handleErrorResponse(_screenContext, error.message, 'tenant');
      }
    }
  }

  Widget _saleInchargeFormGeneralInfoContainer() {
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
                    initialValue: _saleInchargeDetail['name'],
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
                      FocusScope.of(context).requestFocus(_codeFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      if (val.isNotEmpty) {
                        _saleInchargeData.addAll({'name': val});
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: _saleInchargeDetail['code'],
                    focusNode: _codeFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      labelStyle: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subtitle1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Code should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _saleInchargeData.addAll({'code': val});
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
            saleInchargeName.isEmpty ? 'Add Sale Incharge' : saleInchargeName,
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
                      _saleInchargeFormGeneralInfoContainer(),
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
