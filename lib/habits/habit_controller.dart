import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spark/habits/habit_repository.dart';
import 'package:spark/habits/habit.dart';

import 'activity.dart';

//habits: habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
//activities: user_id, habit_id, timestamp, quanity
class HabitController extends ChangeNotifier {
  HabitController();

  final HabitRepository _habitRepo = HabitRepository();

  bool loading = false;

  String _currentUserId = '';

  List<Habit> allHabits = [];
  List<Habit> todaysHabits = [];
  List<Habit> tomorrowsHabits = [];

  Future<void> _load() async {
    loading = true;

    allHabits.clear();
    allHabits = await loadAllHabits();
    todaysHabits.clear();
    todaysHabits = await getTodaysHabits();
    tomorrowsHabits.clear();
    tomorrowsHabits = await getTomorrowsHabits();

    loading = false;

    if (!hasListeners) return;
    notifyListeners();
  }

  Future<void> updateUser(String newUserId) async {
    _currentUserId = newUserId;
    await _load();
  }

//Homepage methods
  Future<List<Habit>> loadAllHabits() async {
    // Get all habits
    List<List<dynamic>> allHabitsAllData =
        await _habitRepo.selectHabitsByUserID(_currentUserId);
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
        habitId: row[0].toString(),
        userId: row[1].toString(),
        title: row[2],
        note: row[3],
        startDate: row[4],
        endDate: row[5],
        frequency: row[6],
        reminders: row[7],
        reminderMessage: row[8],
        targetType: row[9],
        category: row[10],
        quantity: row[11],
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

    List<List<dynamic>> todaysHabitsAllData =
        await _habitRepo.selectHabitsByDate(_currentUserId, today);
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
        habitId: row[0].toString(),
        userId: row[1].toString(),
        title: row[2],
        note: row[3],
        startDate: row[4],
        endDate: row[5],
        frequency: row[6],
        reminders: row[7],
        reminderMessage: row[8],
        targetType: row[9],
        category: row[10],
        quantity: row[11],
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

    // Get tomorrow's habits
    List<List<dynamic>> tomorrowsHabitsAllData =
        await _habitRepo.selectHabitsByDate(_currentUserId, tomorrow);
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
        habitId: row[0].toString(),
        userId: row[1].toString(),
        title: row[2],
        note: row[3],
        startDate: row[4],
        endDate: row[5],
        frequency: row[6],
        reminders: row[7],
        reminderMessage: row[8],
        targetType: row[9],
        category: row[10],
        quantity: row[11],
        streak: row[12],
      );
      habits.add(h);
    }

    return habits;
  }

