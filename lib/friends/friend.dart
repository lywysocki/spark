import 'package:spark/habits/habit.dart';

class Friend {
  final String userId;
  final String username;
  final String fName;
  final String lName;
  bool isPending = false;

  List<Habit> sharedHabits = [];

  Friend({
    required this.userId,
    required this.username,
    required this.fName,
    required this.lName,
    this.isPending = false,
  });

  String getName() => '$fName $lName';

  void setSharedHabits({required List<Habit> sharedHabits}) {
    this.sharedHabits = sharedHabits;
  }
}
