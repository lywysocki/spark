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

String login(String user, String pass) {
  selectUsersLogin(user, pass).then((results) {
    if (results.length==1){
      currentUser = results[0][idIndex];

    }
  });

  return "Error";
}

List<dynamic> profile(String user, String pass) {
  String name = 'Guest';
  DateTime joined;
  int longestStreak;

  selectUsersByUserID(currentUser).then((results) {
    if (results.length==1){
      if (results[0][fNameIndex] == null){
        if(results[0][usernameIndex]!=null){
          if (results[0][lNameIndex] == null){
            name = results[0][fNameIndex];
          } else {
            name = results[0][fNameIndex] + (name = results[0][lNameIndex]);
          }
        }
      }
      longestStreak = 0;

      List<dynamic> profileFields = [name, results[0][joinedIndex], longestStreak];
      return profileFields;
    }
  });

  List<dynamic> profileFields = [null, null, null];
  return profileFields;

}

String signup(String user, String email, String pass) {
  selectUsersByUsername(user).then((results) {
    if (results.length>0){
      return "An account already exists by this username.";
    }
  });

  selectUsersByEmail(email).then((results) {
    if (results.length>0){
      return "An account exists using this email.";
    }
  });

  createUser(user, pass, email, null, null);

  return "Account created";
}

