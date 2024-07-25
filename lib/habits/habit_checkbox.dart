import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'habit_controller.dart';

class HabitCheckbox extends StatefulWidget {
  const HabitCheckbox({
    super.key,
    required this.habitId,
    required this.userId,
    this.quantity,
    required this.habitTitle,
  });

  final String habitId;
  final String userId;
  final String habitTitle;
  final int? quantity;

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
      setState(() {
        debugPrint(
          '${widget.userId} - Habit: ${widget.habitTitle}: ${widget.habitId}, Checked?: $isChecked',
        );
      });
    });
  }

  Future<void> checkActivities() async {
    isChecked = await _habitController.hasActivityLoggedToday(widget.habitId);
    debugPrint("$isChecked");
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
                  widget.quantity,
                );
                debugPrint("LOG ACTIVITY");
              } else {
                await _habitController.deleteActivity(widget.habitId);
                debugPrint("DELETE ACTIVITY");
              }

              setState(() {});
            },
          );
  }
}
