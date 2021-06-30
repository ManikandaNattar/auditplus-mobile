import 'package:auditplusmobile/providers/inventory/section_provider.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class SectionListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _SectionListScreenState createState() => _SectionListScreenState();
}

class _SectionListScreenState extends State<SectionListScreen> {
  List<Map<String, dynamic>> _sectionList = [];
  SectionProvider _sectionProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Section',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getSectionList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _sectionProvider = Provider.of<SectionProvider>(context);
    _getSectionList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getSectionList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
      });
      Map response = await _sectionProvider.getSectionList(
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
        addSection(data);
      });
      return _sectionList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addSection(List data) {
    _sectionList.addAll(
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
      'filterFormName': 'Section',
    };
    _sectionList.clear();
    _getSectionList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/inventory/manage/inventory-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _sectionList.clear();
          _getSectionList();
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
      'filterFormName': 'Section',
    };
    _sectionList.clear();
    _getSectionList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Section',
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
          routeName: '/inventory/manage/section/detail',
          list: _sectionList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Section',
            onPressed: () => Navigator.of(context)
                .pushNamed('/inventory/manage/section/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'inv.sec.cr',
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
