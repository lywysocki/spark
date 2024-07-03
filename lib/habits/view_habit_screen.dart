import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/common/habit_form.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class ViewHabitScreen extends StatefulWidget {
  const ViewHabitScreen({super.key, required this.habit});

  // TODO: change to habitId
  final String habit;

  @override
  State<ViewHabitScreen> createState() => _ViewHabitScreenState();
}

class _ViewHabitScreenState extends State<ViewHabitScreen> {
  bool editMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
        Row(
          children: [
            CommonDuration(
              headerText: 'Start date',
              onTap: null,
              date: DateTime.now(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
              child: Text('to'),
            ),
            CommonDuration(
              headerText: 'End date',
              onTap: null,
              date: DateTime.now(),
            ),
          ],
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
        const CommonHabitHeader(
          text: 'Activity Calendar',
        ),
        const _CalendarView(),
        const SizedBox(
          height: 20,
        ),
        const CommonCardTile(
          category: 'common',
          title: Text('Achievements'),
          destination: AchievementsScreen(),
          trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView();

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  /// TODO: replace with real habit start date
  final DateTime _fakeStartDate = DateTime(2024, 6, 20);

  /// TODO: replace with habit activity for this habit
  Map<DateTime, List<Event>> habitCompletions = {
    DateTime(2024, 7, 1): [
      Event(
        date: DateTime(2024, 7, 1),
        title: "Event 1",
        description: "Description for Event 1",
        location: "Location 1",
        icon: null,
        dot: null,
        id: 1,
      ),
    ],
    DateTime(2024, 7, 2): [
      Event(
        date: DateTime(2024, 7, 1),
        title: "Event 2",
        description: "Description for Event 1",
        location: "Location 1",
        icon: null,
        dot: null,
        id: 2,
      ),
    ],
  };
  List<DateTime> fakeCompletions = [
    DateTime(2024, 7, 1),
    DateTime(2024, 6, 30),
  ];
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: CalendarCarousel<Event>(
        headerMargin: const EdgeInsets.all(0),
        todayButtonColor: colorScheme.primary,
        todayBorderColor: colorScheme.primary,
        disableDayPressed: true,
        headerTextStyle:
            textTheme.titleMedium!.copyWith(color: colorScheme.primary),
        iconColor: colorScheme.primary,
        weekendTextStyle: const TextStyle(
          color: Colors.black,
        ),
        thisMonthDayBorderColor: Colors.grey,
        customDayBuilder: (
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          isSelectable = false;
          if (day == _fakeStartDate) {
            return Center(
              child: Icon(
                Icons.golf_course_rounded,
                color: colorScheme.primary,
              ),
            );
          }
          return null;
        },
        markedDatesMap: EventList(events: habitCompletions),
        markedDateWidget: const Center(
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
        weekFormat: false,
        height: 320.0,
        daysHaveCircularBorder: null,
      ),
    );
  }
}
