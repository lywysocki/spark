import 'package:flutter/material.dart';

class CommonTextfield extends StatefulWidget {
  const CommonTextfield({
    super.key,
    this.hintText = '',
    this.maxLength,
    this.maxLines = 1,
    this.isTapped,
    this.initialValue,
  });

  final String hintText;
  final int? maxLength;
  final int maxLines;
  final bool? isTapped;
  final String? initialValue;

  @override
  State<CommonTextfield> createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      showCursor: !(widget.isTapped ?? false),
      mouseCursor:
          !(widget.isTapped ?? false) ? SystemMouseCursors.basic : null,
      onChanged: (value) {
        setState(() {});
      },
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceDim,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hintText,
      ),
    );
  }
}
