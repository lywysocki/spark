class User {
  User({
    required this.userId,
    required this.email,
    required this.fName,
    required this.lName,
    required this.joined,
    required this.longestStreak,
  });
  final String userId;
  final String email;
  final String fName;
  final String lName;
  final String joined;
  final int longestStreak;
}
