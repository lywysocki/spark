import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'habit_controller.dart';

class HabitCheckbox extends StatefulWidget {
  const HabitCheckbox({
    super.key,
    required this.habitId,
    required this.userId,
    required this.onChanged,
  });

  final String habitId;
  final String userId;
  final VoidCallback onChanged;

  @override
  State<HabitCheckbox> createState() => _HabitCheckboxState();
}

class _HabitCheckboxState extends State<HabitCheckbox> {
  bool loading = false;
  late HabitController _habitController;
  bool isChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loading = true;
    _habitController = context.watch<HabitController>();
    checkActivities().then((value) {
      loading = false;
      setState(() {});
    });
  }

  Future<void> checkActivities() async {
    isChecked = await _habitController.hasActivityLoggedToday(widget.habitId);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          )
        : Checkbox(
            value: isChecked,
            onChanged: (newValue) async {
              isChecked = newValue!;

              if (isChecked) {
                await _habitController.logActivity(
                  widget.habitId,
                );
              } else {
                await _habitController.deleteActivity(widget.habitId);
              }

              widget.onChanged();

              setState(() {});
            },
          );
  }
}
