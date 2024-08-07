import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/common/common_empty_list.dart';
import 'package:spark/common/common_loading.dart';
import 'package:spark/common/common_search_bar.dart';
import 'package:spark/common/common_streak_widget.dart';
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
  late UserController _userController;
  final List<Habit> allHabits = [];
  late String userId;
  String currentSearch = '';
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loading = true;
    setState(() {});

    final habitController = context.watch<HabitController>();
    allHabits.clear();
    allHabits.addAll(habitController.allHabits);
    _userController = context.read<UserController>();
    userId = _userController.currentUserId!;

    loading = false;
    setState(() {});
  }

  Future<void> initialize() async {
    loading = true;
    setState(() {});

    final controller = context.read<HabitController>();
    await controller.load();

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Habits',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.replay_rounded),
                onPressed: () async {
                  await initialize();
                },
              ),
            ],
          ),
          CommonSearchBar(
            hintText: 'Search habits',
            currentSearch: (e) {
              setState(() {
                currentSearch = e;
              });
            },
          ),
          loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: CommonLoadingWidget(),
                )
              : allHabits.isEmpty
                  ? const EmptyListWidget(
                      text:
                          'You don\'t have any habits yet...\nPress the plus button on the bottom right of the screen to create a new habit!',
                    )
                  : _HabitTiles(
                      currentSearch: currentSearch,
                      habits: allHabits,
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
              category: habit.category,
              title: Text(habit.title),
              destination: ViewHabitScreen(
                habit: habit,
              ),
              trailingWidget: HabitStreakWidget(
                habit: habit,
              ),
            ),
          ),
      ],
    );
  }
}
