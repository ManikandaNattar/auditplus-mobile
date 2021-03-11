import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountBookFooter extends StatelessWidget {
  final Map formData;
  AccountBookFooter({@required this.formData});
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
                  'Opening',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['opening'] < 0
                      ? double.parse(formData['opening'].abs().toString())
                              .toStringAsFixed(2) +
                          ' Cr'
                      : double.parse(formData['opening'].toString())
                              .toStringAsFixed(2) +
                          ' Dr',
                  style: formData['opening'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
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
                  'Total Debit',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['debit'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['debit'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
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
                  'Total Credit',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  double.parse(formData['credit'].abs().toString())
                      .toStringAsFixed(2),
                  style: formData['credit'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
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
                  'Closing',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['closing'] < 0
                      ? double.parse(formData['closing'].abs().toString())
                              .toStringAsFixed(2) +
                          ' Cr'
                      : double.parse(formData['closing'].toString())
                              .toStringAsFixed(2) +
                          ' Dr',
                  style: formData['closing'] < 0
                      ? TextStyle(
                          color: Colors.red,
                        )
                      : TextStyle(
                          color: Colors.green,
                        ),
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
