import 'package:flutter/material.dart';
import 'package:spark/friends/friendship_repository.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/habits/habit.dart';

//friendships:   user1_id, user2_id
class FriendshipController extends ChangeNotifier {
  FriendshipController({required this.currentUserId}) {
    _load();
  }

  final String currentUserId;
  final FriendshipRepository _friendshipRepo = FriendshipRepository();

  List<Friend> allFriends = [];
  List<Friend> todaysHabits = [];
  List<Friend> tomorrowsHabits = [];

  Future<void> _load() async {
    allFriends = await getAllFriends();
  }

//Friends List View
  Future<List<Friend>> getAllFriends() async {
    List<List<dynamic>> allFriendData =
        await _friendshipRepo.selectFriendsByUser(currentUserId);
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

      List<List<dynamic>> sharedHabitsData = await _friendshipRepo
          .selectSharedHabits(currentUserId, row[friendsIdIndex]);
      List<Habit> sharedHabits = [];

      for (var hrow in sharedHabitsData) {
        Habit h = Habit(
          habitId: hrow[0],
          userId: hrow[1],
          title: hrow[2],
          note: hrow[3],
          startDate: hrow[4],
          end: hrow[5],
          frequency: hrow[6],
          reminders: hrow[7],
          msg: hrow[8],
          targetType: hrow[9],
          category: hrow[10],
          quan: hrow[11],
          streak: hrow[12],
        );
        sharedHabits.add(h);
      }

      f.setSharedHabits(sharedHabits);
      friends.add(f);
    }

    return friends;
  }
}
