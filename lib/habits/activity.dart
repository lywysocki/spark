class Activity {
  Activity({
    required this.activityId,
    required this.userId,
    required this.habitId,
    required this.timestamp,
    this.quantity,
  });

  final String activityId;
  final String userId;
  final String habitId;
  final DateTime timestamp;
  int? quantity;
}
