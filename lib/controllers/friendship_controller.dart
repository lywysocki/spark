import 'package:flutter/material.dart';
import 'package:spark/postgres_functions.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/habits/habit.dart';

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

      List<List<dynamic>> sharedHabitsData =
          await selectSharedHabits(currentUserId, row[friendsIdIndex]);
      List<Habit> sharedHabits = [];

      Habit h = Habit(
        habitId: row[0],
        userId: row[1],
        title: row[2],
        note: row[3],
        startDate: row[4],
        end: row[5],
        frequency: row[6],
        reminders: row[7],
        msg: row[8],
        targetType: row[9],
        category: row[10],
        quan: row[11],
        streak: row[12],
      );
      sharedHabits.add(h);

      f.setSharedHabits(sharedHabits);
      friends.add(f);
    }

    return friends;
  }
}
