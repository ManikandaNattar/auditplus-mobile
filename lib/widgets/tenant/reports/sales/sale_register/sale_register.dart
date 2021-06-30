import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/sales/sale_register/sale_register_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaleRegister extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  SaleRegister({
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

  Widget _showSaleRegister(BuildContext context) {
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
                                    double.parse(list[index]['amount']
                                            .abs()
                                            .toString())
                                        .toStringAsFixed(2),
                                    style: list[index]['amount'] < 0
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

  Widget _showSaleRegisterHeader(BuildContext context) {
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
              _showSaleRegisterHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showSaleRegister(context),
              SaleRegisterFooter(
                formData: {
                  'cashAmount': formData['cashAmount'],
                  'bankAmount': formData['bankAmount'],
                  'eftAmount': formData['eftAmount'],
                  'creditAmount': formData['creditAmount'],
                  'total': formData['totalAmount'],
                },
              ),
            ],
          );
  }
}
