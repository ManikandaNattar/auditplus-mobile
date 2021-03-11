import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../main_drawer/main_drawer.dart';
import './../../../../shared/list_view_app_bar.dart';
import './../../../../../providers/contacts/doctor_provider.dart';
import './../../../../../utils.dart' as utils;
import '../../../../shared/general_list_view.dart';

class DoctorListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> _doctorList = [];
  DoctorProvider _doctorProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Doctor',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getdoctorList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _doctorProvider = Provider.of<DoctorProvider>(context);
    _getdoctorList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getdoctorList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
      });
      Map response = await _doctorProvider.getDoctorList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
      );
      hasMorePages = response['hasMorePages'];
      List data = response['results'];
      setState(() {
        _isLoading = false;
        addDoctor(data);
      });
      return _doctorList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addDoctor(List data) {
    _doctorList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['licenseNumber'],
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
      'filterFormName': 'Doctor',
    };
    _doctorList.clear();
    _getdoctorList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/contacts/manage/contacts-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _doctorList.clear();
          _getdoctorList();
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
      'filterFormName': 'Doctor',
    };
    _doctorList.clear();
    _getdoctorList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Doctor',
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
          routeName: '/contacts/manage/doctor/detail',
          list: _doctorList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Doctor',
            onPressed: () =>
                Navigator.of(context).pushNamed('/contacts/manage/doctor/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'contacts.doctor.create',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/contacts');
        return true;
      },
    );
  }
}
