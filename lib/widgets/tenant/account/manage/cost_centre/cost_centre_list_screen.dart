import 'package:auditplusmobile/providers/accounting/cost_centre_provider.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CostCentreListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _CostCentreListScreenState createState() => _CostCentreListScreenState();
}

class _CostCentreListScreenState extends State<CostCentreListScreen> {
  List<Map<String, dynamic>> _costCentreList = [];
  CostCentreProvider _costCentreProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'category': '',
    'filterFormName': 'Cost Centre',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getCostCentreList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _costCentreProvider = Provider.of<CostCentreProvider>(context);
    _getCostCentreList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getCostCentreList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
        {'category': 'eq'}: _formData['category'],
      });
      Map response = await _costCentreProvider.getCostCentreList(
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
        addCostCentre(data);
      });
      return _costCentreList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addCostCentre(List data) {
    _costCentreList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'displayName': elm['displayName'],
            'title': elm['name'],
            'subtitle': elm['category']['name'],
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
      'category': '',
      'filterFormName': 'Cost Centre',
    };
    _costCentreList.clear();
    _getCostCentreList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/accounts/manage/accounts-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _costCentreList.clear();
          _getCostCentreList();
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
      'category': '',
      'filterFormName': 'Cost Centre',
    };
    _costCentreList.clear();
    _getCostCentreList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Cost Centre',
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
          routeName: '/accounts/manage/cost-centre/detail',
          list: _costCentreList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Cost Centre',
            onPressed: () => Navigator.of(context)
                .pushNamed('/accounts/manage/cost-centre/form'),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'accounting.costCentre.create',
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/accounts');
        return true;
      },
    );
  }
}
