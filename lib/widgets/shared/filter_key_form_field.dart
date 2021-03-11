import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterKeyFormField extends StatefulWidget {
  final String labelName;
  final String filterKey;
  final Function onChanged;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function buttonOnPressed;
  final TextInputAction textInputAction;
  final String filterType;
  final bool autoFocus;

  FilterKeyFormField({
    @required this.labelName,
    @required this.filterKey,
    @required this.onChanged,
    @required this.textEditingController,
    @required this.focusNode,
    @required this.nextFocusNode,
    @required this.buttonOnPressed,
    @required this.textInputAction,
    @required this.filterType,
    @required this.autoFocus,
  });

  @override
  _FilterKeyFormFieldState createState() => _FilterKeyFormFieldState();
}

class _FilterKeyFormFieldState extends State<FilterKeyFormField> {
  String filterKeyType;
  List _textFilterKeyList = [
    'a..',
    '.a.',
    '..a',
  ];
  List _numberFilterKeyList = [
    '=',
    '>',
    '<',
    '≥',
    '≤',
    '≠',
  ];
  @override
  void initState() {
    filterKeyType = widget.filterKey;
    super.initState();
  }

  void setFilterKey() {
    if (widget.filterType == 'text') {
      for (int i = 0; i <= _textFilterKeyList.length - 1; i++) {
        if (_textFilterKeyList[i] == filterKeyType) {
          int keyIndex = i + 1;
          setState(() {
            filterKeyType = keyIndex == _textFilterKeyList.length
                ? _textFilterKeyList[0]
                : _textFilterKeyList[keyIndex];
          });
          break;
        }
      }
    } else if (widget.filterType == 'number') {
      for (int i = 0; i <= _numberFilterKeyList.length - 1; i++) {
        if (_numberFilterKeyList[i] == filterKeyType) {
          int keyIndex = i + 1;
          setState(() {
            filterKeyType = keyIndex == _numberFilterKeyList.length
                ? _numberFilterKeyList[0]
                : _numberFilterKeyList[keyIndex];
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.textEditingController.text,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: widget.labelName,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          padding: EdgeInsets.only(right: 8.0),
          iconSize: 50,
          icon: OutlinedButton(
            child: Text(
              filterKeyType,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              setFilterKey();
              widget.buttonOnPressed(filterKeyType);
            },
          ),
          onPressed: null,
        ),
      ),
      style: Theme.of(context).textTheme.subtitle1,
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.text,
      onEditingComplete: () {
        widget.focusNode.unfocus();
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
      onChanged: widget.onChanged,
    );
  }
}
