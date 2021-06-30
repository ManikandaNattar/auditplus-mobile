import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/product_wise_sales/product_wise_sales_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../utils.dart' as utils;

class ProductWiseSales extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  ProductWiseSales({
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

  Widget _showProductWiseSales(BuildContext context) {
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
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    list[index]['inventory'],
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
                                    list[index]['sold'].toString(),
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        double.parse(list[index]['saleValue']
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
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Visibility(
                                        child: Text(
                                          '(${double.parse(list[index]['assetValue'].abs().toString()).toStringAsFixed(2)})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                letterSpacing: 0.5,
                                              ),
                                          textAlign: TextAlign.end,
                                        ),
                                        visible: utils.checkMenuWiseAccess(
                                          context,
                                          [
                                            'rpt.inv.pdtwspft',
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          double.parse(list[index]
                                                      ['profitValue']
                                                  .abs()
                                                  .toString())
                                              .toStringAsFixed(2),
                                          style: list[index]['profitValue'] < 0
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
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          '(${double.parse(list[index]['profitPercent'].abs().toString()).toStringAsFixed(2)})',
                                          style:
                                              list[index]['profitPercent'] < 0
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                        letterSpacing: 0.5,
                                                        color: Colors.red,
                                                      )
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                        letterSpacing: 0.5,
                                                        color: Colors.green,
                                                      ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                  visible: utils.checkMenuWiseAccess(
                                    context,
                                    [
                                      'rpt.inv.pdtwspft',
                                    ],
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
                  );
                },
              ),
      ),
    );
  }

  Widget _showProductWiseSalesHeader(BuildContext context) {
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
                    padding: const EdgeInsets.only(
                      right: 0.0,
                    ),
                    child: Text(
                      'INVENTORY',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      'SOLD',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Column(
                      children: [
                        Text(
                          'SALE',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                letterSpacing: 0.5,
                              ),
                        ),
                        Visibility(
                          child: Text(
                            '(ASSET)',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      letterSpacing: 0.5,
                                    ),
                          ),
                          visible: utils.checkMenuWiseAccess(
                            context,
                            [
                              'rpt.inv.pdtwspft',
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Column(
                        children: [
                          Text(
                            'PROFIT',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      letterSpacing: 0.5,
                                    ),
                          ),
                          Text(
                            '(PROFIT%)',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      letterSpacing: 0.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    visible: utils.checkMenuWiseAccess(
                      context,
                      [
                        'rpt.inv.pdtwspft',
                      ],
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
              _showProductWiseSalesHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showProductWiseSales(context),
              ProductWiseSalesFooter(
                formData: {
                  'assetValue': formData['assetValue'],
                  'saleValue': formData['saleValue'],
                  'profitValue': formData['profitValue'],
                  'sold': formData['sold'],
                },
              )
            ],
          );
  }
}
