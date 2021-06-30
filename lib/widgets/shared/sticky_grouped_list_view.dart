import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StickyGroupedListView<T, E> extends StatefulWidget {
  final Key key;
  final List elements;
  final E Function(dynamic element) groupBy;
  final Widget Function(dynamic value) groupHeaderBuilder;
  final Widget Function(BuildContext context, T element) itemBuilder;
  final Widget separator;
  final Color stickyHeaderBackgroundColor;
  final Function onScrollEnd;
  final Map paginationData;

  StickyGroupedListView({
    @required this.elements,
    @required this.groupBy,
    @required this.onScrollEnd,
    @required this.groupHeaderBuilder,
    @required this.itemBuilder,
    this.separator = const SizedBox.shrink(),
    this.stickyHeaderBackgroundColor = const Color(0xffF7F7F7),
    this.key,
    this.paginationData,
  })  : assert(itemBuilder != null),
        assert(groupHeaderBuilder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _StickyGroupedListViewState<T, E>();
}

class _StickyGroupedListViewState<T, E>
    extends State<StickyGroupedListView<T, E>> {
  StreamController<int> _streamController = StreamController<int>();
  ScrollController _scrollController = ScrollController();
  Map<String, GlobalKey> _keys = LinkedHashMap<String, GlobalKey>();
  GlobalKey _groupHeaderKey;
  GlobalKey _key = GlobalKey();
  int _topElementIndex = 0;
  RenderBox _headerBox;
  RenderBox _listBox;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hiddenIndex = widget.elements.length * 2;
    var _isSeparator = (int i) => i.isEven;
    return Stack(
      key: _key,
      alignment: Alignment.topCenter,
      children: <Widget>[
        ListView.builder(
          key: widget.key,
          controller: _scrollController,
          itemCount: widget.paginationData['hasMorePages'] == true
              ? widget.elements.length * 2 + 1
              : widget.elements.length * 2,
          itemBuilder: (context, index) {
            if (index == widget.elements.length * 2) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            int actualIndex = index ~/ 2;
            if (index == hiddenIndex) {
              return Opacity(
                opacity: 0,
                child: _buildHeader(widget.elements[actualIndex]),
              );
            }
            if (_isSeparator(index)) {
              E curr = widget.groupBy(widget.elements[actualIndex]);
              E prev = actualIndex - 1 < 0
                  ? null
                  : widget.groupBy(widget.elements[actualIndex - 1]);
              if (prev != curr) {
                return _buildHeader(widget.elements[actualIndex]);
              }
              return widget.separator;
            }
            return _buildItem(context, actualIndex);
          },
        ),
        StreamBuilder<dynamic>(
          stream: _streamController.stream,
          initialData: _topElementIndex,
          builder: (context, snapshot) => _showFixedGroupHeader(snapshot.data),
        ),
      ],
    );
  }

  Container _buildItem(context, int actualIndex) {
    GlobalKey key = GlobalKey();
    _keys['$actualIndex'] = key;
    return Container(
      padding: EdgeInsets.all(0.0),
      key: key,
      child: widget.itemBuilder(context, widget.elements[actualIndex]),
    );
  }

  _scrollListener() {
    _listBox ??= _key?.currentContext?.findRenderObject();
    double listPos = _listBox?.localToGlobal(Offset.zero)?.dy ?? 0;
    _headerBox ??= _groupHeaderKey?.currentContext?.findRenderObject();
    double headerHeight = _headerBox?.size?.height ?? 0;
    String topItemKey = '0';
    for (var entry in _keys.entries) {
      var key = entry.value;
      if (_isListItemRendered(key)) {
        RenderBox itemBox = key.currentContext.findRenderObject();
        double y = itemBox.localToGlobal(Offset(0, -listPos - headerHeight)).dy;
        if (y <= headerHeight) {
          topItemKey = entry.key;
        }
      }
    }
    var index = math.max(int.parse(topItemKey), 0);
    if (index != _topElementIndex) {
      E curr = widget.groupBy(widget.elements[index]);
      E prev = widget.groupBy(widget.elements[_topElementIndex]);
      if (prev != curr) {
        _topElementIndex = index;
        _streamController.add(_topElementIndex);
      }
    }
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onScrollEnd();
    }
  }

  Widget _showFixedGroupHeader(int topElementIndex) {
    _groupHeaderKey = GlobalKey();
    if (widget.elements.length > 0) {
      return Container(
        padding: EdgeInsets.all(0.0),
        key: _groupHeaderKey,
        color: widget.stickyHeaderBackgroundColor,
        width: MediaQuery.of(context).size.width,
        child: _buildHeader(widget.elements[topElementIndex]),
      );
    }
    return Container(
      height: 0.0,
    );
  }

  bool _isListItemRendered(GlobalKey<State<StatefulWidget>> key) {
    return key.currentContext != null &&
        key.currentContext.findRenderObject() != null;
  }

  Widget _buildHeader(dynamic element) {
    return widget.groupHeaderBuilder(widget.groupBy(element));
  }
}
