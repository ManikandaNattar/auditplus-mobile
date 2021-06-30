import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../../../../constants.dart' as constants;

class StockAnalysisHeader extends StatelessWidget {
  final Map formData;
  StockAnalysisHeader({@required this.formData});

  @override
  Widget build(BuildContext context) {
    String groupBy =
        formData['stockAnalysisGroupBy'].toString().split('.').last;
    List _nameList = formData['${groupBy.toLowerCase()}List'] == ''
        ? null
        : formData['${groupBy.toLowerCase()}List'];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0.0,
                  13.0,
                  3.0,
                  0.0,
                ),
                child: Text(
                  'AS ON DATE:',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Text(
                    constants.defaultDate.format(
                      formData['asOnDate'] == ''
                          ? DateTime.now()
                          : DateTime.parse(
                              formData['asOnDate'],
                            ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0.0,
                  13.0,
                  10.0,
                  0.0,
                ),
                child: Text(
                  'GROUP BY:',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Text(
                    groupBy == '' ? 'INVENTORY' : '${groupBy.toUpperCase()}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            child: Column(
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        0.0,
                        13.0,
                        20.0,
                        0.0,
                      ),
                      child: Text(
                        'BRANCH:',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    formData['rptBranchList'] == ''
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Text(
                                'ALL',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: formData['rptBranchList'].length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Text(
                                        formData['rptBranchList'][index]['name']
                                            .toString()
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            visible: formData['filterFormName'] == null,
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0.0,
                  13.0,
                  3.0,
                  0.0,
                ),
                child: Text(
                  groupBy == '' ? 'INVENTORY:' : '${groupBy.toUpperCase()}:',
                  textAlign: TextAlign.center,
                ),
              ),
              _nameList == null || _nameList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Text(
                          'ALL',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              formData['${groupBy.toLowerCase()}List'].length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  formData['${groupBy.toLowerCase()}List']
                                          [index]['name']
                                      .toString()
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
