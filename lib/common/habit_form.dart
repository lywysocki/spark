import 'package:flutter/material.dart';
import 'package:spark/common/common_dropdown.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_textfield.dart';

class NewHabitForm extends StatefulWidget {
  const NewHabitForm({
    super.key,
    this.initialTitle,
    this.initialNotes,
    this.initialCharge,
    this.initialCategory,
    this.initialStart,
    this.initialEnd,
    this.initialFrequency,
    this.initialReminders,
    this.initialmessage,
  });

  final String? initialTitle;
  final String? initialNotes;
  final String? initialCharge;
  final String? initialCategory;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final String? initialFrequency;
  final List<TimeOfDay>? initialReminders;
  final String? initialmessage;

  @override
  State<NewHabitForm> createState() => _NewHabitFormState();
}

class _NewHabitFormState extends State<NewHabitForm> {
  final _formKey = GlobalKey<FormState>();
  String habitRadio = 'positive';
  final List<TimeOfDay> reminders = [];

  final categoryDropdownItems = [
    const DropdownMenuItem<String>(
      value: 'Education',
      child: Text('Education'),
    ),
    const DropdownMenuItem<String>(
      value: 'Exercise',
      child: Text('Exercise'),
    ),
    const DropdownMenuItem<String>(
      value: 'Health',
      child: Text('Health'),
    ),
    const DropdownMenuItem<String>(
      value: 'Lifestyle',
      child: Text('Lifestyle'),
    ),
    const DropdownMenuItem<String>(
      value: 'Mental Health',
      child: Text('Mental Health'),
    ),
    const DropdownMenuItem<String>(
      value: 'Work',
      child: Text('Work'),
    ),
    const DropdownMenuItem<String>(
      value: 'Other',
      child: Text('Other'),
    ),
  ];

