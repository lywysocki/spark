import 'package:flutter/material.dart';
import 'package:spark/common/common_dropdown.dart';
import 'package:spark/common/common_textfield.dart';

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
            const _NewHabitForm(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
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
        ),
      ),
    );
  }
}

class _NewHabitForm extends StatefulWidget {
  const _NewHabitForm();

  @override
  State<_NewHabitForm> createState() => __NewHabitFormState();
}

class __NewHabitFormState extends State<_NewHabitForm> {
  final _formKey = GlobalKey<FormState>();
  String habitRadio = 'Positive habit';
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _HeaderTextWidget(
            text: 'Title*',
            bottomPadding: 0,
          ),
          const CommonTextfield(
            hintText: 'Enter a title',
            maxLength: 20,
          ),
          const _HeaderTextWidget(
            text: 'Notes',
            topPadding: 0,
            bottomPadding: 0,
          ),
          const CommonTextfield(
            hintText: 'Enter optional notes',
            maxLength: 100,
            maxLines: 3,
          ),
          const _HeaderTextWidget(
            text: 'Category*',
            topPadding: 0,
          ),
          Row(
            children: [
              Radio(
                value: 'Positive habit',
                groupValue: habitRadio,
                onChanged: (value) {
                  habitRadio = value ?? 'Positive habit';
                  setState(() {});
                },
              ),
              const Text('Positive habit'),
              const SizedBox(
                width: 10,
              ),
              Radio(
                value: 'Negative habit',
                groupValue: habitRadio,
                onChanged: (value) {
                  habitRadio = value ?? 'Negative habit';
                  setState(() {});
                },
              ),
              const Text('Negative habit'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          CommonDropdown(
            hintText: 'Select a category',
            dropdownItems: categoryDropdownItems,
          ),
          const _HeaderTextWidget(
            text: 'Duration*',
          ),
          const _SetDurationWidgets(),
          const _HeaderTextWidget(
            text: 'Frequency*',
          ),
          CommonDropdown(
            hintText: 'Select a frequency',
            dropdownItems: frequencyDropdownItems,
          ),
          const _HeaderTextWidget(
            text: 'Reminders',
          ),
          _SetRemindersWidgets(
            reminders: reminders,
          ),
          if (reminders.isNotEmpty)
            const _HeaderTextWidget(
              text: 'Reminder note',
            ),
          if (reminders.isNotEmpty)
            const CommonTextfield(
              hintText: 'Enter optional reminder note',
              maxLength: 100,
              maxLines: 3,
            ),
        ],
      ),
    );
  }
}

class _SetRemindersWidgets extends StatefulWidget {
  const _SetRemindersWidgets({
    required this.reminders,
  });

  final List<TimeOfDay> reminders;

  @override
  State<_SetRemindersWidgets> createState() => __SetRemindersWidgetsState();
}

class __SetRemindersWidgetsState extends State<_SetRemindersWidgets> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (final time in widget.reminders)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            width: 90,
            height: 33,
            child: Stack(
              children: [
                const CommonTextfield(
                  isTapped: true,
                ),
                TextButton(
                  child: Center(
                    child: Text(time.format(context)),
                  ),
                  onPressed: () async {
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
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          width: 90,
          height: 33,
          child: Stack(
            children: [
              const CommonTextfield(
                isTapped: true,
              ),
              TextButton(
                child: const Center(
                  child: Icon(Icons.add),
                ),
                onPressed: () async {
                  final time = (await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ));
                  if (time != null) widget.reminders.add(time);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetDurationWidgets extends StatefulWidget {
  const _SetDurationWidgets();

  @override
  State<_SetDurationWidgets> createState() => __SetDurationWidgetsState();
}

class __SetDurationWidgetsState extends State<_SetDurationWidgets> {
  DateTime startDate = DateTime.now();
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(' Start date'),
            SizedBox(
              width: 105,
              height: 33,
              child: Stack(
                children: [
                  const CommonTextfield(
                    isTapped: true,
                  ),
                  TextButton(
                    child: Center(
                      child: Text(startDate.toString().substring(0, 10)),
                    ),
                    onPressed: () async {
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
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
          child: Text('to'),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(' End date'),
            SizedBox(
              width: 105,
              height: 33,
              child: Stack(
                children: [
                  const CommonTextfield(
                    isTapped: true,
                  ),
                  TextButton(
                    child: Center(
                      child: Text(
                        endDate != null
                            ? endDate.toString().substring(0, 10)
                            : 'None',
                      ),
                    ),
                    onPressed: () async {
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget({
    required this.text,
    this.topPadding,
    this.bottomPadding,
  });

  final String text;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: topPadding ?? 20, bottom: bottomPadding ?? 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
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
