import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'show_data_empty_image.dart';

class VoucherListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final List list;
  final Map formData;
  final Function onScrollEnd;
  VoucherListView({
    @required this.list,
    @required this.formData,
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

  Widget _listHeader(BuildContext context) {
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
            children: [
              TableRow(
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
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      formData['title'],
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
            height: 10.0,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Text(
                      'VOUCHER NO',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      formData['subtitle'],
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _voucherList(BuildContext context) {
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
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      list[index]['refNo'] == ''
                                          ? list[index]['date']
                                          : '${list[index]['date']}_${list[index]['refNo']}',
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
                                      list[index]['toAccount'],
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
                                      double.parse(
                                              list[index]['amount'].toString())
                                          .toStringAsFixed(2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                            fontSize: 14.0,
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
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      list[index]['voucherNo'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      list[index]['byAccount'],
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
                            ],
                          ),
                          Divider(
                            thickness: 0.75,
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pushNamed(
                        formData['routeName'],
                        arguments: {
                          'detail': list[index],
                          'filterData': formData['filterData'],
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
    addScrollListener();
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: Column(
              children: [
                SizedBox(
                  height: 5.0,
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
  }
}
