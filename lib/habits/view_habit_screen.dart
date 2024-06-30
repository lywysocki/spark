import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_tile.dart';

class ViewHabitScreen extends StatelessWidget {
  const ViewHabitScreen({super.key, required this.habit});

  // TODO: change to habitId
  final String habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text('Edit'),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonCardTile(
              title: Text(habit),
              trailingWidget: const Icon(Icons.flare_outlined),
            ),
            const CommonHabitHeader(
              text: 'Duration',
            ),
            CommonDuration(
              headerText: 'Start date',
              onTap: null,
              date: DateTime.now(),
            ),
            const CommonHabitHeader(
              text: 'Frequency',
            ),
            const Text('Daily'),
            const CommonHabitHeader(
              text: 'Reminders',
            ),
            const CommonReminder(
              onLongPress: null,
              onPress: null,
              child: Text('10:30 AM'),
            ),
            const Spacer(),
            const CommonCardTile(
              category: 'None',
              title: Text('Achievements'),
              destination: AchievementsScreen(),
              trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
