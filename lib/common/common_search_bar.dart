import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  const CommonSearchBar({
    super.key,
    required this.hintText,
    required this.currentSearch,
  });

  final String hintText;
  final Function(String) currentSearch;
  @override
  State createState() => _CommonSearchbarState();
}

class _CommonSearchbarState extends State<CommonSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        onChanged: widget.currentSearch,
        hintText: widget.hintText,
        leading: const Icon(Icons.search),
        trailing: const [],
      ),
    );
  }
}
