import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class FriendshipRepository extends ChangeNotifier {
  FriendshipRepository();

  final databaseConnection = PostgreSQLConnection(
    '192.168.56.1', // host // 192.168.56.1 (Jill's IP address) // localhost
    5432, // port
    'spark', // database name
    username: 'postgres', // username
    password: 'get\$park3d!', // password
  );

  ///// Create
  Future<bool> createFriendship(String user1, String user2) async {
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'INSERT INTO friendships (user1_id, user2_id) VALUES (@user1, @user2)',
        substitutionValues: {
          'user1': user1,
          'user2': user2,
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
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        '''SELECT 
          friendships.user2_id,
          users.username,
          users.first_name,
          users.last_name
        FROM friendships
        JOIN users on friendships.user2_id = users.user_id
        WHERE user1_id = @id ''',
        substitutionValues: {
          'id': userID,
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
        WHERE user2_id = @id''',
        substitutionValues: {
          'id': userID,
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

  Future<List<List<dynamic>>> selectSharedHabits(
    String userId1,
    userId2,
  ) async {
    try {
      databaseConnection.open();

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

  /////Delete
  Future<bool> deleteFriendships(String userID1, String userID2) async {
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
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      await databaseConnection.close();
    }
  }
}
