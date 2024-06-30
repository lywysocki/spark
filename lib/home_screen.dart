import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/view_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CommonCardTile(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today_rounded),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Tuesday, May 21st',
                      style: theme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Hello, {User}!',
                  style: theme.titleMedium,
                ),
                Text(
                  'Here is your daily summary!',
                  style: theme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            'Today\'s Habits',
            style: theme.titleMedium,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              2,
              (int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CommonCardTile(
                  category: 'education',
                  title: Text('Habit $index'),
                  destination: ViewHabitScreen(
                    habit: 'Habit $index',
                  ),
                  trailingWidget: const Icon(Icons.flare_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            'Upcoming Habits',
            style: theme.titleMedium,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              2,
              (int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CommonCardTile(
                  category: 'mental health',
                  title: Text('Habit $index'),
                  destination: ViewHabitScreen(
                    habit: 'Habit $index',
                  ),
                  trailingWidget: const Icon(Icons.flare_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 75,
          ),
        ],
      ),
    );
  }
}
