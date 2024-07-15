import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class FriendshipRepository extends ChangeNotifier {
  FriendshipRepository();

  final databaseConnection = PostgreSQLConnection(
    '192.168.56.1', // host // 192.168.56.1 (Jill's IP address) // localhost
    5432, // port
    'spark', // database name
    username: 'my_flutter_user', // username
    password: 'jyjsuX-2puzka', // password
  );

  ///// Create
  Future<bool> createFriendshipRequest(String user1, String user2) async {
    try {
      await databaseConnection.open();
      String requestState = 'pending';
      await databaseConnection.query(
        'INSERT INTO friendships (user1_id, user2_id, state) VALUES (@user1, @user2, @state)',
        substitutionValues: {
          'user1': user1,
          'user2': user2,
          'state': requestState,
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      await databaseConnection.close();
    }
  }

  Future<bool> createFriendshipEstablished(String user1, String user2) async {
    try {
      await databaseConnection.open();
      String establishedState = 'established';
      await databaseConnection.query(
        'INSERT INTO friendships (user1_id, user2_id, state) VALUES (@user1, @user2, @state)',
        substitutionValues: {
          'user1': user1,
          'user2': user2,
          'state': establishedState,
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      await databaseConnection.close();
    }
  }

  ///// Select
  Future<List<List<dynamic>>> selectFriendsByUser(String userID) async {
    try {
      String state = 'established';
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        '''SELECT 
          friendships.user2_id,
          users.username,
          users.first_name,
          users.last_name
        FROM friendships
        JOIN users on friendships.user2_id = users.user_id
        WHERE user1_id = @id AND state = @state''',
        substitutionValues: {
          'id': userID,
          'state': state,
        },
      );
      List<List<dynamic>> results2 = await databaseConnection.query(
        '''SELECT
          friendships.user1_id,
          users.username,
          users.first_name,
          users.last_name 
        FROM friendships 
        JOIN users on friendships.user1_id = users.user_id
        WHERE user2_id = @id AND state = @state''',
        substitutionValues: {
          'id': userID,
          'state': state,
        },
      );

      results.addAll(results2);
      return results;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<List<List<dynamic>>> selectPendingRequests(String userID) async {
    try {
      String state = 'pending';
      await databaseConnection.open();
      //when a request is sent, user1_id is the sender and user2_id is the reciever
      //so must filter for user2_id for pending requests in inbox
      List<List<dynamic>> results = await databaseConnection.query(
        '''SELECT 
          friendships.user1_id,
          users.username,
          users.first_name,
          users.last_name
        FROM friendships
        JOIN users on friendships.user1_id = users.user_id
        WHERE user2_id = @id AND state = @state''',
        substitutionValues: {
          'id': userID,
          'state': state,
        },
      );

      return results;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<List<List<dynamic>>> selectSharedHabits(
    String userId1,
    userId2,
  ) async {
    try {
      await databaseConnection.open();

      const query = '''
      SELECT
        h1.habit_id,
        h1.title,
        h1.note,
        h1.start_date,
        h1.end_date,
        h1.frequency,
        h1.reminders,
        h1.reminder_message,
        h1.target_type,
        h1.category,
        h1.quantity,
      FROM habits as h1
      JOIN habits as h2
        on h1.habit_id = h2.habit_id
      WHERE (h1.user_id = @user1 and h2.user_id = @user2)
        or (h1.user_id = @user2 and h2.user_id = @user1)
    ''';
      List<List<dynamic>> results = await databaseConnection.query(
        query,
        substitutionValues: {
          'user1': userId1,
          'user2': userId2,
        },
      );
      return results;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<void> updateFriendshipState(
    String userID1,
    String userID2,
    String state,
  ) async {
    try {
      await databaseConnection.open();

      String query = '''
        UPDATE friendships SET state = @newState 
        WHERE (user1_id = @userId1 AND user2_id = @userId2 )
        OR (user1_id = @userId2 AND user2_id = @userId1 )
      ''';
      await databaseConnection.query(
        query,
        substitutionValues: {
          'userId1': userID1,
          'userId2': userID2,
          'newState': state,
        },
      );
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      throw 'Could not update';
    } finally {
      await databaseConnection.close();
    }
  }

  /////Delete
  Future<void> deleteFriendships(String userID1, String userID2) async {
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'DELETE FROM friendships WHERE (user1_id = @id1 and user2_id = @id2) '
        'or (user2_id = @id1 and user1_id = @id2)',
        substitutionValues: {
          'id1': userID1,
          'id2': userID2,
        },
      );
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      throw 'Could not delete friendship';
    } finally {
      await databaseConnection.close();
    }
  }
}
