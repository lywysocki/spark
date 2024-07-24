import 'package:flutter/material.dart';
import 'package:spark/common/habit_form.dart';

class NewHabitScreen extends StatelessWidget {
  const NewHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'New Habit Form',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const NewHabitForm(
              edit: false,
            ),
          ],
        ),
      ),
    );
  }
}
