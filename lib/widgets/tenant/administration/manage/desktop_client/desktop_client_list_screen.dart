import 'package:auditplusmobile/providers/administration/desktop_client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class DesktopClientListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _DesktopClientListScreenState createState() =>
      _DesktopClientListScreenState();
}

class _DesktopClientListScreenState extends State<DesktopClientListScreen> {
  List<Map<String, dynamic>> _desktopClientList = [];
  DesktopClientProvider _desktopClientProvider;
  Map _formData = {
    'name': '',
    'nameFilterKey': 'a..',
    'filterFormName': 'Desktop Client',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getDesktopClientList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _desktopClientProvider = Provider.of<DesktopClientProvider>(context);
    _getDesktopClientList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getDesktopClientList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
      });
      Map response = await _desktopClientProvider.getDesktopClientList(
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
        addDesktopClient(data);
      });
      return _desktopClientList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addDesktopClient(List data) {
    _desktopClientList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
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
      'nameFilterKey': '.a.',
      'filterFormName': 'Desktop Client',
    };
    _desktopClientList.clear();
    _getDesktopClientList();
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
          _desktopClientList.clear();
          _getDesktopClientList();
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
      'nameFilterKey': 'a..',
      'filterFormName': 'Desktop Client',
    };
    _desktopClientList.clear();
    _getDesktopClientList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Desktop Client',
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
          routeName: '/administration/manage/desktop-client/detail',
          list: _desktopClientList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Desktop Client',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/desktop-client/form',
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
