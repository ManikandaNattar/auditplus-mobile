import 'package:flutter/material.dart';

import './../../constants.dart' as constants;

class DatePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final Function onSaved;

  DatePickerFormField({
    @required this.title,
    @required this.controller,
    @required this.onSaved,
  });

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime _initialDate;
  bool get hasValue {
    return (widget.controller != null && widget.controller.text != '');
  }

  @override
  void initState() {
    _initialDate = widget.controller.text.isEmpty
        ? DateTime.now()
        : constants.defaultDate.parse(widget.controller.text);
    super.initState();
  }

  void _showDatePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: constants.firstDate,
      lastDate: constants.lastDate,
    ).then((result) {
      if (result == null) {
        return;
      }
      setState(() {
        _initialDate = result;
      });
      controller.text = constants.defaultDate.format(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          readOnly: true,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.title,
            border: OutlineInputBorder(),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _showDatePicker(widget.controller);
          },
          onSaved: widget.onSaved,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                icon: Icon(
                  (hasValue) ? Icons.clear : Icons.date_range_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    if (hasValue) {
                      widget.controller.text = '';
                      _initialDate = DateTime.now();
                    } else {
                      _showDatePicker(widget.controller);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
