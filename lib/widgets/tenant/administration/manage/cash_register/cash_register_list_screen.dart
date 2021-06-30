import 'package:auditplusmobile/providers/administration/cash_register_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:auditplusmobile/widgets/shared/general_list_view.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;

class CashRegisterListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _CashRegisterListScreenState createState() => _CashRegisterListScreenState();
}

class _CashRegisterListScreenState extends State<CashRegisterListScreen> {
  List<Map<String, dynamic>> _cashRegisterList = [];
  CashRegisterProvider _cashRegisterProvider;
  Map _formData = {
    'name': '',
    'aliasName': '',
    'nameFilterKey': 'a..',
    'aliasNameFilterKey': 'a..',
    'filterFormName': 'Cash Register',
  };
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getCashRegisterList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _cashRegisterProvider = Provider.of<CashRegisterProvider>(context);
    _getCashRegisterList();
    super.didChangeDependencies();
  }

  Future<List<Map<String, dynamic>>> _getCashRegisterList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'name': _formData['nameFilterKey']}: _formData['name'],
        {'aliasName': _formData['aliasNameFilterKey']}: _formData['aliasName'],
      });
      Map response = await _cashRegisterProvider.getCashRegisterList(
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
        addCashRegister(data);
      });
      return _cashRegisterList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addCashRegister(List data) {
    _cashRegisterList.addAll(
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
      'filterFormName': 'Cash Register',
      'aliasNameFilterKey': 'a..',
    };
    _cashRegisterList.clear();
    _getCashRegisterList();
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
          _cashRegisterList.clear();
          _getCashRegisterList();
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
      'filterFormName': 'Cash Register',
    };
    _cashRegisterList.clear();
    _getCashRegisterList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Cash Register',
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
          routeName: '/administration/manage/cash-register/detail',
          list: _cashRegisterList,
          onScrollEnd: onScrollEnd,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add Cash Register',
          onPressed: () => Navigator.of(context).pushNamed(
            '/administration/manage/cash-register/form',
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
