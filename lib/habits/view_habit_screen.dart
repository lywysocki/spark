import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/common/habit_form.dart';

class ViewHabitScreen extends StatefulWidget {
  const ViewHabitScreen({super.key, required this.habit});

  // TODO: change to habitId
  final String habit;

  @override
  State<ViewHabitScreen> createState() => _ViewHabitScreenState();
}

class _ViewHabitScreenState extends State<ViewHabitScreen> {
  bool editMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text(!editMode ? 'Edit' : 'Done'),
            onPressed: () {
              editMode = !editMode;
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: !editMode
                ? _HabitInformation(
                    habit: widget.habit,
                  )

                /// TODO: Replace these initial values with the current habit's real information
                : NewHabitForm(
                    initialTitle: widget.habit,
                    initialNotes: 'Initial notes here',
                    initialCharge: 'negative',
                    initialCategory: 'Education',
                    initialStart: DateTime.now(),
                    initialEnd: DateTime.now(),
                    initialFrequency: 'Daily',
                    initialReminders: const [
                      TimeOfDay(hour: 10, minute: 30),
                      TimeOfDay(hour: 4, minute: 55),
                    ],
                    initialmessage: 'Reminder notez',
                  ),
          ),
        ],
      ),
    );
  }
}

class _HabitInformation extends StatelessWidget {
  const _HabitInformation({required this.habit});

  final String habit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonCardTile(
          title: Text(habit),
          trailingWidget: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('10'),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.flare_outlined),
            ],
          ),
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
        const SizedBox(
          height: 35,
        ),
        const CommonCardTile(
          category: 'None',
          title: Text('Achievements'),
          destination: AchievementsScreen(),
          trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}
