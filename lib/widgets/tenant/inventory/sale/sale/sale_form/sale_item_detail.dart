import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaleItemDetail extends StatelessWidget {
  final Map<Map, List> saleItemsList;
  SaleItemDetail(
    this.saleItemsList,
  );

  Widget _saleItemsWidget(
    BuildContext context,
    Map header,
    List data,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header['title'],
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                header['amount'],
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount(%): ${header['disc']}',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                header['discAmount'],
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax(%): ${header['tax']}',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                header['taxAmount'],
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          ...data.map(
            (e) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Batch No : ${e['batchNo'] ?? ''}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'Expiry : ${e['expiry'] ?? ''}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'MRP : ${e['mrp'].toString() ?? ''}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'Stock : ${e['closing'].toString() ?? ''}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                        Text(
                          '${e['qty'].toString()} ${e['unit']} X \u{20B9} ${e['rate'].toString()} = ${e['qty'] * e['rate']}',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 0.75,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ...saleItemsList.entries
              .map((e) => _saleItemsWidget(context, e.key, e.value))
              .toList(),
        ],
      ),
    );
  }
}
