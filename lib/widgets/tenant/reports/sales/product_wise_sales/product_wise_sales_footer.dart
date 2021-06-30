import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../utils.dart' as utils;

class ProductWiseSalesFooter extends StatelessWidget {
  final Map formData;
  ProductWiseSalesFooter({@required this.formData});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Total Asset Value',
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    double.parse(formData['assetValue'].abs().toString())
                        .toStringAsFixed(2),
                    style: formData['assetValue'] < 0
                        ? TextStyle(
                            color: Colors.red,
                          )
                        : TextStyle(
                            color: Colors.green,
                          ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.0,
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
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Total Sold',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['sold'].abs().toString(),
                  style: formData['sold'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Total Sale Value',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['saleValue'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['saleValue'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Visibility(
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Total Profit',
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    double.parse(formData['profitValue'].abs().toString())
                        .toStringAsFixed(2),
                    style: formData['profitValue'] < 0
                        ? TextStyle(
                            color: Colors.red,
                          )
                        : TextStyle(
                            color: Colors.green,
                          ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.0,
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
    );
  }
}
