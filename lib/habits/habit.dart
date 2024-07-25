import 'package:flutter/material.dart';

class Habit {
  final String habitId;
  final String userId;
  final String title;
  final String note;
  final DateTime startDate;
  DateTime? endDate;
  final String frequency;
  final bool reminders;
  String? reminderMessage;
  final String targetType;
  final String category;
  List<DateTime>? reminderTimes;
  int? streak;

  Habit({
    required this.habitId,
    required this.userId,
    required this.title,
    required this.note,
    required this.startDate,
    this.endDate,
    required this.frequency,
    required this.reminders,
    this.reminderMessage,
    required this.targetType,
    required this.category,
    this.reminderTimes,
    this.streak,
  });

  String getId() {
    return habitId;
  }

  String getTitle() {
    return title;
  }

  String getNote() {
    return note;
  }

  DateTime getStart() {
    return startDate;
  }

  DateTime? getEnd() {
    return endDate;
  }

  String getFrequency() {
    return frequency;
  }

  bool getRemindersSet() {
    return reminders;
  }

  String? getRemindersMessage() {
    return reminderMessage;
  }

  String getTargetType() {
    return targetType;
  }

  String getCategory() {
    return category;
  }

  List<TimeOfDay>? getReminderTimes() {
    return reminderTimes?.map((e) => TimeOfDay.fromDateTime(e)).toList();
  }

  int? getStreak() {
    return streak;
  }
}
