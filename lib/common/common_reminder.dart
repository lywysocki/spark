import 'package:flutter/material.dart';
import 'package:spark/common/common_textfield.dart';

class CommonReminder extends StatelessWidget {
  const CommonReminder({
    super.key,
    required this.onLongPress,
    required this.onPress,
    required this.child,
  });

  final VoidCallback? onLongPress;
  final VoidCallback? onPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: 90,
      height: 33,
      child: Stack(
        children: [
          const CommonTextfield(
            isTapped: true,
          ),
          TextButton(
            onPressed: onPress,
            onLongPress: onLongPress,
            child: Center(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
