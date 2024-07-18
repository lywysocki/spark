// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:spark/user/user.dart';
import 'package:spark/user/user_repository.dart';

class UserController extends ChangeNotifier {
  UserController();

  User? currentUser;
  String? currentUserId;
  final UserRepository _userRepo = UserRepository();

  final int _idIndex = 0;
  final int _usernameIndex = 1;
  final int _passwordIndex = 2;
  final int _emailIndex = 3;
  final int _fNameIndex = 5;
  final int _lNameIndex = 6;
  final int _joinedIndex = 7;

  Future<void> login({required String username, required String pass}) async {
    if (username.length <= 1 || pass.length <= 1) {
      throw "Username or password invalid";
    }

    final results = await _userRepo.selectUsersLogin(username, pass);
    //selectUsersLogin queries only user_ids, so it returns should return a list of a list with one element: user_id
    if (results.length == 1) {
      currentUserId = results[0][0].toString();
      currentUser = await getCurrentUser();
    } else if (results.length > 1) {
      //there are multiple ids by that login, the system should not have allowed a user to create an account with an existing username
      List<dynamic> multipleIDs = results.map((row) => row[0]).toList();
      debugPrint(
        "Database contained multiple user_ids with that username/password.\n",
      );
      duplicateLogins(multipleIDs);
      throw "Error";
    } else {
      //results.length < 1
      debugPrint('Account does not exist in database.');
      throw "Username/Password incorrect.";
    }
  }

  Future<User> getCurrentUser() async {
    if (currentUserId == null) {
      throw 'No logged in user';
    }
    String fName = '';
    String? lName = '';
    String email = '';
    DateTime? joined;
    int longestStreak = 0;

    final userResults = await _userRepo.selectUsersByUserID(currentUserId!);
    if (userResults.length == 1) {
      if (userResults[0][_fNameIndex] != null) {
        fName = userResults[0][_fNameIndex];
      }
      if (userResults[0][_lNameIndex] != null) {
        lName = (userResults[0][_lNameIndex]);
      }
      if (userResults[0][_joinedIndex] != null) {
        joined = userResults[0][_joinedIndex];
      }
      if (userResults[0][_emailIndex] != null) {
        email = userResults[0][_emailIndex];
      }
    } else if (userResults.length > 1) {
      //there are multiple ids by that login, the system should not have allowed a user to create an account with an existing username
      final multipleIDs = userResults.map((row) => row[0]).toList();
      debugPrint(
        "Database contained multiple user_ids with that username/password.\n",
      );
      duplicateLogins(multipleIDs);
    } else {
      //results.length < 1
      debugPrint('Account does not exist in database.');
    }

    final streakResults = await _userRepo.selectUsersStreaks(currentUserId!);
    if (streakResults.isNotEmpty) {
      final streaks = streakResults.map((row) => row[3]).toList();
      longestStreak = streaks.reduce((a, b) => a > b ? a : b);
    }
    final user = User(
      userId: currentUserId!,
      email: email,
      fName: fName,
      lName: lName ?? '',
      joined: joined!,
      longestStreak: longestStreak,
    );

    return user;
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String pass,
    required String fName,
    String? lName,
  }) async {
    final usernameResults = await _userRepo.selectUsersByUsername(username);
    if (usernameResults.isNotEmpty) {
      throw "An account already exists by this username.";
    }

    final emailResults = await _userRepo.selectUsersByEmail(email);
    if (emailResults.isNotEmpty) {
      throw "An account exists using this email.";
    }

    await _userRepo.createUser(
      username: username,
      password: pass,
      email: email,
      first: fName,
      last: lName,
    );
    await login(username: username, pass: pass);
  }

  void duplicateLogins(List<dynamic> ids) async {
    debugPrint("Duplicate user fields: \n");
    List<Map<String, dynamic>> allDuplicates = [];
    for (int i = 0; i < ids.length; i++) {
      final results = await _userRepo.selectUsersByUserID(ids[i]);
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
}
