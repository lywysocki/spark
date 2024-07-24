import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/common/habit_form.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:spark/habits/habit_controller.dart';

import 'habit.dart';

class ViewHabitScreen extends StatefulWidget {
  const ViewHabitScreen({
    super.key,
    required this.habit,
  });

  final Habit habit;

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
        centerTitle: true,
        title: Text(
          widget.habit.title,
        ),
        leadingWidth: 68,
        leading: editMode
            ? TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  editMode = !editMode;
                  setState(() {});
                },
              )
            : null,
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
          if (!editMode)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.habit.streak}'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.flare_outlined),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: !editMode
                ? HabitInformation(
                    habit: widget.habit,
                  )
                : NewHabitForm(
                    initialTitle: widget.habit.title,
                    initialNotes: widget.habit.note,
                    initialCharge: 'negative',
                    initialCategory: widget.habit.category,
                    initialStart: widget.habit.startDate,
                    initialEnd: widget.habit.endDate ?? DateTime.now(),
                    initialFrequency: widget.habit.frequency,
                    initialReminders: const [
                      TimeOfDay(hour: 10, minute: 30),
                      TimeOfDay(hour: 4, minute: 55),
                    ], // TODO: habit reminders are currently just a bool
                    initialMessage: widget.habit.reminderMessage,
                    edit: true,
                    habit: widget.habit,
                  ),
          ),
        ],
      ),
    );
  }
}

class HabitInformation extends StatelessWidget {
  const HabitInformation({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final _habitController = context.watch<HabitController>();
    TextStyle textStyle = Theme.of(context).textTheme.titleSmall!;
    const fakeHasEndDate = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            CommonCardTile(
              category: 'white',
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ' Repeats Daily',
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      CommonDuration(
                        headerText: 'Started',
                        onTap: null,
                        date: DateTime.now(),
                      ),
                      if (fakeHasEndDate)
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 15.0, left: 20, right: 20),
                          child: Text('-'),
                        ),
                      if (fakeHasEndDate)
                        CommonDuration(
                          headerText: 'Ends',
                          onTap: null,
                          date: DateTime.now(),
                        ),
                    ],
                  ),
                  Text(
                    ' Reminders',
                    style: textStyle,
                  ),
                  const CommonReminder(
                    onLongPress: null,
                    onPress: null,
                    child: Text('10:30 AM'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _CalendarView(
              habit: habit,
            ),
            const SizedBox(
              height: 20,
            ),
            const CommonCardTile(
              category: 'white',
              title: Text('View Habit Achievements'),
              destination: AchievementsScreen(),
              trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const SizedBox(
              height: 25,
            ),
            FilledButton(
              onPressed: () {
                _habitController.deleteHabit(habit.habitId);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView({required this.habit});

  final Habit habit;

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  /// TODO: replace with habit activity for this habit
  Map<DateTime, List<Event>> habitCompletions = {};

  void updateHabitCompletions() {
    habitCompletions.clear();

    int streak = widget.habit.streak ?? 0;

    for (int i = 0; i < streak; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      habitCompletions[date] = [
        Event(
          date: date,
          title: "Completed",
          description: "Habit completed on $date",
          icon: null,
          dot: null,
          id: i,
        ),
      ];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: colorScheme.outline,
          ),
        ),
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
            if (day == widget.habit.startDate) {
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
          markedDateWidget: Center(
            child: Icon(
              Icons.check,
              color: colorScheme.tertiaryContainer,
            ),
          ),
          weekFormat: false,
          height: 320.0,
          daysHaveCircularBorder: null,
        ),
      ),
    );
  }
}
