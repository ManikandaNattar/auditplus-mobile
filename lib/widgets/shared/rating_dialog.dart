import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showRatingDialog({
  BuildContext context,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    builder: (_) {
      return RatingScreen();
    },
  );
}

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  List<Widget> array = [];

  List<Widget> _starWidget() {
    var filled = Colors.yellow;
    var empty = Colors.grey;
    for (var i = 1; i <= 5; i++) {
      array.add(
        IconButton(
          icon: Icon(
            Icons.star,
            size: 35.0,
          ),
          color: (_rating < i ? empty : filled),
          onPressed: () {
            setState(() {
              array.clear();
              _rating = i;
            });
          },
        ),
      );
    }
    return array;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rating Auditplus?',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'If you enjoy using Auditplus, please take a moment to rate it. Thanks for your support!',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: _starWidget(),
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  _rating == 1
                      ? 'Hated it'
                      : _rating == 2
                          ? 'Disliked it'
                          : _rating == 3
                              ? 'It' 's OK'
                              : _rating == 4
                                  ? 'Liked it'
                                  : _rating == 5
                                      ? 'Loved it'
                                      : '',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'SUBMIT',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
