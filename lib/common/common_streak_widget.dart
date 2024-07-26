import 'package:flutter/material.dart';
import 'package:spark/habits/habit.dart';

class HabitStreakWidget extends StatelessWidget {
  const HabitStreakWidget({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return habit.frequency != 'Does not repeat'
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${habit.streak}'),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.flare_outlined),
            ],
          )
        : const SizedBox();
  }
}
