import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/shared/sticky_grouped_list_view.dart';
import 'package:auditplusmobile/widgets/tenant/reports/vendor/vendor_outstanding/vendor_outstanding_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorOutstandingSummary extends StatelessWidget {
  final Map formData;
  final List list;
  final Function onScrollEnd;

  VendorOutstandingSummary({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  Widget _showVendorOutstandingSummary(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : StickyGroupedListView(
                elements: list,
                paginationData: {
                  'maxPage': formData['maxPage'],
                  'pageNo': formData['pageNo'],
                },
                groupBy: (dynamic element) {
                  return element[formData['groupBy'] + 'Id'];
                },
                onScrollEnd: onScrollEnd,
                groupHeaderBuilder: (dynamic value) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    list
                        .lastWhere((element) =>
                            element[formData['groupBy'] + 'Id'] ==
                            value)[formData['groupBy'] + 'Name']
                        .toString()
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                itemBuilder: (BuildContext context, dynamic element) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formData['groupBy'] == 'branch'
                                  ? element['vendorName']
                                  : element['branchName'],
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              element['closing'] < 0
                                  ? double.parse(element['closing']
                                              .abs()
                                              .toString())
                                          .toStringAsFixed(2) +
                                      ' Cr'
                                  : double.parse(element['closing'].toString())
                                          .toStringAsFixed(2) +
                                      ' Dr',
                              style: element['closing'] > 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        color: Colors.red,
                                        letterSpacing: 0.5,
                                        fontSize: 14.0,
                                      )
                                  : Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        color: Colors.green,
                                        letterSpacing: 0.5,
                                        fontSize: 14.0,
                                      ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'PARTICULARS',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'BALANCE',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5.0,
              ),
              _showVendorOutstandingSummary(context),
              VendorOutstandingFooter(
                totalBalance: formData['totalBalance'],
              ),
            ],
          );
  }
}
