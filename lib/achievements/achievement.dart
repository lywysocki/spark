class Achievement {
  Achievement(
    this.achievementID,
    this.userID,
    this.habitID,
    this.achievementTitle,
    this.time,
    this.quantity,
  );

  final String achievementID;
  final String userID;
  final String habitID;
  final String achievementTitle;
  final DateTime time;
  final int? quantity;
}
