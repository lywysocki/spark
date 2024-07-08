import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:spark/postgres_functions.dart';

//friendships:   user1_id, user2_id
class FriendshipController extends ChangeNotifier {
//Friends List View
  Future<List<Map<String, dynamic>>> viewAllFriends(String userID) async {
    List<List<dynamic>> allFriendData = await selectFriendsByUser(userID);
    //selectFriendsByUser returns a list of friends data in format [id, username, first, last]
    int friendsIdIndex = 0;
    int friendsUsernameIndex = 1;
    int friendsFirstIndex = 2;
    int friendsLastIndex = 3;

    //pull out just the ids, titles, and streaks
    List<Map<String, dynamic>> allFriendsQuickView = allFriendData.map((row) {
      return {
        'friendsID': row[friendsIdIndex],
        'friendsUsername': row[friendsUsernameIndex],
        'friendsFullName': row[friendsFirstIndex] + ' ' + row[friendsLastIndex],
      };
    }).toList();

    return allFriendsQuickView;
  }

  Future<List<Map<String, dynamic>>> viewSharedHabits(
      String user, String friend) async {
    List<List<dynamic>> allSharedHabitData =
        await selectSharedHabits(user, friend);

    List<Map<String, dynamic>> sharedHabitQuickView =
        allSharedHabitData.map((row) {
      return {
        'habit_id': row[0],
        'title': row[1],
      };
    }).toList();

    return sharedHabitQuickView;
  }
}
