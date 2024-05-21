import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/habits/new_habit_screen.dart';
import 'package:spark/habits/view_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: const Column(
        children: [
          Text('Home'),
          CommonCardTile(
            title: 'Habit',
            destination: ViewHabitScreen(),
            trailingIcon: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}
