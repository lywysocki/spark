import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class FriendshipRepository extends ChangeNotifier {
  FriendshipRepository();

  ///// Create
  Future<bool> createFriendshipRequest(String userid1, String username2) async {
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      String requestState = 'pending';
      List<List<dynamic>> idResult = await databaseConnection.execute(
        Sql.named('select user_id from users where username = @username'),
        parameters: {'username': username2},
      );
      if (idResult.length > 1) {
        debugPrint('Error: Duplicate usernames');
        return false;
      }
      int friendID = idResult[0][0];
      await databaseConnection.execute(
        Sql.named(
          'INSERT INTO friendships (user1_id, user2_id, state) VALUES (@user1, @user2, @state)',
        ),
        parameters: {
          'user1': userid1,
          'user2': friendID,
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
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      String establishedState = 'established';
      await databaseConnection.execute(
        Sql.named(
          'INSERT INTO friendships (user1_id, user2_id, state) VALUES (@user1, @user2, @state)',
        ),
        parameters: {
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
  Future<List<dynamic>> selectFriendsByUser(String userID) async {
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      String state = 'established';
      final results = await databaseConnection.execute(
        Sql.named('''SELECT 
          friendships.user2_id,
          users.username,
          users.first_name,
          users.last_name
        FROM friendships
        JOIN users on friendships.user2_id = users.user_id
        WHERE user1_id = @id AND state = @state'''),
        parameters: {
          'id': userID,
          'state': state,
        },
      );
      final results2 = await databaseConnection.execute(
        Sql.named('''SELECT
          friendships.user1_id,
          users.username,
          users.first_name,
          users.last_name 
        FROM friendships 
        JOIN users on friendships.user1_id = users.user_id
        WHERE user2_id = @id AND state = @state'''),
        parameters: {
          'id': userID,
          'state': state,
        },
      );

      final allResults = [];
      allResults.addAll(results);
      allResults.addAll(results2);

      return allResults;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<List<List<dynamic>>> selectFriendshipByUsername(
    String userId1,
    String username2,
  ) async {
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      List<List<dynamic>> idResult = await databaseConnection.execute(
        Sql.named('select user_id from users where username = @username'),
        parameters: {'username': username2},
      );
      if (idResult.length > 1) {
        debugPrint('Error: Duplicate usernames');
        return [];
      }
      int friendID = idResult[0][0];

      final results = await databaseConnection.execute(
        Sql.named('''SELECT * FROM friendships
        WHERE (user1_id = @id1 AND user2_id = @id2) OR (user1_id = @id2 AND user2_id = @id1)'''),
        parameters: {
          'id1': userId1,
          'id2': friendID,
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

  Future<List<List<dynamic>>> selectPendingRequests(String userID) async {
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      String state = 'pending';
      //when a request is sent, user1_id is the sender and user2_id is the reciever
      //so must filter for user2_id for pending requests in inbox
      List<List<dynamic>> results = await databaseConnection.execute(
        Sql.named('''SELECT 
          friendships.user1_id,
          users.username,
          users.first_name,
          users.last_name
        FROM friendships
        JOIN users on friendships.user1_id = users.user_id
        WHERE user2_id = @id AND state = @state'''),
        parameters: {
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
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
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
        h1.quantity
      FROM habits as h1
      JOIN habits as h2
        on h1.habit_id = h2.habit_id
      WHERE (h1.user_id = @user1 and h2.user_id = @user2)
        or (h1.user_id = @user2 and h2.user_id = @user1)
    ''';
      List<List<dynamic>> results = await databaseConnection.execute(
        Sql.named(query),
        parameters: {
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
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      String query = '''
        UPDATE friendships SET state = @newState 
        WHERE (user1_id = @userId1 AND user2_id = @userId2 )
        OR (user1_id = @userId2 AND user2_id = @userId1 )
      ''';
      await databaseConnection.execute(
        Sql.named(query),
        parameters: {
          'userId1': userID1,
          'userId2': userID2,
          'newState': state,
        },
      );
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    } finally {
      await databaseConnection.close();
    }
  }

  /////Delete
  Future<void> deleteFriendships(String userID1, String userID2) async {
    final databaseConnection = await Connection.open(
      Endpoint(
        host: 'spark.cn2s64yow311.us-east-1.rds.amazonaws.com', // host
        //port: 5432, // port
        database: 'spark', // database name
        username: 'postgres', // username
        password: 'get\$park3d!', // password
      ),
    );
    try {
      await databaseConnection.execute(
        Sql.named(
            'DELETE FROM friendships WHERE (user1_id = @id1 and user2_id = @id2) '
            'or (user2_id = @id1 and user1_id = @id2)'),
        parameters: {
          'id1': userID1,
          'id2': userID2,
        },
      );
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    } finally {
      await databaseConnection.close();
    }
  }
}
