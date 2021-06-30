import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountOutstandingHeader extends StatelessWidget {
  final formData;

  AccountOutstandingHeader({
    @required this.formData,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(top: 13.0),
                child: Text(
                  'ACCOUNT:',
                  textAlign: TextAlign.center,
                ),
              ),
              formData['accountList'] == ''
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
                          'ALL ACCOUNT',
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
                          itemCount: formData['accountList'].length,
                          shrinkWrap: true,
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
                                  formData['accountList'][index]['name']
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
                  13.0,
                  0.0,
                ),
                child: Text(
                  'BRANCH:',
                  textAlign: TextAlign.center,
                ),
              ),
              formData['branchList'] == ''
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
                          'BRANCH',
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
                          itemCount: formData['branchList'].length,
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
                                  formData['branchList'][index]['name']
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
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
