import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  final String message;
  ProgressLoader({
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width - 100,
        color: Colors.grey[200],
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 10.0,
            ),
            Text(
              message,
            ),
          ],
        ),
      ),
    );
  }
}
