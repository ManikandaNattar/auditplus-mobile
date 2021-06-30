import 'package:auditplusmobile/providers/accounting/voucher_provider.dart';
import 'package:auditplusmobile/providers/auth/tenant_auth_provider.dart';
import 'package:auditplusmobile/widgets/shared/list_view_app_bar.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/main_drawer/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../utils.dart' as utils;
import './../../../../../constants.dart' as constants;

class JournalListScreen extends StatefulWidget {
  final TextEditingController _appbarSearchEditingController =
      TextEditingController();
  @override
  _JournalListScreenState createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  VoucherProvider _voucherProvider;
  List<Map<String, dynamic>> _journalList = [];
  ScrollController _scrollController = ScrollController();
  int pageNo = 1;
  bool hasMorePages;
  bool _isLoading = true;
  TenantAuth _tenantAuth;
  Map _selectedBranch = {};
  Map args = {};
  Map _formData = {
    'fromDate': '',
    'toDate': '',
    'voucherNo': '',
    'refNo': '',
    'account': '',
    'voucherNoFilterKey': 'a..',
    'refNoFilterKey': 'a..',
    'isAdvancedFilter': 'true',
    'filterFormName': 'Journal',
  };

  @override
  void initState() {
    addScrollListener();
    super.initState();
  }

  void onScrollEnd() {
    if (hasMorePages == true) {
      setState(() {
        pageNo += 1;
        _getJournalList();
      });
    }
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _voucherProvider = Provider.of<VoucherProvider>(context);
    _tenantAuth = Provider.of<TenantAuth>(context);
    _selectedBranch = _tenantAuth.selectedBranch;
    args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _formData = args;
    }
    _getJournalList();
    super.didChangeDependencies();
  }

  Future<void> _getJournalList() async {
    try {
      Map<String, dynamic> searchQuery = utils.buildSearchQuery({
        {'fromDate': 'gte'}: _formData['fromDate'] == null
            ? ''
            : constants.isoDateFormat.format(
                _formData['fromDate'] == ''
                    ? DateTime.now()
                    : constants.defaultDate.parse(
                        _formData['fromDate'],
                      ),
              ),
        {'toDate': 'lte'}: _formData['toDate'] == null
            ? ''
            : constants.isoDateFormat.format(
                _formData['toDate'] == ''
                    ? DateTime.now()
                    : constants.defaultDate.parse(
                        _formData['toDate'],
                      ),
              ),
        {'voucherNo': _formData['voucherNoFilterKey']}: _formData['voucherNo'],
        {'refNo': _formData['refNoFilterKey']}: _formData['refNo'],
        {'account': 'eq'}: _formData['account'],
      });
      final response = await _voucherProvider.getVoucherList(
        searchQuery,
        pageNo,
        25,
        '',
        '',
        'JOURNAL',
        _selectedBranch['id'],
      );
      List data = response['records'];
      hasMorePages = utils.checkHasMorePages(response['pageContext'], pageNo);
      setState(() {
        _isLoading = false;
        addJournal(data);
      });
      return _journalList;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      utils.handleErrorResponse(context, error.message, 'tenant');
      return [];
    }
  }

  void addJournal(List data) {
    _journalList.addAll(
      data.map(
        (elm) {
          return {
            'id': elm['id'],
            'date': constants.defaultDate.format(DateTime.parse(elm['date'])),
            'voucherNo': elm['voucherNo'],
            'refNo': elm['refNo'] == null ? '' : elm['refNo'],
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
      'fromDate': null,
      'toDate': null,
      'voucherNo': widget._appbarSearchEditingController.text,
      'refNo': '',
      'account': '',
      'voucherNoFilterKey': '.a.',
      'refNoFilterKey': 'a..',
      'filterFormName': 'Journal',
    };
    _journalList = [];
    _getJournalList();
  }

  void _openAdvancedFilter() {
    Navigator.of(context)
        .pushNamed('/accounts/vouchers/accounts-vouchers-filter-form',
            arguments: _formData)
        .then(
      (value) {
        if (value != null) {
          setState(() {
            _isLoading = true;
            _formData = value;
            pageNo = 1;
          });
          _journalList.clear();
          _getJournalList();
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
      'fromDate': null,
      'toDate': null,
      'voucherNo': '',
      'refNo': '',
      'account': '',
      'voucherNoFilterKey': 'a..',
      'refNoFilterKey': 'a..',
      'filterFormName': 'Journal',
    };
    _journalList.clear();
    _getJournalList();
  }

  Widget _listHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              'DATE_REF.NO',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              'VOU.NO',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _voucherList(BuildContext context) {
    return Expanded(
      child: Container(
        child: _journalList.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: hasMorePages == true
                    ? _journalList.length + 1
                    : _journalList.length,
                itemBuilder: (_, index) {
                  if (index == _journalList.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 0.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 7.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  _journalList[index]['refNo'] == ''
                                      ? _journalList[index]['date']
                                      : '${_journalList[index]['date']}_${_journalList[index]['refNo']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 7.0,
                                ),
                                child: Text(
                                  _journalList[index]['voucherNo'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            thickness: 0.75,
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pushNamed(
                        '/accounts/vouchers/journal/detail',
                        arguments: {
                          'detail': _journalList[index],
                          'filterData': _formData,
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: ListViewAppBar(
          title: 'Journal',
          searchQueryController: widget._appbarSearchEditingController,
          searchFunction: _appbarSearchFuntion,
          filterIconPressed: _openAdvancedFilter,
          isAdvancedFilter: _formData.keys.contains('isAdvancedFilter'),
          clearFilterPressed: _clearFilterPressed,
          getSelectedBranch: (val) {
            if (val != null) {
              setState(() {
                _selectedBranch = val;
                _isLoading = true;
              });
              _journalList = [];
              _getJournalList();
            }
          },
        ),
        drawer: MainDrawer(),
        body: Builder(
          builder: (BuildContext context) {
            return _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        _listHeader(context),
                        Divider(
                          thickness: 1.0,
                        ),
                        _voucherList(context),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  );
          },
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Journal Voucher',
            onPressed: () => Navigator.of(context).pushNamed(
              '/accounts/vouchers/journal/form',
              arguments: {
                'filterData': _formData,
              },
            ),
          ),
          visible: utils.checkMenuWiseAccess(
            context,
            [
              'ac.jo.cr',
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
