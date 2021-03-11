import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'show_data_empty_image.dart';

class GeneralListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final List list;
  final String routeName;
  final bool hasMorePages;
  final bool isLoading;
  final Function onScrollEnd;
  GeneralListView({
    @required this.list,
    @required this.routeName,
    @required this.hasMorePages,
    @required this.isLoading,
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

  @override
  Widget build(BuildContext context) {
    addScrollListener();
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : list.isEmpty
            ? Center(
                child: ShowDataEmptyImage(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: hasMorePages == true ? list.length + 1 : list.length,
                itemBuilder: (_, index) {
                  if (index == list.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(
                          horizontal: 0,
                          vertical: -4,
                        ),
                        title: Text(
                          list[index]['title'],
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        subtitle: Visibility(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              list[index]['subtitle'],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          visible:
                              list[index]['subtitle'].toString().isNotEmpty,
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                          routeName,
                          arguments: {
                            'id': list[index]['id'],
                            'displayName': list[index]['displayName'],
                          },
                        ),
                      ),
                      Divider(
                        thickness: 0.75,
                      ),
                    ],
                  );
                },
              );
  }
}
