import 'package:auditplusmobile/widgets/shared/menu_item/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils.dart' as utils;

class MenuItemCard extends StatefulWidget {
  final Map<Map<String, dynamic>, List<Map<String, dynamic>>> menuItemList;
  MenuItemCard({@required this.menuItemList});
  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  void initState() {
    _checkFirstMenuExpanded();
    super.initState();
  }

  List _getMenuExpandedList() {
    return widget.menuItemList.keys
        .where((element) => element['isExpanded'] == true)
        .toList();
  }

  void _checkAlreadyExpanded() {
    List data = _getMenuExpandedList();
    for (int i = 0; i <= data.length - 1; i++) {
      setState(() {
        data[i]['isExpanded'] = false;
      });
    }
  }

  void _checkFirstMenuExpanded() {
    List data = _getMenuExpandedList();
    if (data.isEmpty) {
      widget.menuItemList.keys
          .where((element) => element['isExpanded'] == false)
          .toList()
          .first['isExpanded'] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.menuItemList.entries.map(
          (e) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.0),
              child: Card(
                elevation: 0,
                child: ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.all(0.0),
                  expansionCallback: (_, isExpanded) {
                    _checkAlreadyExpanded();
                    setState(() {
                      e.key['isExpanded'] = !isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (_, isExpanded) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(
                            12.0,
                            16.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            e.key['title'],
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        );
                      },
                      body: GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        children: [
                          ...e.value
                              .map(
                                (entry) => MenuItem(
                                  title: entry['title'],
                                  icon: entry['icon'],
                                  privileges: entry['privileges'],
                                  features: entry['features'],
                                  onTap: () => entry['checkBranch'] == true
                                      ? utils.checkBranchSelected(
                                          context,
                                          entry['clickedMenu'],
                                        )
                                      : Navigator.of(context).pushNamed(
                                          entry['clickedMenu'],
                                        ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                      isExpanded: e.key['isExpanded'],
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}
