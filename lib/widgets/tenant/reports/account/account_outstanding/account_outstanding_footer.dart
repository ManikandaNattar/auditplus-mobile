import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountOutstandingFooter extends StatelessWidget {
  final double totalBalance;

  AccountOutstandingFooter({
    @required this.totalBalance,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      padding: EdgeInsets.all(8.0),
      height: 45.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TOTAL BALANCE',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Text(
            totalBalance < 0
                ? double.parse(totalBalance.abs().toString())
                        .toStringAsFixed(2) +
                    ' Cr'
                : double.parse(totalBalance.toString()).toStringAsFixed(2) +
                    ' Dr',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
