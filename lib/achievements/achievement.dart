class Achievement {
  Achievement(
    this.achievementID,
    this.userID,
    this.habitID,
    this.achievementTitle,
    this.date,
    this.time,
    this.quantity,
  );

  final String achievementID;
  final String userID;
  final String habitID;
  final String achievementTitle;
  final DateTime date;
  final DateTime time;
  final int? quantity;
}
