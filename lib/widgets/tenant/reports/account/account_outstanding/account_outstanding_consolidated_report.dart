import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_outstanding_footer.dart';

class AccountOutstandingConsolidatedReport extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;

  AccountOutstandingConsolidatedReport({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  Widget _showConsolidatedReport(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: formData['hasMorePages'] == true
                    ? list.length + 1
                    : list.length,
                itemBuilder: (_, index) {
                  if (index == list.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                list[index]['particulars'],
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                list[index]['closing'] < 0
                                    ? double.parse(list[index]['closing']
                                                .abs()
                                                .toString())
                                            .toStringAsFixed(2) +
                                        ' Cr'
                                    : double.parse(list[index]['closing']
                                                .toString())
                                            .toStringAsFixed(2) +
                                        ' Dr',
                                style: list[index]['closing'] < 0
                                    ? Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          color: Colors.red,
                                          letterSpacing: 0.5,
                                          fontSize: 14.0,
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          color: Colors.green,
                                          letterSpacing: 0.5,
                                          fontSize: 14.0,
                                        ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addScrollListener();
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 0.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formData['groupBy'].toString().toUpperCase(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'BALANCE',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5.0,
              ),
              _showConsolidatedReport(context),
              AccountOutstandingFooter(
                totalBalance: formData['totalBalance'],
              )
            ],
          );
  }
}
