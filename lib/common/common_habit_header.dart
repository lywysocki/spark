import 'package:flutter/material.dart';

class CommonHabitHeader extends StatelessWidget {
  const CommonHabitHeader({
    super.key,
    required this.text,
    this.topPadding,
    this.bottomPadding,
  });

  final String text;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: topPadding ?? 20, bottom: bottomPadding ?? 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