  final frequencyDropdownItems = [
    const DropdownMenuItem<String>(
      value: 'Does not repeat',
      child: Text(
        'Does not repeat',
      ),
    ),
    const DropdownMenuItem<String>(
      value: '3x daily',
      child: Text(
        '3x daily',
      ),
    ),
    const DropdownMenuItem<String>(
      value: '2x daily',
      child: Text('2x daily'),
    ),
    const DropdownMenuItem<String>(
      value: 'Daily',
      child: Text('Daily'),
    ),
    const DropdownMenuItem<String>(
      value: 'Every other day',
      child: Text('Every other day'),
    ),
    const DropdownMenuItem<String>(
      value: 'Once a week',
      child: Text('Once a week'),
    ),
    const DropdownMenuItem<String>(
      value: 'Once a month',
      child: Text('Once a month'),
    ),
    const DropdownMenuItem<String>(
      value: 'Annually',
      child: Text('Annually'),
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reminders.addAll(widget.initialReminders ?? []);
    if (widget.initialCharge != null) {
      habitRadio = widget.initialCharge!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CommonHabitHeader(
            text: 'Title*',
            bottomPadding: 0,
            topPadding: 0,
          ),
          CommonTextfield(
            hintText: 'Enter a title',
            maxLength: 20,
            initialValue: widget.initialTitle,
          ),
          const CommonHabitHeader(
            text: 'Notes',
            topPadding: 0,
            bottomPadding: 0,
          ),
          CommonTextfield(
            hintText: 'Enter optional notes',
            maxLength: 100,
            maxLines: 3,
            initialValue: widget.initialNotes,
          ),
          const CommonHabitHeader(
            text: 'Category*',
            topPadding: 0,
          ),
          Row(
            children: [
              Radio(
                value: 'positive',
                groupValue: habitRadio,
                onChanged: (value) {
                  habitRadio = value ?? 'positive';
                  setState(() {});
                },
              ),
              const Text('Positive habit'),
              const SizedBox(
                width: 10,
              ),
              Radio(
                value: 'negative',
                groupValue: habitRadio,
                onChanged: (value) {
                  habitRadio = value ?? 'negative';
                  setState(() {});
                },
              ),
              const Text('negative'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          CommonDropdown(
            hintText: 'Select a category',
            dropdownItems: categoryDropdownItems,
            initialValue: widget.initialCategory,
          ),
          const CommonHabitHeader(
            text: 'Duration*',
          ),
          _SetDurationWidgets(
            initialStart: widget.initialStart,
            initialEnd: widget.initialEnd,
          ),
          const CommonHabitHeader(
            text: 'Frequency*',
          ),
          CommonDropdown(
            hintText: 'Select a frequency',
            dropdownItems: frequencyDropdownItems,
            initialValue:
                widget.initialFrequency ?? frequencyDropdownItems.first.value,
          ),
          const CommonHabitHeader(
            text: 'Reminders',
          ),
          _SetRemindersWidgets(
            reminders: reminders,
            initialReminderMessage: widget.initialmessage,
          ),
        ],
      ),
    );
  }
}

class _SetRemindersWidgets extends StatefulWidget {
  const _SetRemindersWidgets({
    required this.reminders,
    this.initialReminderMessage,
  });

  final List<TimeOfDay> reminders;
  final String? initialReminderMessage;

  @override
  State<_SetRemindersWidgets> createState() => __SetRemindersWidgetsState();
}

class __SetRemindersWidgetsState extends State<_SetRemindersWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            for (final time in widget.reminders)
              CommonReminder(
                child: Text(
                  time.format(context),
                ),
                onPress: () async {
                  final editTime = (await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ));
                  if (editTime != null) {
                    final index = widget.reminders.indexWhere(
                      (element) => element == time,
                    );
                    widget.reminders[index] = editTime;
                  }
                  setState(() {});
                },
                onLongPress: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return _DeleteReminderDialog(
                        onDelete: () {
                          widget.reminders.removeWhere(
                            (element) => element == time,
                          );
                          setState(() {});
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                  setState(() {});
                },
              ),
            CommonReminder(
              onLongPress: null,
              onPress: () async {
                final time = (await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ));
                if (time != null) widget.reminders.add(time);
                setState(() {});
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        if (widget.reminders.isNotEmpty)
          const CommonHabitHeader(
            text: 'Reminder note',
          ),
        if (widget.reminders.isNotEmpty)
          CommonTextfield(
            hintText: 'Enter optional reminder note',
            maxLength: 100,
            maxLines: 3,
            initialValue: widget.initialReminderMessage,
          ),
      ],
    );
  }
}

class _SetDurationWidgets extends StatefulWidget {
  const _SetDurationWidgets({this.initialStart, this.initialEnd});

  final DateTime? initialStart;
  final DateTime? initialEnd;

  @override
  State<_SetDurationWidgets> createState() => __SetDurationWidgetsState();
}

class __SetDurationWidgetsState extends State<_SetDurationWidgets> {
  DateTime startDate = DateTime.now();
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialStart != null) {
      startDate = widget.initialStart!;
    }
    endDate = widget.initialEnd;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonDuration(
          headerText: 'Start date',
          date: startDate,
          onTap: () async {
            startDate = (await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(DateTime.now().year + 100),
                )) ??
                DateTime.now();
            if (endDate != null) {
              if (startDate.isAfter(endDate!)) {
                endDate = null;
              }
            }
            setState(() {});
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
          child: Text('to'),
        ),
        CommonDuration(
          headerText: 'End date',
          onTap: () async {
            endDate = await showDatePicker(
              context: context,
              initialDate: startDate.isAfter(DateTime.now())
                  ? startDate
                  : DateTime.now(),
              firstDate: startDate,
              lastDate: DateTime(DateTime.now().year + 100),
            );
            setState(() {});
          },
          date: endDate,
        ),
      ],
    );
  }
}

class _DeleteReminderDialog extends StatelessWidget {
  const _DeleteReminderDialog({required this.onDelete});

  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete this reminder?'),
      actions: [
        FilledButton(
          onPressed: onDelete,
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
