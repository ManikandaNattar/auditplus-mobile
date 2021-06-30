import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../utils.dart' as utils;

class StockAnalysisFooter extends StatelessWidget {
  final Map formData;
  StockAnalysisFooter({@required this.formData});
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
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Total Stock',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['totalStock'].abs().toString(),
                  style: formData['totalStock'] < 0
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
                    'Total Values',
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    formData['totalValues'].abs().toString(),
                    style: formData['totalValues'] < 0
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
                'rpt.inv.stkvalsum',
              ],
            ),
          ),
        ],
      ),
    );
  }
}
