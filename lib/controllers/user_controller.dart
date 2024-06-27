import 'dart:ffi';

import 'package:flutter/material.dart';
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
  if (user.length <= 1 || pass.length <= 1) {
    return "Username or password invalid";
  }

  List<List<dynamic>> results = await selectUsersLogin(user, pass);
  //selectUsersLogin queries only user_ids, so it returns should return a list of a list with one element: user_id
  if (results.length == 1) {
    currentUser = results[0][0];
    return currentUser;
  } else if (results.length > 1) {
    //there are multiple ids by that login, the system should not have allowed a user to create an account with an existing username
    List<dynamic> multipleIDs = results.map((row) => row[0]).toList();
    debugPrint(
        "Database contained multiple user_ids with that username/password.\n");
    duplicateLogins(multipleIDs);
    return "Error";
  } else {
    //results.length < 1
    debugPrint('Account does not exist in database.');
    return "Account does not exist.";
  }
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
  } else if (userResults.length > 1) {
    //there are multiple ids by that login, the system should not have allowed a user to create an account with an existing username
    List<dynamic> multipleIDs = userResults.map((row) => row[0]).toList();
    debugPrint(
        "Database contained multiple user_ids with that username/password.\n");
    duplicateLogins(multipleIDs);
  } else {
    //results.length < 1
    debugPrint('Account does not exist in database.');
  }

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

void duplicateLogins(List<dynamic> ids) async {
  debugPrint("Duplicate user fields: \n");
  List<Map<String, dynamic>> allDuplicates = [];
  for (int i = 0; i < ids.length; i++) {
    List<List<dynamic>> results = await selectUsersByUserID(ids[i]);
    Map<String, dynamic> result = {
      'user_id': results[0][0],
      'username': results[0][1],
      'password': results[0][2],
      'email': results[0][3],
      'first_name': results[0][4],
      'last_name': results[0][5],
      'date_joined': results[0][6],
    };
    debugPrint('${result.toString()} \n');
    allDuplicates[i] = (result);
  }
}
