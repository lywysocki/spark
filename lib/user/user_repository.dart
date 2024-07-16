import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class UserRepository extends ChangeNotifier {
  UserRepository();

  ////// Create
  Future<bool> createUser(
    String? username,
    String? password,
    String? email,
    String? first,
    String? last,
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
      await databaseConnection.execute(
        Sql.named(
          'INSERT INTO users(username, password, email, first_name, last_name) VALUES (@username, @password, @email, @firstname, @lastname)',
        ),
        parameters: {
          'username': username,
          'password': password,
          'email': email,
          'firstname': first,
          'lastname': last,
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
      List<List<dynamic>> results = await databaseConnection.execute(
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
      List<List<dynamic>> results = await databaseConnection.execute(
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
      List<List<dynamic>> results = await databaseConnection.execute(
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
      WITH ranked_activities AS (
        SELECT
          h.*,
          a.timestamp,
          ROW_NUMBER() OVER (PARTITION BY a.habit_id, a.user_id ORDER BY a.timestamp) AS seq
        FROM
          activities a
        JOIN
          habits h ON a.habit_id = h.habit_id AND a.user_id = h.user_id
        WHERE
          a.user_id = @userId
      ),
      date_diffs AS (
        SELECT
          *,
          CASE
            WHEN frequency = 'daily' THEN timestamp - INTERVAL '1 day' * (seq - 1)
            WHEN frequency = 'weekly' THEN timestamp - INTERVAL '1 week' * (seq - 1)
            WHEN frequency = 'biweekly' THEN timestamp - INTERVAL '2 weeks' * (seq - 1)
            WHEN frequency = 'monthly' THEN timestamp - INTERVAL '1 month' * (seq - 1)
            ELSE timestamp -- default to daily if frequency is not recognized
          END AS date_group
        FROM
          ranked_activities
      ),
      sequential_dates AS (
        SELECT
          habit_id,
          user_id,
          title,
          note,
          start_date,
          end_date,
          frequency,
          reminders,
          reminder_message,
          target_type,
          category,
          quantity,
          COUNT(DISTINCT date_group) AS sequential_date_count
        FROM
          date_diffs
        GROUP BY
          habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
      ),
      SELECT
        habit_id,
        sequential_date_count
      FROM
        sequential_dates
      ORDER BY
        habit_id
    ''';

      List<List<dynamic>> results = await databaseConnection
          .execute(Sql.named(query), parameters: {'user_id': userId});

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
      List<List<dynamic>> results = await databaseConnection.execute(
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
      List<List<dynamic>> results = await databaseConnection.execute(
        Sql.named(
          'SELECT user_id FROM users WHERE (username = @username OR email = @email) AND password = @password',
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
        Sql.named('UPDATE users SET password = @password WHERE user_id = @id'),
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
