import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDataEmptyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_cellular_no_sim_outlined,
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
            Text(
              'No record found...',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
