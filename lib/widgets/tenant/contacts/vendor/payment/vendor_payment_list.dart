import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorPaymentList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  VendorPaymentList({
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

  Widget _showPaymentList(BuildContext context) {
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
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(150.0),
                                1: FlexColumnWidth(150.0),
                                2: FlexColumnWidth(
                                  MediaQuery.of(context).size.width - 160.0,
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
                                        '${list[index]['date']}-${list[index]['refNo']}',
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
                                        right: 10.0,
                                      ),
                                      child: Text(
                                        list[index]['toAccount']['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 25.0),
                                      child: Text(
                                        double.parse(list[index]['amount']
                                                .abs()
                                                .toString())
                                            .toStringAsFixed(2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              letterSpacing: 0.5,
                                              fontSize: 14,
                                            ),
                                        textAlign: TextAlign.end,
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
                                list[index]['byAccount']['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                            Divider(
                              thickness: 0.75,
                            ),
                          ],
                        ),
                        Visibility(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          visible: list[index]['reviewStatus'],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _showPaymentListHeader(BuildContext context) {
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
              0: FlexColumnWidth(100.0),
              1: FlexColumnWidth(100.0),
              2: FlexColumnWidth(
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
                      'DATE-REF.NO',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 0.0,
                    ),
                    child: Text(
                      'VENDOR',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
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
              'PAID THROUGH',
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
              _showPaymentListHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showPaymentList(context),
            ],
          );
  }
}
