class Achievement {
  Achievement({
    required this.achievementID,
    required this.userID,
    required this.habitID,
    required this.achievementTitle,
    required this.time,
    this.quantity,
  });

  final String achievementID;
  final String userID;
  final String habitID;
  final String achievementTitle;
  final DateTime time;
  final int? quantity;
}
