import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:auditplusmobile/widgets/tenant/reports/inventory/inventory_book/inventory_book_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryBook extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Map formData;
  final List list;
  final Function onScrollEnd;
  InventoryBook({
    @required this.formData,
    @required this.list,
    @required this.onScrollEnd,
  });

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  Widget _showInventoryBook(BuildContext context) {
    return Expanded(
      child: Container(
        child: list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.separated(
                controller: _scrollController,
                itemCount: int.parse(formData['maxPage'].toString()) >
                        int.parse(formData['pageNo'].toString())
                    ? list.length + 1
                    : list.length,
                itemBuilder: (_, index) {
                  if (index == list.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(150.0),
                            1: FlexColumnWidth(
                              MediaQuery.of(context).size.width - 160.0,
                            ),
                          },
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    '${list[index]['date']}-${list[index]['refNo']}-${list[index]['voucherType']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        list[index]['inward'] == 0
                                            ? list[index]['outward']
                                                .abs()
                                                .toString()
                                            : list[index]['inward']
                                                .abs()
                                                .toString(),
                                        style: list[index]['inward'] == 0 &&
                                                list[index]['outward'] > 0
                                            ? Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                  letterSpacing: 0.5,
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                )
                                            : Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                  letterSpacing: 0.5,
                                                  color: Colors.green,
                                                  fontSize: 14,
                                                ),
                                      ),
                                      list[index]['inward'] <= 0 &&
                                              list[index]['outward'] > 0
                                          ? Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.arrow_drop_up,
                                              color: Colors.green,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            list[index]['particulars'],
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      letterSpacing: 0.5,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 0.75,
                  );
                },
              ),
      ),
    );
  }

  Widget _showInventoryBookHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 0.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(240.0),
              1: FlexColumnWidth(
                MediaQuery.of(context).size.width - 280.0,
              ),
            },
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
                      'QUANTITY',
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
          SizedBox(
            height: 7.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'PARTICULARS',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    addScrollListener();
    return formData['isLoading'] == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              _showInventoryBookHeader(context),
              Divider(
                thickness: 1.0,
              ),
              _showInventoryBook(context),
              InventoryBookFooter(
                formData: {
                  'inward': formData['inward'],
                  'outward': formData['outward'],
                  'opening': formData['opening'],
                  'closing': formData['closing'],
                  'unit': formData['unit'],
                },
              ),
            ],
          );
  }
}
