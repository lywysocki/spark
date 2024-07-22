import 'package:flutter/material.dart';
import 'package:spark/friends/friendship_repository.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/habits/habit.dart';

//friendships:   user1_id, user2_id
class FriendshipController extends ChangeNotifier {
  FriendshipController({required this.currentUserId}) {
    if (currentUserId.isNotEmpty) {
      // TODO: this isn't awaited so its not showing up immediately
      _load();
    }
  }

  final String currentUserId;
  final FriendshipRepository _friendRepo = FriendshipRepository();

  List<Friend> allFriends = [];
  List<Friend> pendingRequests = [];

  Future<void> _load() async {
    allFriends = await getAllFriends();
    pendingRequests = await getPendingRequests();
  }

  //Create
  Future<void> sendFriendRequest(String username) async {
    final results =
        await _friendRepo.createFriendshipRequest(currentUserId, username);
    if (!results) {
      throw "Could not send friend request.";
    }
  }

  Future<List<Friend>> getPendingRequests() async {
    List<List<dynamic>> allRequestData =
        await _friendRepo.selectPendingRequests(currentUserId);
    //selectFriendsByUser returns a list of friends data in format [id, username, first, last]
    int friendsIdIndex = 0;
    int friendsUsernameIndex = 1;
    int friendsFirstIndex = 2;
    int friendsLastIndex = 3;

    List<Friend> friends = [];

    for (var row in allRequestData) {
      Friend f = Friend(
        userId: row[friendsIdIndex].toString(),
        username: row[friendsUsernameIndex],
        firstName: row[friendsFirstIndex],
        lastName: row[friendsLastIndex],
      );

      friends.add(f);
    }

    return friends;
  }

  Future<List<Friend>> getAllFriends() async {
    final allFriendData = await _friendRepo.selectFriendsByUser(currentUserId);
    //selectFriendsByUser returns a list of friends data in format [id, username, first, last]
    int friendsIdIndex = 0;
    int friendsUsernameIndex = 1;
    int friendsFirstIndex = 2;
    int friendsLastIndex = 3;

    //pull out just the ids, titles, and streaks
    List<Friend> friends = [];

    for (var row in allFriendData) {
      Friend f = Friend(
        userId: row[friendsIdIndex].toString(),
        username: row[friendsUsernameIndex],
        firstName: row[friendsFirstIndex],
        lastName: row[friendsLastIndex],
      );

      final sharedHabitsData = await _friendRepo.selectSharedHabits(
        currentUserId,
        row[friendsIdIndex],
      );
      final List<Habit> sharedHabits = [];

      for (var hrow in sharedHabitsData) {
        Habit h = Habit(
          habitId: hrow[0].toString(),
          userId: currentUserId, //not in query
          title: hrow[1],
          note: hrow[2],
          startDate: hrow[3],
          end: hrow[4],
          frequency: hrow[5],
          reminders: hrow[6],
          msg: hrow[7],
          targetType: hrow[8],
          category: hrow[9],
          quan: hrow[10],
        );
        sharedHabits.add(h);
      }

      f.setSharedHabits(sharedHabits);
      friends.add(f);
    }

    return friends;
  }

  Future<void> acceptRequest(String otherUser) async {
    String state = 'established';
    await _friendRepo.updateFriendshipState(otherUser, currentUserId, state);
    allFriends = await getAllFriends();
  }

  Future<void> rejectRequest(String otherUser) async {
    await _friendRepo.deleteFriendships(otherUser, currentUserId);
    pendingRequests = await getPendingRequests();
  }
}
