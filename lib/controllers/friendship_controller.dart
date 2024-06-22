import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:spark/postgres_functions.dart';

//friendships:   user1_id, user2_id

//Friends List View
Future<List<List<dynamic>>> viewAllFriends(String userID) async {
  List<List<dynamic>> allFriendData  = await selectFriendsByUser(userID);
  //selectFriendsByUser returns a list of friends data in format [id, username, first, last]
  int friendsIdIndex = 0;
  int friendsUsernameIndex = 1;
  int friendsFirstIndex = 2;
  int friendsLastIndex = 3;
  
  //pull out just the ids, titles, and streaks
  List<List<dynamic>> allFriendsQuickView = allFriendData.map((innerList) {
    // Ensure the inner list has at least two elements
    if (innerList.length >= 4) {
      String friendsFullName = innerList[friendsFirstIndex]+ ' ' + innerList[friendsLastIndex];
      return [innerList[friendsIdIndex], innerList[friendsUsernameIndex], friendsFullName];
    } else {
      return [];
    }
  }).toList();

  return allFriendsQuickView;
}