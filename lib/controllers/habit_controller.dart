import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:spark/postgres_functions.dart';

//habits:    habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
int habitIdIndex = 0;
int habitTitleIndex = 2;
//streakIndex;

//Homepage methods
Future<List<List<List<dynamic>>>> getUpcomingHabits(String user) async {

  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String today = dateFormat.format(now);
  DateTime todayFormatted = dateFormat.parse(today);

  DateTime tom = now.add(Duration(days: 1));
  String tomorrow = dateFormat.format(tom);
  DateTime tomorrowFormatted = dateFormat.parse(tomorrow);

  // Get today's habits
  List<List<dynamic>> todaysHabitsAllData = await selectHabitsByDate(user, todayFormatted);
  //pull out just the ids, titles, and streaks
  List<List<dynamic>> todaysHabitsQuickView = todaysHabitsAllData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 2) {
      return [innerList[habitIdIndex], innerList[habitTitleIndex]]; //innerList[streakIndex]
    } else {
      return [];
    }
  }).toList();

  // Get tomorrow's habits
  List<List<dynamic>> tomorrowsHabitsAllData = await selectHabitsByDate(user, tomorrowFormatted);
  //pull out just the ids, titles, and streaks
  List<List<dynamic>> tomorrowsHabitsQuickView = tomorrowsHabitsAllData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 2) {
      return [innerList[habitIdIndex], innerList[habitTitleIndex]]; //innerList[streakIndex]
    } else {
      return [];
    }
  }).toList();

  /* upcomingHabits
   * [x][y][z] where... 
   * x is 0(todays habits) or 1(tomorrows habits),
   * y is the index of the individual habit in that list
   * z is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  List<List<List<dynamic>>> upcomingHabits = [todaysHabitsAllData, tomorrowsHabitsAllData];
  return upcomingHabits;

}

Future<List<List<dynamic>>> getTodaysHabits(String user) async {

  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String today = dateFormat.format(now);
  DateTime todayFormatted = dateFormat.parse(today);

  // Get today's habits
  List<List<dynamic>> todaysHabitsAllData = await selectHabitsByDate(user, todayFormatted);

  //pull out just the ids, titles, and streaks
  List<List<dynamic>> todaysHabitsQuickView = todaysHabitsAllData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 2) {
      return [innerList[habitIdIndex], innerList[habitTitleIndex]]; //innerList[streakIndex]
    } else {
      return [];
    }
  }).toList();

  /* todaysHabits
   * [x][y] where... 
   * x is the index of the individual habit in that list
   * y is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  return todaysHabitsAllData;

}

Future<List<List<dynamic>>> getTomorrowsHabits(String user) async {

  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime tom = DateTime.now().add(Duration(days: 1));
  String tomorrow = dateFormat.format(tom);
  DateTime tomorrowFormatted = dateFormat.parse(tomorrow);

  // Get tomorrow's habits
  List<List<dynamic>> tomorrowsHabitsAllData = await selectHabitsByDate(user, tomorrowFormatted);

  //pull out just the ids, titles, and streaks
  List<List<dynamic>> tomorrowsHabitsQuickView = tomorrowsHabitsAllData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 2) {
      return [innerList[habitIdIndex], innerList[habitTitleIndex]]; //innerList[streakIndex]
    } else {
      return [];
    }
  }).toList();

  /* tomorrowsHabits
   * [x][y] where... 
   * x is the index of the individual habit in that list
   * y is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  return tomorrowsHabitsQuickView;

}

//New Habit page
Future<String> createNewHabit(String userID, String title, String note, DateTime start, DateTime end, String frequency, bool reminders, String? reminderMessage, String targetType, String category, int? quantity) async {

  //check if user has a habit like this already?
  List<List<dynamic>> existingHabit = await selectHabitsByTitle(userID, title);
 
  if(existingHabit.isNotEmpty){ //if habit with this title exists
    return("Exists");
  } else { //if habit doesn't exist, create it
    createHabit(userID, title, note, start, end, frequency, reminders, reminderMessage, targetType, category, quantity);
    return("Complete");
  }

}

//All Habit View
Future<List<List<dynamic>>> viewAllHabits(String userID) async {
  List<List<dynamic>> allHabitsAllData = await selectHabitsByUserID(userID);
  
  //pull out just the ids, titles, and streaks
  List<List<dynamic>> allHabitsQuickView = allHabitsAllData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 2) {
      return [innerList[habitIdIndex], innerList[habitTitleIndex]]; //innerList[streakIndex]
    } else {
      return [];
    }
  }).toList();

  return allHabitsQuickView;
}


//Habit View
Future<List<dynamic>> viewHabit(String userID, String id) async {
  //NEW METHOD FOR SELECTING ALL HABIT DATA BY ID
  List<List<dynamic>> habitAllData = await selectHabitsByUserID(userID);
  //
  if (habitAllData.length==1){
    return habitAllData[0]; //return the one habit in list
  }
  //check if multiple rows
  //check if no rows

  return habitAllData;
}

Future<void> deleteHabit(String userID, String title) async {
  List<List<dynamic>> habits = await selectHabitsByTitle(userID, title);

  if(habits.length==1){
    deleteHabit(userID, title);
  } else {
    debugPrint('Tried to delete habit $title, but there was an issue.');
  }
}