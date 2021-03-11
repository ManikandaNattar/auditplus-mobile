import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  final bool pdfLoading;
  final String message;
  ProgressLoader({
    @required this.pdfLoading,
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          width: MediaQuery.of(context).size.width - 100,
          color: Color(0xffF7F7F7),
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
      ),
      visible: pdfLoading,
    );
  }
}
