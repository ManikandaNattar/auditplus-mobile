import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteFormField extends StatefulWidget {
  final Function suggestionFormatter;
  final Function textFormatter;
  final Function autocompleteCallback;
  final Function onSaved;
  final Function validator;
  final String labelText;
  final Map<String, dynamic> initialValue;
  final TextEditingController controller;
  final Function onSelected;
  final FocusNode focusNode;
  final Widget suffixIconWidget;
  final bool autoFocus;
  final TextStyle labelStyle;
  final bool outlineInputBorder;
  final bool floatingLabelBehaviour;

  AutocompleteFormField({
    @required this.labelText,
    @required this.suggestionFormatter,
    @required this.textFormatter,
    @required this.autocompleteCallback,
    @required this.onSaved,
    @required this.validator,
    @required this.controller,
    this.initialValue,
    this.onSelected,
    this.focusNode,
    this.suffixIconWidget,
    this.autoFocus,
    this.labelStyle,
    this.outlineInputBorder,
    this.floatingLabelBehaviour,
  });

  @override
  _AutocompleteFormFieldState createState() => _AutocompleteFormFieldState();
}

class _AutocompleteFormFieldState extends State<AutocompleteFormField> {
  Map<String, dynamic> _selection;

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      _selection = widget.initialValue;
    }

    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus == null ? true : false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle == null ? null : widget.labelStyle,
          border:
              widget.outlineInputBorder == null ? OutlineInputBorder() : null,
          suffixIcon: widget.suffixIconWidget,
          floatingLabelBehavior: widget.floatingLabelBehaviour == null
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.always,
        ),
        controller: widget.controller,
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        shadowColor: Colors.blue,
      ),
      itemBuilder: (_, suggestion) {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.suggestionFormatter(suggestion),
                ),
              ),
            ),
          ],
        );
      },
      autoFlipDirection: true,
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No items found',
          style: TextStyle(
            color: Theme.of(context).errorColor,
            fontSize: 12.0,
          ),
        ),
      ),
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        _selection = suggestion;
        widget.controller.text = widget.textFormatter(_selection);
        if (widget.onSelected != null) {
          widget.onSelected(suggestion);
        }
      },
      suggestionsCallback: (pattern) async {
        return widget.autocompleteCallback(
            pattern.replaceAll(RegExp('[^a-zA-Z0-9\\\\s+]'), ''));
      },
      validator: (_) {
        if (widget.validator != null) {
          return widget.validator(_selection);
        } else {
          return null;
        }
      },
      onSaved: (_) {
        widget.onSaved(_selection);
      },
    );
  }
}
