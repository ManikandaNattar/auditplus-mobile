import 'package:auditplusmobile/widgets/shared/detail/detail_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final Map<String, Map<String, dynamic>> detail;
  DetailCard(this.detail);

  Widget _detailCardContainer(
      BuildContext context, String title, Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ...data.entries.map(
              (entry) => DetailItem(
                entry.key,
                entry.value,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...detail.entries
            .map((e) => _detailCardContainer(context, e.key, e.value))
            .toList(),
      ],
    );
  }
}