//New Habit page
  Future<void> createNewHabit(
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
        await _habitRepo.selectHabitsByTitle(_currentUserId, title);

    if (existingHabit.isNotEmpty) {
      //if habit with this title exists
      throw "Habit by that name exists";
    } else {
      //if habit doesn't exist, create it
      _habitRepo.createHabit(
        _currentUserId,
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

      await _load();
      notifyListeners();
    }
  }

  Future<void> updateHabit(
    String habitId, {
    String? newTitle,
    String? newNote,
    DateTime? newEndDate,
    String? newFrequency,
    bool? newReminder,
    String? newReminderMessage,
    String? newTargetType,
    String? newCategory,
    int? newQuantity,
  }) async {
    if (newTitle != null) {
      await _habitRepo.updateHabitTitle(habitId, newTitle);
    }

    if (newNote != null) {
      await _habitRepo.updateHabitNote(habitId, newNote);
    }

    if (newEndDate != null) {
      await _habitRepo.updateHabitEnd(habitId, newEndDate);
    }

    if (newFrequency != null) {
      await _habitRepo.updateHabitFrequency(habitId, newFrequency);
    }

    if (newReminder != null) {
      await _habitRepo.updateHabitReminders(habitId, newReminder);
    }

    if (newReminderMessage != null) {
      await _habitRepo.updateHabitReminderMessage(habitId, newReminderMessage);
    }

    if (newTargetType != null) {
      await _habitRepo.updateHabitTargetType(habitId, newTargetType);
    }

    if (newCategory != null) {
      await _habitRepo.updateHabitCategory(habitId, newCategory);
    }

    if (newQuantity != null) {
      await _habitRepo.updateHabitQuantity(habitId, newQuantity);
    }

    await _load();
    notifyListeners();
  }

  Future<List<Habit>> getAllHabits() async {
    return allHabits;
  }

//Habit View
  Future<Habit> getHabit(String habitID) async {
    List<List<dynamic>> habitAllData =
        await _habitRepo.selectHabitByID(_currentUserId, habitID);

    if (habitAllData.length > 1) {
      //there are multiple habits with that habit_id
      //this should not happen because postgres generates unique ids for each row
      debugPrint("Database contained multiple habit_id.\n");
      duplicateHabitIDs(habitAllData);
    } else {
      //results.length < 1
      debugPrint('Account does not exist in database.');
    }
    if (habitAllData.isEmpty) {
      throw Exception('No habit found with habit ID: $habitID');
    }
    if (habitAllData[0].length < 13) {
      throw Exception('Insufficient data to create Habit object');
    }

    //if there's only 1 habit by that id, it returns
    //if there's multiple, it only returns the first
    Habit habit = Habit(
      habitId: habitAllData[0][0],
      userId: habitAllData[0][1],
      title: habitAllData[0][2],
      note: habitAllData[0][3],
      startDate: habitAllData[0][4],
      endDate: habitAllData[0][5],
      frequency: habitAllData[0][6],
      reminders: habitAllData[0][7],
      reminderMessage: habitAllData[0][8],
      targetType: habitAllData[0][9],
      category: habitAllData[0][10],
      quantity: habitAllData[0][11],
      streak: habitAllData[0][12],
    );

    return habit;
  }

  Future<void> logActivity(String habitID, int? quantity) async {
    List<List<dynamic>> habits =
        await _habitRepo.selectHabitByID(_currentUserId, habitID);

    if (habits.length == 1) {
      _habitRepo.createActivity(_currentUserId, habitID, quantity);
    } else {
      duplicateHabitIDs(habits);
      debugPrint(
        'Tried to log activity for habit $habitID, but there was an issue.',
      );
    }
  }

  Future<List<Habit>> getSharedHabits({
    required String userId,
    required String friendUserId,
  }) async {
    final results = await _habitRepo.getSharedHabits(
      userId: userId,
      friendUserId: friendUserId,
    );

    List<Habit> habits = [];
    for (var row in results) {
      Habit h = Habit(
        habitId: row[0].toString(),
        userId: row[1].toString(),
        title: row[2],
        note: row[3],
        startDate: row[4],
        endDate: row[5],
        frequency: row[6],
        reminders: row[7],
        reminderMessage: row[8],
        targetType: row[9],
        category: row[10],
        quantity: row[11],
        streak: row[12],
      );
      habits.add(h);
    }

    return habits;
  }

  Future<void> createSharedHabit({
    required Habit habit,
    required String friendUserId,
  }) async {
    await _habitRepo.createSharedHabit(
      habitId: habit.habitId,
      friendUserId: friendUserId,
      title: habit.title,
      note: habit.note,
      start: habit.startDate,
      frequency: habit.frequency,
      reminders: habit.reminders,
      targetType: habit.targetType,
      category: habit.category,
    );

    if (hasListeners) notifyListeners();
  }

  Future<bool> hasActivityLoggedToday(String habitId) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();
    String today = dateFormat.format(now);

    List<Activity> activitiesForHabit =
        await getActivities(_currentUserId, habitId);

    bool loggedToday = activitiesForHabit.any((activity) {
      DateTime activityDate = activity.timestamp;
      String formattedActivityDate = dateFormat.format(activityDate);
      return formattedActivityDate == today;
    });

    return loggedToday;
  }

  Future<List<Activity>> getActivities(String habitId, String userId) async {
    List<List<dynamic>> allActivities =
        await _habitRepo.getActivity(_currentUserId, habitId);

    List<Activity> activities = [];

    for (var row in allActivities) {
      Activity a = Activity(
        activityId: row[0].toString(),
        userId: row[1].toString(),
        habitId: row[2].toString(),
        timestamp: row[3],
        quantity: row[4],
      );
      activities.add(a);
    }
    return activities;
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitRepo.deleteHabitCascade(habitId, _currentUserId);

    await _load();
    notifyListeners();
  }

  Future<void> deleteHabitByTitle(String title) async {
    List<List<dynamic>> habits =
        await _habitRepo.selectHabitsByTitle(_currentUserId, title);

    if (habits.length == 1) {
      _habitRepo.deleteHabitCascade(title, _currentUserId);
      allHabits = await loadAllHabits();
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
