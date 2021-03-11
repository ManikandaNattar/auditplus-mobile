import 'package:auditplusmobile/providers/administration/branch_provider.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class BranchListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _BranchListScreenState createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  List<Map<String, dynamic>> _branchList = [];
  BranchProvider _branchProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'users': '',
    'desktopClients': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Branch',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getBranchList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _branchProvider = Provider.of<BranchProvider>(context);
    _getBranchList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getBranchList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
        {'users': 'eq'}: _formData['users'],
        {'desktopClients': 'eq'}: _formData['desktopClients'],
      });
      Map response = await _branchProvider.getBranchList(
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
        addBranch(data);
      });
      return _branchList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addBranch(List data) {
    _branchList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['contactInfo'] == null
                ? ''
                : elm['contactInfo']['mobile'] == null
                    ? ''
                    : elm['contactInfo']['mobile'],
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
      'nameFilterKey': '.a.',
      'filterFormName': 'Branch',
      'users': '',
      'desktopClients': '',
      'aliasNameFilterKey': 'a..',
    };
    _branchList.clear();
    _getBranchList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/administration/manage/administration-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _branchList.clear();
          _getBranchList();
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
      'users': '',
      'desktopClients': '',
      'nameFilterKey': 'a..',
      'aliasNameFilterKey': 'a..',
      'filterFormName': 'Branch',
    };
    _branchList.clear();
    _getBranchList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Branch',
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
          routeName: '/administration/manage/branch/detail',
          list: _branchList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Branch',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/branch/form',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/administration');
        return true;
      },
    );
  }
}
