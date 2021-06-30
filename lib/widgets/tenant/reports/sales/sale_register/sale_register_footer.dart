import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaleRegisterFooter extends StatelessWidget {
  final Map formData;
  SaleRegisterFooter({@required this.formData});
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
                  'Cash',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['cashAmount'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['cashAmount'] < 0
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
                  'Bank',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['bankAmount'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['bankAmount'] < 0
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
                  'EFT',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['eftAmount'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['eftAmount'] < 0
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
                  'Credit',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['creditAmount'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['creditAmount'] < 0
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
                  'Total',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['total'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['total'] < 0
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
        ],
      ),
    );
  }
}
