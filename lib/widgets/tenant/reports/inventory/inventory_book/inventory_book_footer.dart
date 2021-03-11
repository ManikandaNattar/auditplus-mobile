import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryBookFooter extends StatelessWidget {
  final Map formData;
  InventoryBookFooter({@required this.formData});
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
                  formData['opening'].abs().toString(),
                  style: formData['opening'] < 0
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
                  'Total Inward',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['inward'].abs().toString(),
                  style: formData['inward'] < 0
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
                  'Total Outward',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['outward'].abs().toString(),
                  style: formData['outward'] < 0
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
                  'Closing',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  formData['closing'].abs().toString(),
                  style: formData['closing'] < 0
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
