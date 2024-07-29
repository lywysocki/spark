import 'package:flutter/material.dart';
import 'package:spark/friends/friendship_repository.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/habits/habit.dart';

//friendships:   user1_id, user2_id
class FriendshipController extends ChangeNotifier {
  FriendshipController();

  final FriendshipRepository _friendRepo = FriendshipRepository();

  List<Friend> allFriends = [];
  List<Friend> pendingRequests = [];

  String _currentUserId = '';

  Future<void> load() async {
    allFriends.clear();
    allFriends = await getAllFriends();

    pendingRequests.clear();
    pendingRequests = await getPendingRequests();

    if (!hasListeners) return;
    notifyListeners();
  }

  Future<void> updateUser(String newUserId) async {
    _currentUserId = newUserId;
    await load();
  }

  //Create
  Future<void> sendFriendRequest(String username) async {
    final exists = await _friendRepo.selectFriendshipByUsername(
      _currentUserId,
      username,
    );
    if (exists.isNotEmpty) {
      throw "This friendship already exists";
    } else {
      final results =
          await _friendRepo.createFriendshipRequest(_currentUserId, username);
      if (!results) {
        throw "Could not send friend request.";
      }
      await load();
    }
  }

  Future<List<Friend>> getPendingRequests() async {
    List<List<dynamic>> allRequestData =
        await _friendRepo.selectPendingRequests(_currentUserId);
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
        fName: row[friendsFirstIndex],
        lName: row[friendsLastIndex],
        isPending: true,
      );

      friends.add(f);
    }

    return friends;
  }

  Future<List<Friend>> getAllFriends() async {
    final allFriendData = await _friendRepo.selectFriendsByUser(_currentUserId);
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
        fName: row[friendsFirstIndex],
        lName: row[friendsLastIndex],
      );

      final sharedHabitsData = await _friendRepo.selectSharedHabits(
        _currentUserId,
        row[friendsIdIndex],
      );
      final List<Habit> sharedHabits = [];

      for (var hrow in sharedHabitsData) {
        Habit h = Habit(
          habitId: hrow[0].toString(),
          userId: _currentUserId, //not in query
          title: hrow[1],
          note: hrow[2],
          startDate: hrow[3],
          endDate: hrow[4],
          frequency: hrow[5],
          reminders: hrow[6],
          reminderMessage: hrow[7],
          targetType: hrow[8],
          category: hrow[9],
          reminderTimes: stringListToTimeOfDayList(hrow[10]),
        );
        sharedHabits.add(h);
      }

      f.setSharedHabits(sharedHabits: sharedHabits);
      friends.add(f);
    }

    return friends;
  }

  Future<void> acceptRequest(String otherUser) async {
    String state = 'established';
    await _friendRepo.updateFriendshipState(otherUser, _currentUserId, state);

    await load();
  }

  Future<void> rejectRequest(String otherUser) async {
    await _friendRepo.deleteFriendships(otherUser, _currentUserId);

    await load();
  }
}

List<TimeOfDay>? stringListToTimeOfDayList(List<String>? sTime) {
  if (sTime == null) {
    return [];
  }
  List<TimeOfDay>? times = [];
  for (var t in sTime) {
    TimeOfDay time = TimeOfDay(
      hour: int.parse(t.split(":")[0]),
      minute: int.parse(t.split(":")[1]),
    );
    times.add(time);
  }
  return times;
}

List<String>? timeOfDayListToStringList(List<TimeOfDay>? times) {
  if (times == null) {
    return [];
  }
  List<String>? strings = [];
  for (var t in times) {
    strings.add(t.toString());
  }
  return strings;
}
