class Achievement {
  Achievement({
    required this.achievementId,
    required this.userId,
    required this.habitId,
    required this.achievementTitle,
    required this.time,
    this.quantity,
  });

  final String achievementId;
  final String userId;
  final String habitId;
  final String achievementTitle;
  final DateTime time;
  final int? quantity;
}
