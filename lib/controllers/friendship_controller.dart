import 'package:flutter/material.dart';
import 'package:spark/postgres_functions.dart';
import 'package:spark/friends/friend.dart';

//friendships:   user1_id, user2_id
class FriendshipController extends ChangeNotifier {
  final String currentUserId;

  FriendshipController({required this.currentUserId}) {
    _load();
  }

  List<Friend> allFriends = [];
  List<Friend> todaysHabits = [];
  List<Friend> tomorrowsHabits = [];

  Future<void> _load() async {
    allFriends = await getAllFriends();
  }

//Friends List View
  Future<List<Friend>> getAllFriends() async {
    List<List<dynamic>> allFriendData =
        await selectFriendsByUser(currentUserId);
    //selectFriendsByUser returns a list of friends data in format [id, username, first, last]
    int friendsIdIndex = 0;
    int friendsUsernameIndex = 1;
    int friendsFirstIndex = 2;
    int friendsLastIndex = 3;

    //pull out just the ids, titles, and streaks
    List<Friend> friends = [];

    for (var row in allFriendData) {
      Friend f = Friend(
        userId: row[friendsIdIndex],
        username: row[friendsUsernameIndex],
        firstName: row[friendsFirstIndex],
        lastName: row[friendsLastIndex],
      );
      friends.add(f);
    }

    return friends;
  }

  Future<List<Map<String, dynamic>>> viewSharedHabits(
    String friendId,
  ) async {
    List<List<dynamic>> allSharedHabitData =
        await selectSharedHabits(currentUserId, friendId);

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
