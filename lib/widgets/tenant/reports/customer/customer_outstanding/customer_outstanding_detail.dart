import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/shared/sticky_grouped_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer_outstanding_footer.dart';

class CustomerOutstandingDetail extends StatelessWidget {
  final Map formData;
  final List list;
  final Function onScrollEnd;

  CustomerOutstandingDetail({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  Widget _showCustomerOutstandingDetail(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : StickyGroupedListView(
                elements: list,
                paginationData: {
                  'maxPage': formData['maxPage'],
                  'pageNo': formData['pageNo'],
                },
                groupBy: (dynamic element) {
                  return element[formData['groupBy'] + 'Id'];
                },
                onScrollEnd: onScrollEnd,
                groupHeaderBuilder: (dynamic value) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    list
                        .lastWhere((element) =>
                            element[formData['groupBy'] + 'Id'] ==
                            value)[formData['groupBy'] + 'Name']
                        .toString()
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                itemBuilder: (BuildContext context, dynamic element) =>
                    Container(
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
                          0: FlexColumnWidth(120.0),
                          1: FlexColumnWidth(
                            MediaQuery.of(context).size.width - 160.0,
                          ),
                          2: FlexColumnWidth(30.0),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  '${element['effDate']}-${element['refNo']}-${element['voucherType']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  element['closing'] < 0
                                      ? double.parse(element['closing']
                                                  .abs()
                                                  .toString())
                                              .toStringAsFixed(2) +
                                          ' Cr'
                                      : double.parse(
                                                  element['closing'].toString())
                                              .toStringAsFixed(2) +
                                          ' Dr',
                                  style: element['closing'] < 0
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
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Text(
                                element['days'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      letterSpacing: 0.5,
                                    ),
                                textAlign: TextAlign.right,
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
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(120.0),
                            1: FlexColumnWidth(
                              MediaQuery.of(context).size.width - 160.0,
                            ),
                          },
                          children: [
                            TableRow(children: [
                              Text(
                                formData['groupBy'] == 'branch'
                                    ? element['customerName']
                                    : element['branchName'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Text(
                                  element['opening'] < 0
                                      ? double.parse(element['opening']
                                                  .abs()
                                                  .toString())
                                              .toStringAsFixed(2) +
                                          ' Cr'
                                      : double.parse(
                                                  element['opening'].toString())
                                              .toStringAsFixed(2) +
                                          ' Dr',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _showCustomerOutstandingHeader(BuildContext context) {
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
              0: FlexColumnWidth(200.0),
              1: FlexColumnWidth(
                MediaQuery.of(context).size.width - 280.0,
              ),
              2: FlexColumnWidth(40.0),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Text(
                      'DATE-REF.NO-VOU.TYPE',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      'BALANCE',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Text(
                    'DAYS',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          letterSpacing: 0.5,
                        ),
                    textAlign: TextAlign.right,
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
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(120.0),
                1: FlexColumnWidth(
                  MediaQuery.of(context).size.width - 160.0,
                ),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'PARTICULARS',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        'BILL AMOUNT',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              _showCustomerOutstandingHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showCustomerOutstandingDetail(context),
              CustomerOutstandingFooter(
                totalBalance: formData['totalBalance'],
              ),
            ],
          );
  }
}
