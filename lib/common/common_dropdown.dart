import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CommonDropdown extends StatelessWidget {
  const CommonDropdown({
    super.key,
    required this.dropdownItems,
    required this.hintText,
    this.initialValue,
  });

  final List<DropdownMenuItem<String>> dropdownItems;
  final String hintText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownItems
          .firstWhereOrNull((element) => element.value == initialValue)
          ?.value,
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
