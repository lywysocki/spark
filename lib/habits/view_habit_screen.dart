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
import 'package:spark/friends/friendship_controller.dart';
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
        actions: [
          TextButton(
            child: Text(!editMode ? 'Edit' : 'Cancel'),
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
                    initialCategory: widget.habit.category,
                    initialStart: widget.habit.startDate,
                    initialEnd: widget.habit.endDate,
                    initialFrequency: widget.habit.frequency,
                    initialReminders: const [], // TODO: habit reminders
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
    final friendController = context.watch<FriendshipController>();

    final habitController = context.watch<HabitController>();
    TextStyle textStyle = Theme.of(context).textTheme.titleSmall!;

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
                    habit.frequency.contains('not')
                        ? 'Frequency:\n  ${habit.frequency}'
                        : 'Frequency:\n  Repeats ${habit.frequency}',
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      CommonDuration(
                        headerText: 'Started',
                        onTap: () {},
                        date: habit.startDate,
                      ),
                      if (habit.endDate != null)
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 15.0, left: 20, right: 20),
                          child: Text('-'),
                        ),
                      if (habit.endDate != null)
                        CommonDuration(
                          headerText: 'Ends',
                          onTap: () {},
                          date: habit.endDate,
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
                    //TODO: habit reminders
                    child: Text(''),
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
              height: 5,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: CommonCardTile(
                category: 'white',
                title: ExpansionTile(
                  childrenPadding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  shape: null,
                  tilePadding: EdgeInsets.zero,
                  title: const Text('Share Habit with Friends'),
                  children: [
                    for (final friend in friendController.allFriends)
                      Column(
                        children: [
                          const Divider(),
                          InkWell(
                            onTap: () async {
                              SnackBar content = SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text(
                                  'Habit shared with ${friend.username}',
                                ),
                              );
                              try {
                                habitController.createSharedHabit(
                                  habit: habit,
                                  friendUserId: friend.userId,
                                );
                              } catch (e) {
                                content = SnackBar(
                                  duration: const Duration(seconds: 3),
                                  content: Text(
                                    e.toString(),
                                  ),
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                content,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  friend.username,
                                ),
                                const Icon(Icons.send_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: () {
                habitController.deleteHabit(habit.habitId);
                Navigator.pop(context);
              },
              child: const Text('Delete habit'),
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
