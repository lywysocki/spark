import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/new_habit_screen.dart';
import 'package:spark/habits/view_habit_screen.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const NewHabitScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Habits',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CommonCardTile(
                  category: 'None',
                  title: Text('Habit $index'),
                  destination: const ViewHabitScreen(),
                  trailingWidget: const Icon(Icons.star),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
