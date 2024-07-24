import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class UserRepository extends ChangeNotifier {
  UserRepository();

  ////// Create
  Future<bool> createUser({
    String? username,
    String? password,
    String? email,
    String? first,
    String? last,
  }) async {
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
          'INSERT INTO users(username, password, email, role, first_name, last_name, date_joined) VALUES (@username, crypt(@password, gen_salt(\'md5\')), @email, @role, @firstname, @lastname, @dateJoined)',
        ),
        parameters: {
          'username': username,
          'password': password,
          'email': email,
          'role': 'registered',
          'firstname': first,
          'lastname': last,
          'dateJoined': DateFormat('yyyy-MM-dd').format(DateTime.now()),
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

  ////// Select
  Future<List<List<dynamic>>> selectUsersByUserID(String userId) async {
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
      final results = await databaseConnection.execute(
        Sql.named('SELECT * FROM users WHERE user_id = @id'),
        parameters: {
          'id': userId,
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

  Future<List<List<dynamic>>> selectUsersByUsername(String username) async {
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
      final results = await databaseConnection.execute(
        Sql.named('SELECT * FROM users WHERE username = @name'),
        parameters: {
          'name': username,
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

  Future<List<List<dynamic>>> selectUsersByEmail(String email) async {
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
      final results = await databaseConnection.execute(
        Sql.named('SELECT * FROM users WHERE email = @email'),
        parameters: {
          'email': email,
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

  Future<List<List<dynamic>>> selectUsersStreaks(String userId) async {
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
        WITH activity_gaps AS (
          SELECT
            a.activity_id,
            a.user_id,
            a.habit_id,
            a.timestamp,
            h.frequency,
            LAG(a.timestamp) OVER (PARTITION BY a.user_id, a.habit_id ORDER BY a.timestamp) AS prev_timestamp
          FROM activities a
          JOIN habits h ON a.habit_id = h.habit_id
          WHERE h.user_id = @userId
        ),
        consecutive_activities AS (
          SELECT
            activity_id,
            user_id,
            habit_id,
            timestamp,
            frequency,
            prev_timestamp,
            CASE
              WHEN frequency = 'daily' AND prev_timestamp = timestamp - INTERVAL '1 day' THEN 1
              WHEN frequency = 'weekly' AND prev_timestamp = timestamp - INTERVAL '1 week' THEN 1
              WHEN frequency = 'biweekly' AND prev_timestamp = timestamp - INTERVAL '2 weeks' THEN 1
              WHEN frequency = 'monthly' AND prev_timestamp = timestamp - INTERVAL '1 month' THEN 1
              ELSE 0
            END AS is_consecutive
          FROM activity_gaps
        ),
        streaks AS (
          SELECT
            habit_id,
            timestamp,
            is_consecutive
          FROM consecutive_activities
          ORDER BY habit_id, timestamp
        )
        select 
          habit_id,
          sum(is_consecutive) + 1 as streak
        from streaks
        group by habit_id;
      ''';

      final results = await databaseConnection
          .execute(Sql.named(query), parameters: {'userId': userId});

      return results;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<List<List<dynamic>>> selectUsersByName(
    String first,
    String last,
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
      final results = await databaseConnection.execute(
        Sql.named(
          'SELECT * FROM users WHERE first_name = @firstname AND last_name = @lastname',
        ),
        parameters: {
          'firstname': first,
          'lastname': last,
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

  Future<List<List<dynamic>>> selectUsersLogin(
    String userInfo,
    String password,
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
      final results = await databaseConnection.execute(
        Sql.named(
          'SELECT user_id FROM users WHERE (username = @username OR email = @email) AND password = crypt(@password, password)',
        ),
        parameters: {
          'username': userInfo,
          'email': userInfo,
          'password': password,
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

  ///// Update
  Future<bool> updateUserUsername(String userID, String newUsername) async {
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
        Sql.named('UPDATE users SET username = @username WHERE user_id = @id'),
        parameters: {
          'id': userID,
          'username': newUsername,
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

  Future<bool> updateUserFirstName(String userID, String newName) async {
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
          'UPDATE users SET first_name = @firstName WHERE user_id = @id',
        ),
        parameters: {
          'id': userID,
          'firstName': newName,
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

  Future<bool> updateUserLastName(String userID, String newName) async {
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
        Sql.named('UPDATE users SET last_name = @lastName WHERE user_id = @id'),
        parameters: {
          'id': userID,
          'lastName': newName,
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

  Future<bool> updateUserPassword(String userID, String newPassword) async {
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
        //crypt('w3N+worth', gen_salt('md5'))
        Sql.named(
          'UPDATE users SET password = crypt(@password, gen_salt(\'md5\')) WHERE user_id = @id',
        ),
        parameters: {
          'id': userID,
          'password': newPassword,
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

  Future<bool> updateUserEmail(String userID, String newEmail) async {
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
        Sql.named('UPDATE users SET email = @email WHERE user_id = @id'),
        parameters: {
          'id': userID,
          'email': newEmail,
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

  ////// Delete
  Future<bool> deleteUser(String userId) async {
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
        Sql.named('DELETE FROM users WHERE user_id = @userId'),
        parameters: {
          'userId': userId,
        },
      );
      await databaseConnection.execute(
        Sql.named('DELETE FROM habits WHERE user_id = @userId'),
        parameters: {
          'userId': userId,
        },
      );
      await databaseConnection.execute(
        Sql.named('DELETE FROM activities WHERE user_id = @userId'),
        parameters: {
          'userId': userId,
        },
      );
      await databaseConnection.execute(
        Sql.named('DELETE FROM achievements WHERE user_id = @userId'),
        parameters: {
          'userId': userId,
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
