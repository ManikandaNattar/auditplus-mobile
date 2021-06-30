import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/shared/sticky_grouped_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_outstanding_footer.dart';

class AccountOutstandingSummary extends StatelessWidget {
  final Map formData;
  final List list;
  final Function onScrollEnd;

  AccountOutstandingSummary({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  Widget _showAccountOutstandingSummary(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : StickyGroupedListView(
                elements: list,
                paginationData: {
                  'hasMorePages': formData['hasMorePages'],
                },
                groupBy: (dynamic element) {
                  return element[formData['groupBy'] + 'Id'];
                },
                onScrollEnd: onScrollEnd,
                groupHeaderBuilder: (dynamic value) {
                  return Container(
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
                  );
                },
                itemBuilder: (BuildContext context, dynamic element) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                formData['groupBy'] == 'branch'
                                    ? element['accountName']
                                    : element['branchName'],
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Expanded(
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
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
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

  @override
  Widget build(BuildContext context) {
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
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'PARTICULARS',
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
              _showAccountOutstandingSummary(context),
              AccountOutstandingFooter(
                totalBalance: formData['totalBalance'],
              ),
            ],
          );
  }
}
