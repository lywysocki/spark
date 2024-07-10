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
  int? quantity;

  Habit({
    required this.habitId,
    required this.userId,
    required this.title,
    required this.note,
    required this.startDate,
    DateTime? end,
    required this.frequency,
    required this.reminders,
    String? msg,
    required this.targetType,
    required this.category,
    int? quan,
  })  : endDate = end,
        reminderMessage = msg,
        quantity = quan;
}
