import 'package:flutter/material.dart';
import 'package:spark/common/common_search_bar.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/view_habit_screen.dart';

final placeholderHabits = List.generate(10, (int index) => 'Habit $index');

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  String currentSearch = '';

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
          _HabitTiles(currentSearch: currentSearch),
          const SizedBox(
            height: 75,
          ),
        ],
      ),
    );
  }
}

class _HabitTiles extends StatefulWidget {
  const _HabitTiles({required this.currentSearch});

  final String currentSearch;

  @override
  State<_HabitTiles> createState() => _HabitTilesState();
}

class _HabitTilesState extends State<_HabitTiles> {
  @override
  Widget build(BuildContext context) {
    final displayHabits = placeholderHabits.where(
      (element) =>
          element.toLowerCase().contains(widget.currentSearch.toLowerCase()),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final habit in displayHabits)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: CommonCardTile(
              category: 'None',
              title: Text(habit),
              destination: ViewHabitScreen(
                habit: habit,
              ),
              trailingWidget: const Icon(Icons.flare_outlined),
            ),
          ),
      ],
    );
  }
}
