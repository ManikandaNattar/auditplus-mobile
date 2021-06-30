import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../show_data_empty_image.dart';
import 'report_book_footer.dart';

class ReportBook extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  ReportBook({
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

  Widget _showReportBook(BuildContext context) {
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
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(
                              MediaQuery.of(context).size.width - 150.0,
                            ),
                            1: FlexColumnWidth(
                              160.0,
                            ),
                          },
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    list[index]['refNo'] == ''
                                        ? '${list[index]['date']}_${list[index]['voucherType']}'
                                        : '${list[index]['date']}_${list[index]['refNo']}_${list[index]['voucherType']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    list[index]['debit'] == 0
                                        ? double.parse(list[index]['credit']
                                                    .abs()
                                                    .toString())
                                                .toStringAsFixed(2) +
                                            ' Cr'
                                        : double.parse(list[index]['debit']
                                                    .toString())
                                                .toStringAsFixed(2) +
                                            ' Dr',
                                    style: list[index]['debit'] == 0
                                        ? Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                              color: Colors.red,
                                              fontSize: 14,
                                            )
                                        : Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                              color: Colors.green,
                                              fontSize: 14,
                                            ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 7.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  list[index]['particulars'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          visible:
                              list[index]['particulars'].toString().isNotEmpty,
                        ),
                        Divider(
                          thickness: 0.75,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _showreportBookHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 0.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(240.0),
              1: FlexColumnWidth(
                MediaQuery.of(context).size.width - 280.0,
              ),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Text(
                      'DATE_REF.NO_VOU.TYPE',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      'AMOUNT',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'PARTICULARS',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              _showreportBookHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showReportBook(context),
              ReportBookFooter(
                reportName: formData['reportName'],
                formData: {
                  'credit': formData['credit'],
                  'debit': formData['debit'],
                  'opening': formData['opening'],
                  'closing': formData['closing'],
                },
              ),
            ],
          );
  }
}
