import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/view_habit_screen.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Habits'),
        CommonCardTile(
          title: 'Habit',
          destination: ViewHabitScreen(),
          trailingIcon: Icon(Icons.star),
        ),
      ],
    );
  }
}
