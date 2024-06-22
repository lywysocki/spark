import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:spark/postgres_functions.dart';

//habits:    habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity

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
  List<List<dynamic>> todaysHabits = await selectHabitsByDate(user, todayFormatted);

  // Get tomorrow's habits
  List<List<dynamic>> tomorrowsHabits = await selectHabitsByDate(user, tomorrowFormatted);

  /* upcomingHabits
   * [x][y][z] where... 
   * x is 0(todays habits) or 1(tomorrows habits),
   * y is the index of the individual habit in that list
   * z is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  List<List<List<dynamic>>> upcomingHabits = [todaysHabits, tomorrowsHabits];
  return upcomingHabits;

}

Future<List<List<dynamic>>> getTodaysHabits(String user) async {

  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String today = dateFormat.format(now);
  DateTime todayFormatted = dateFormat.parse(today);

  // Get today's habits
  List<List<dynamic>> todaysHabits = await selectHabitsByDate(user, todayFormatted);

  /* todaysHabits
   * [x][y] where... 
   * x is the index of the individual habit in that list
   * y is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  return todaysHabits;

}

Future<List<List<dynamic>>> getTomorrowsHabits(String user) async {

  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime tom = DateTime.now().add(Duration(days: 1));
  String tomorrow = dateFormat.format(tom);
  DateTime tomorrowFormatted = dateFormat.parse(tomorrow);

  // Get tomorrow's habits
  List<List<dynamic>> tomorrowsHabits = await selectHabitsByDate(user, tomorrowFormatted);

  /* tomorrowsHabits
   * [x][y] where... 
   * x is the index of the individual habit in that list
   * y is the variable of the habit 0(habit_id), 1(habit_title), 2(streak)
  */
  return tomorrowsHabits;

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
Future<List<List<dynamic>>> viewAllHabits(String userID){
  
}


//Habit View
Future<List<dynamic>> viewHabit(String userID, String title){

}

Future<void> deleteHabit(String userID, String title) async {
  List<List<dynamic>> habits = await selectHabitsByTitle(userID, title);

  if(habits.length==1){
    deleteHabit(userID, title);
  } else {
    debugPrint('Tried to delete habit $title, but there were more than one habits by that name for this user.');
  }
}