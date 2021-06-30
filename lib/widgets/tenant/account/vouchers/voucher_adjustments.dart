import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoucherAdjustments extends StatelessWidget {
  final List list;
  final bool isLoading;
  VoucherAdjustments({
    @required this.list,
    @required this.isLoading,
  });
  Widget _showVoucherAdjustments(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, idx) {
                  return Container(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    list[idx]['refNo'] == null &&
                                            list[idx]['voucherType'] == null
                                        ? list[idx]['date']
                                        : list[idx]['refNo'] == null
                                            ? '${list[idx]['date']}-${list[idx]['voucherType']}'
                                            : list[idx]['voucherType'] == null
                                                ? '${list[idx]['date']}-${list[idx]['refNo']}'
                                                : '${list[idx]['date']}-${list[idx]['refNo']}-${list[idx]['voucherType']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    double.parse(list[idx]['amount']
                                            .abs()
                                            .toString())
                                        .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                          fontSize: 14.0,
                                        ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 0.75,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _showVoucherAdjustmentDetailHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
                child: Text(
                  'DATE-REF.NO-VOU.TYPE',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  'ADJ.AMOUNT',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              _showVoucherAdjustmentDetailHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showVoucherAdjustments(context),
            ],
          );
  }
}
