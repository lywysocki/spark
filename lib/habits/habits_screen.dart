import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/common/common_search_bar.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/habit.dart';
import 'package:spark/habits/view_habit_screen.dart';
import 'package:spark/habits/habit_controller.dart';
import 'package:spark/user/user_controller.dart';

final placeholderHabits = List.generate(10, (int index) => 'Habit $index');

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({
    super.key,
  });
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late HabitController _habitController;
  late UserController _userController;
  late String userId;
  String currentSearch = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userController = context.watch<UserController>();
    userId = _userController.currentUserId!;

    _habitController = context.watch<HabitController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Habits',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CommonSearchBar(
            hintText: 'Search habits',
            currentSearch: (e) {
              setState(() {
                currentSearch = e;
              });
            },
          ),
          _HabitTiles(
            currentSearch: currentSearch,
            habits: _habitController.allHabits,
            userID: userId,
          ),
          const SizedBox(
            height: 75,
          ),
        ],
      ),
    );
  }
}

class _HabitTiles extends StatefulWidget {
  const _HabitTiles({
    required this.currentSearch,
    required this.habits,
    required this.userID,
  });

  final String currentSearch;
  final List<Habit> habits;
  final String userID;

  @override
  State<_HabitTiles> createState() => _HabitTilesState();
}

class _HabitTilesState extends State<_HabitTiles> {
  @override
  Widget build(BuildContext context) {
    final displayHabits = widget.habits.where(
      (element) => element
          .getTitle()
          .toLowerCase()
          .contains(widget.currentSearch.toLowerCase()),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final habit in displayHabits)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: CommonCardTile(
              category: 'None',
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
      ],
    );
  }
}
