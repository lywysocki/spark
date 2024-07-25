import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark/common/common_empty_list.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/view_habit_screen.dart';
import 'package:spark/habits/habit_controller.dart';
import 'package:spark/user/user_controller.dart';

import 'habits/habit_checkbox.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final userController = context.watch<UserController>();
    final habitController = context.watch<HabitController>();

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
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: theme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  userController.currentUserId != null
                      ? 'Hello, ${userController.currentUser!.fName}!'
                      : 'Hello',
                  style: theme.titleMedium,
                ),
                Text(
                  'Here is your daily summary...',
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
          habitController.todaysHabits.isEmpty
              ? const EmptyListWidget(
                  text:
                      'Nothing to complete today...\nPress the plus button on the bottom right of the screen to create a new habit!',
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: habitController.todaysHabits
                      .map(
                        (habit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CommonCardTile(
                            category: habit.category,
                            title: Text(habit.title),
                            destination: ViewHabitScreen(
                              habit: habit,
                            ),
                            leadingWidget: HabitCheckbox(
                              habitId: habit.habitId,
                              userId: userController.currentUser!.userId,
                            ),
                            trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${habit.streak}'),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.flare_outlined),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
          const SizedBox(
            height: 14,
          ),
          Text(
            'Upcoming Habits',
            style: theme.titleMedium,
          ),
          habitController.tomorrowsHabits.isEmpty
              ? const EmptyListWidget(text: 'Nothing to complete tomorrow...')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: habitController.tomorrowsHabits
                      .map(
                        (habit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CommonCardTile(
                            category: habit.category,
                            title: Text(habit.title),
                            destination: ViewHabitScreen(
                              habit: habit,
                            ),
                            trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${habit.streak}'),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.flare_outlined),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
          const SizedBox(
            height: 75,
          ),
        ],
      ),
    );
  }
}
