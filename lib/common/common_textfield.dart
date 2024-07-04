import 'package:flutter/material.dart';

class CommonTextfield extends StatefulWidget {
  const CommonTextfield({
    super.key,
    this.hintText = '',
    this.maxLength,
    this.maxLines = 1,
    this.isTapped,
  });

  final String hintText;
  final int? maxLength;
  final int maxLines;
  final bool? isTapped;

  @override
  State<CommonTextfield> createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      showCursor: !(widget.isTapped ?? false),
      mouseCursor:
          !(widget.isTapped ?? false) ? SystemMouseCursors.basic : null,
      controller: controller,
      onChanged: (value) {
        setState(() {});
      },
      //  onTap: widget.onTap,
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
