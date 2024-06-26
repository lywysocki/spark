import 'package:flutter/material.dart';

class CommonDropdown extends StatelessWidget {
  const CommonDropdown({
    super.key,
    required this.dropdownItems,
    required this.hintText,
    this.hasInitialValue = false,
  });

  final List<DropdownMenuItem<String>> dropdownItems;
  final String hintText;
  final bool hasInitialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: hasInitialValue ? dropdownItems.first.value : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      borderRadius: BorderRadius.circular(20),
      focusColor: Colors.transparent,
      hint: Text(hintText),
      items: dropdownItems,
      onChanged: (value) {},
    );
  }
}
