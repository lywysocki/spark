import 'package:spark/habits/habit.dart';

class Friend {
  final String userId;
  final String username;
  final String firstName;
  final String lastName;

  List<Habit> sharedHabits = [];

  Friend({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  String getUserId() {
    return userId;
  }

  String getUsername() {
    return username;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  List<Habit> getSharedHabits() {
    return sharedHabits;
  }

  void setSharedHabits(List<Habit> sharedHabits) {}
}
