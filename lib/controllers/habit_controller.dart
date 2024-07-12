import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spark/postgres_functions.dart';
import 'package:spark/habits/habit.dart';

//habits: habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
//activities: user_id, habit_id, timestamp, quanity
class HabitController extends ChangeNotifier {
  final String currentUserId;

  HabitController({required this.currentUserId}) {
    _load();
  }

  List<Habit> allHabits = [];
  List<Habit> todaysHabits = [];
  List<Habit> tomorrowsHabits = [];

  Future<void> _load() async {
    allHabits = await getAllHabits();
    todaysHabits = await getTodaysHabits();
    tomorrowsHabits = await getTomorrowsHabits();
  }

//Homepage methods
  Future<List<Habit>> getAllHabits() async {
    // Get all habits
    List<List<dynamic>> allHabitsAllData =
        await selectHabitsByUserID(currentUserId);
    /* returned fields:
        habit_id,
        user_id,
        title,
        note,
        start_date,
        end_date,
        frequency,
        reminders,
        reminder_message,
        target_type,
        category,
        quantity,
        streak
      */

    List<Habit> habits = [];
    //convert rows to a Habit and add to list
    for (var row in allHabitsAllData) {
      Habit h = Habit(
        habitId: row[0],
        userId: row[1],
        title: row[2],
        note: row[3],
        startDate: row[4],
        end: row[5],
        frequency: row[6],
        reminders: row[7],
        msg: row[8],
        targetType: row[9],
        category: row[10],
        quan: row[11],
        streak: row[12],
      );
      habits.add(h);
    }

    return habits;
  }

  Future<List<Habit>> getTodaysHabits() async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();
    String today = dateFormat.format(now);
    DateTime todayFormatted = dateFormat.parse(today);

    List<List<dynamic>> todaysHabitsAllData =
        await selectHabitsByDate(currentUserId, todayFormatted);
    /* returned fields:
        habit_id,
        user_id,
        title,
        note,
        start_date,
        end_date,
        frequency,
        reminders,
        reminder_message,
        target_type,
        category,
        quantity,
        sequential_date_count,
        most_recent_activity,
        next_due_date <- all will have the same date, the second parameter in the function call
      */

    List<Habit> habits = [];
    for (var row in todaysHabitsAllData) {
      Habit h = Habit(
        habitId: row[0],
        userId: row[1],
        title: row[2],
        note: row[3],
        startDate: row[4],
        end: row[5],
        frequency: row[6],
        reminders: row[7],
        msg: row[8],
        targetType: row[9],
        category: row[10],
        quan: row[11],
        streak: row[12],
      );
      habits.add(h);
    }

    return habits;
  }

  Future<List<Habit>> getTomorrowsHabits() async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    DateTime tom = DateTime.now().add(const Duration(days: 1));
    String tomorrow = dateFormat.format(tom);
    DateTime tomorrowFormatted = dateFormat.parse(tomorrow);

    // Get tomorrow's habits
    List<List<dynamic>> tomorrowsHabitsAllData =
        await selectHabitsByDate(currentUserId, tomorrowFormatted);
    /* returned fields:
      habit_id,
        user_id,
        title,
        note,
        start_date,
        end_date,
        frequency,
        reminders,
        reminder_message,
        target_type,
        category,
        quantity,
        sequential_date_count,
        most_recent_activity,
        next_due_date <- all will have the same date, the second parameter in the function call
      */

    List<Habit> habits = [];
    for (var row in tomorrowsHabitsAllData) {
      Habit h = Habit(
        habitId: row[0],
        userId: row[1],
        title: row[2],
        note: row[3],
        startDate: row[4],
        end: row[5],
        frequency: row[6],
        reminders: row[7],
        msg: row[8],
        targetType: row[9],
        category: row[10],
        quan: row[11],
        streak: row[12],
      );
      habits.add(h);
    }

    return habits;
  }

//New Habit page
  Future<void> createNewHabit(
    String userID,
    String title,
    String note,
    DateTime start,
    DateTime? end,
    String frequency,
    bool reminders,
    String? reminderMessage,
    String targetType,
    String category,
    int? quantity,
  ) async {
    //check if user has a habit like this already?
    List<List<dynamic>> existingHabit =
        await selectHabitsByTitle(userID, title);

    if (existingHabit.isNotEmpty) {
      //if habit with this title exists
      throw "Habit by that name exists";
    } else {
      //if habit doesn't exist, create it
      createHabit(
        userID,
        title,
        note,
        start,
        end,
        frequency,
        reminders,
        reminderMessage,
        targetType,
        category,
        quantity,
      );
    }
  }

//All Habit View
  Future<List<Habit>> viewAllHabits() async {
    return allHabits;
  }

//Habit View
  Future<List<dynamic>> getHabit(String habitID) async {
    List<List<dynamic>> habitAllData =
        await selectHabitByID(currentUserId, habitID);

    if (habitAllData.length > 1) {
      //there are multiple habits with that habit_id
      //this should not happen because postgres generates unique ids for each row
      debugPrint("Database contained multiple habit_id.\n");
      duplicateHabitIDs(habitAllData);
    } else {
      //results.length < 1
      debugPrint('Account does not exist in database.');
    }

    //if there's only 1 habit by that id, it returns
    //if there's multiple, it only returns the first
    return habitAllData[0];
  }

  Future<void> logActivity(String habitID, int? quantity) async {
    List<List<dynamic>> habits = await selectHabitByID(currentUserId, habitID);

    if (habits.length == 1) {
      createActivity(currentUserId, habitID, quantity);
    } else {
      duplicateHabitIDs(habits);
      debugPrint(
        'Tried to log activity for habit $habitID, but there was an issue.',
      );
    }
  }

  Future<void> deleteHabitByTitle(String title) async {
    List<List<dynamic>> habits =
        await selectHabitsByTitle(currentUserId, title);

    if (habits.length == 1) {
      deleteHabitCascade(title);
      allHabits = await getAllHabits();
    } else {
      duplicateHabitIDs(habits);
      debugPrint('Tried to delete habit $title, but there was an issue.');
    }
  }

  //a habit id is generated by postgres, and each should be unique so there should never be duplicate habit ids in habits table
  void duplicateHabitIDs(List<List<dynamic>> habits) async {
    debugPrint("Duplicate habit fields: \n");

    for (int i = 0; i < habits.length; i++) {
      Map<String, dynamic> result = {
        'habit_id': habits[i][0],
        'user_id': habits[i][1],
        'title': habits[i][2],
        'note': habits[i][3],
        'start_date': habits[i][4],
        'end_date': habits[i][5],
        'frequency': habits[i][6],
        'reminders': habits[i][7],
        'reminder_message': habits[i][8],
        'target_type': habits[i][9],
        'category': habits[i][10],
        'quantity': habits[i][11],
      };
      debugPrint('${result.toString()} \n');
    }
  }
}
