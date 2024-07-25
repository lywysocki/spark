import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/common/common_dropdown.dart';
import 'package:spark/common/common_duration.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_reminder.dart';
import 'package:spark/common/common_textfield.dart';
import 'package:spark/habits/habit_controller.dart';
import 'package:spark/habits/habit.dart';

class NewHabitForm extends StatefulWidget {
  const NewHabitForm({
    super.key,
    this.initialTitle,
    this.initialNotes,
    this.initialCategory,
    this.initialStart,
    this.initialEnd,
    this.initialFrequency,
    this.initialReminders,
    this.initialMessage,
    required this.edit,
    this.habit,
  });

  final String? initialTitle;
  final String? initialNotes;
  final String? initialCategory;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final String? initialFrequency;
  final List<TimeOfDay>? initialReminders;
  final String? initialMessage;
  final bool edit;
  final Habit? habit;

  @override
  State<NewHabitForm> createState() => _NewHabitFormState();
}

class _NewHabitFormState extends State<NewHabitForm> {
  final _formKey = GlobalKey<FormState>();
  late HabitController _habitController;
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
      value: 'daily',
      child: Text('Daily'),
    ),
    const DropdownMenuItem<String>(
      value: 'weekly',
      child: Text('Weekly'),
    ),
    const DropdownMenuItem<String>(
      value: 'biweekly',
      child: Text('Bi-Weekly'),
    ),
    const DropdownMenuItem<String>(
      value: 'monthly',
      child: Text('Monthly'),
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _habitController = context.watch<HabitController>();

    reminders.addAll(widget.initialReminders ?? []);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _habitController.createNewHabit(
        _title,
        _notes,
        _startDate,
        _endDate,
        _frequency,
        _reminders,
        _reminderMessage,
        _targetType,
        _category,
        _quantity,
      );
    }
  }

  Future<void> _updateHabit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _habitController.updateHabit(
        widget.habit!.habitId,
        newTitle: _title,
        newNote: _notes,
        newEndDate: _endDate,
        newFrequency: _frequency,
        newReminder: _reminders,
        newReminderMessage: _reminderMessage,
        newTargetType: _targetType,
        newCategory: _category,
        newQuantity: _quantity,
      );
    }
  }

  String _title = '';
  String _notes = '';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String _frequency = 'Does not repeat';
  final bool _reminders = false;
  String? _reminderMessage;
  final String _targetType = 'NO';
  String _category = '';
  int? _quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
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
                validator: (value) => value == null || value.isEmpty
                    ? 'A title is required'
                    : null,
                onChanged: (value) => _title = value,
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
                onChanged: (notes) => _notes = notes,
              ),
              const CommonHabitHeader(
                text: 'Category*',
                topPadding: 0,
              ),
              const SizedBox(
                height: 5,
              ),
              CommonDropdown(
                hintText: 'Select a category',
                dropdownItems: categoryDropdownItems,
                initialValue: widget.initialCategory,
                onChanged: (value) => setState(() => _category = value),
              ),
              const CommonHabitHeader(
                text: 'Duration*',
              ),
              _SetDurationWidgets(
                initialStart: widget.initialStart,
                initialEnd: widget.initialEnd,
                onStartDateSelected: (date) =>
                    setState(() => _startDate = date),
                onEndDateSelected: (date) => setState(() => _endDate = date),
              ),
              const CommonHabitHeader(
                text: 'Frequency*',
              ),
              CommonDropdown(
                hintText: 'Select a frequency',
                dropdownItems: frequencyDropdownItems,
                initialValue: widget.initialFrequency ??
                    frequencyDropdownItems.first.value,
                onChanged: (value) => setState(() => _frequency = value),
              ),
              const CommonHabitHeader(
                text: 'Reminders',
              ),
              _SetRemindersWidgets(
                reminders: reminders,
                initialReminderMessage: widget.initialMessage,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: () {
                  widget.edit ? _updateHabit() : _submitForm();
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ],
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
                  if (!mounted) return;

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
                      if (!mounted) return Container();

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
                if (!mounted) return;
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
  const _SetDurationWidgets({
    this.initialStart,
    this.initialEnd,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;
  final Function(DateTime) onStartDateSelected;
  final Function(DateTime) onEndDateSelected;

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
            if (!mounted) return;
            startDate = (await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(DateTime.now().year + 100),
                )) ??
                DateTime.now();
            widget.onStartDateSelected(startDate);
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
            if (!mounted) return;
            endDate = await showDatePicker(
              context: context,
              initialDate: startDate.isAfter(DateTime.now())
                  ? startDate
                  : DateTime.now(),
              firstDate: startDate,
              lastDate: DateTime(DateTime.now().year + 100),
            );
            if (endDate != null) {
              widget.onEndDateSelected(endDate!);
            }
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
