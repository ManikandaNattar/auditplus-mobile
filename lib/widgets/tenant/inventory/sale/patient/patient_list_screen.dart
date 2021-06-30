import 'package:auditplusmobile/providers/inventory/patient_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../main_drawer/main_drawer.dart';
import './../../../../shared/list_view_app_bar.dart';
import './../../../../../utils.dart' as utils;
import '../../../../shared/general_list_view.dart';

class PatientListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Map<String, dynamic>> _patientList = [];
  PatientProvider _patientProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Patient',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getpatientList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _patientProvider = Provider.of<PatientProvider>(context);
    _getpatientList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getpatientList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
      });
      Map response = await _patientProvider.getPatientList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addPatient(data);
      });
      return _patientList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addPatient(List data) {
    _patientList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'title': elm['name'],
            'subtitle': '',
          };
        },
      ).toList(),
    );
  }

  void _appbarSearchFuntion() {
    setState(() {
      pageNo = 1;
      _isLoading = true;
    });
    _formData = {
      'name': widget._appbarSearchEditingController.text,
      'aliasName': '',
      'nameFilterKey': '.a.',
      'aliasNameFilterKey': 'a..',
      'filterFormName': 'Patient',
    };
    _patientList.clear();
    _getpatientList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/inventory/sale-purchase-filter-form', arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _patientList.clear();
          _getpatientList();
        }
      },
    );
  }

  void _clearFilterPressed() {
    setState(() {
      _isLoading = true;
      pageNo = 1;
    });
    _formData = {
      'name': '',
      'aliasName': '',
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'filterFormName': 'Patient',
    };
    _patientList.clear();
    _getpatientList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Patient',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {});
            }
          },
        ),
        drawer: MainDrawer(),
        body: GeneralListView(
          hasMorePages: hasMorePages,
          isLoading: _isLoading,
          routeName: '/inventory/sale/patient/detail',
          list: _patientList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Patient',
            onPressed: () =>
                Navigator.of(context).pushNamed('/inventory/sale/patient/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inv.pat.cr',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/inventory');
        return true;
      },
    );
  }
}
