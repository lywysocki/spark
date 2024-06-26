import 'dart:ffi';

import 'package:spark/postgres_functions.dart';

String currentUser = '';
//users:    user_id, username, password, email, first_name, last_name, date joined
int idIndex = 0;
int usernameIndex = 1;
int passwordIndex = 2;
int emailIndex = 3;
int fNameIndex = 4;
int lNameIndex = 5;
int joinedIndex = 6;

Future<String> login(String user, String pass) async {
  List<List<dynamic>> results = await selectUsersLogin(user, pass);
  if (results.length == 1) {
    currentUser = results[0][idIndex];
    return currentUser;
  }
  //check if multiple lines
  //check in no lines

  return "Error";
}

Future<Map<String, dynamic>> profile(String pass) async {
  String name = 'Guest';
  String joined = 'Null';
  int longestStreak = 0;

  List<List<dynamic>> userResults = await selectUsersByUserID(currentUser);
  if (userResults.length == 1) {
    if (userResults[0][fNameIndex] == null) {
      if (userResults[0][usernameIndex] != null) {
        if (userResults[0][lNameIndex] == null) {
          name = userResults[0][fNameIndex];
        } else {
          name = userResults[0][fNameIndex] + (userResults[0][lNameIndex]);
        }
      }
    }
    joined = userResults[0][joinedIndex];
  }
  //check if multiple lines
  //check if no lines

  List<List<dynamic>> streakResults = await selectHabitStreaks(currentUser);
  if (streakResults.isNotEmpty) {
    List<dynamic> streaks = streakResults.map((row) => row[3]).toList();
    longestStreak = streaks.reduce((a, b) => a > b ? a : b);
  }

  var profileFields = {
    'name': name,
    'joined date': joined,
    'longest streak': longestStreak
  };
  return profileFields;
}

Future<String> signup(String user, String email, String pass) async {
  List<List<dynamic>> usernameResults = await selectUsersByUsername(user);
  if (usernameResults.isNotEmpty) {
    return "An account already exists by this username.";
  }

  List<List<dynamic>> emailResults = await selectUsersByEmail(email);
  if (emailResults.isNotEmpty) {
    return "An account exists using this email.";
  }

  createUser(user, pass, email, null, null);
  return "Account created";
}
