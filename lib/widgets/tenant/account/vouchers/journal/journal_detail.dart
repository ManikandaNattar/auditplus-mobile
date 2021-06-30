import 'package:auditplusmobile/widgets/shared/detail/detail_card.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart' as constants;
import '../../../../../utils.dart' as utils;

class JournalDetail extends StatelessWidget {
  final Map journalData;
  final bool isLoading;
  final String totalAmount;
  JournalDetail({
    @required this.journalData,
    @required this.isLoading,
    @required this.totalAmount,
  });

  Widget _showJournalVoucherHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 2.0,
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                'ACCOUNT',
                style: Theme.of(context).textTheme.headline4.copyWith(
                      letterSpacing: 0.5,
                    ),
              ),
              Text(
                'DEBIT',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      letterSpacing: 0.5,
                    ),
              ),
              Text(
                'CREDIT',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showJournalVoucher(BuildContext context) {
    List list = journalData['trns'];
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  list[idx]['account']['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                Text(
                                  list[idx]['debit'] == 0
                                      ? ''
                                      : double.parse(list[idx]['debit']
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
                                Text(
                                  list[idx]['credit'] == 0
                                      ? ''
                                      : double.parse(list[idx]['credit']
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

  Widget _journalVoucherFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      width: double.infinity,
      height: 45.0,
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                'TOTAL',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                double.parse(
                  totalAmount,
                ).toStringAsFixed(2),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.right,
              ),
              Text(
                double.parse(
                  totalAmount,
                ).toStringAsFixed(2),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, String>> _buildDetailPage() {
    return utils.buildDetailQuery(
      {
        'JOURNAL INFO': {
          'Date': constants.defaultDate.format(
            DateTime.parse(
              journalData['date'],
            ),
          ),
          'Reference No': journalData['refNo'],
          'Description': journalData['description'],
        },
      },
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
              DetailCard(
                _buildDetailPage(),
              ),
              SizedBox(
                height: 5.0,
              ),
              _showJournalVoucherHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showJournalVoucher(context),
              _journalVoucherFooter(context),
            ],
          );
  }
}
