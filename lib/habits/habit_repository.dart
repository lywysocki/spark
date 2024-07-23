import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class HabitRepository extends ChangeNotifier {
  HabitRepository();

  /////Insert
  Future<bool> createHabit(
    String userID,
    String title,
    String note,
    DateTime start,
    DateTime? end,
    String frequency,
    bool reminders,
    String? reminderMessage,
    String targetType,
    String category,
    int? quantity,
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
            'INSERT INTO habits (user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity) '
            'VALUES (@user_id, @title, @note, @start_date, @end_date, @frequency, @reminders, @reminder_message, @target_type, @category, @quantity)'),
        parameters: {
          'user_id': userID,
          'title': title,
          'note': note,
          'start_date': start,
          'end_date': end,
          'frequency': frequency,
          'reminders': reminders,
          'reminder_message': reminderMessage,
          'target_type': targetType,
          'category': category,
          'quantity': quantity,
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      databaseConnection.close();
    }
  }

  Future<bool> createSharedHabit(
    String habitID,
    String userID,
    String title,
    String note,
    DateTime start,
    DateTime? end,
    String frequency,
    bool reminders,
    String? reminderMessage,
    String targetType,
    String category,
    int? quantity,
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
            'INSERT INTO habits (habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity) '
            'VALUES (@habit_id @user_id, @title, @note, @start_date, @end_date, @frequency, @reminders, @reminder_message, @target_type, @category, @quantity)'),
        parameters: {
          'habit_id': habitID,
          'user_id': userID,
          'title': title,
          'note': note,
          'start_date': start,
          'end_date': end,
          'frequency': frequency,
          'reminders': reminders,
          'reminder_message': reminderMessage,
          'target_type': targetType,
          'category': category,
          'quantity': quantity,
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      databaseConnection.close();
    }
  }

  Future<bool> createActivity(
    String userID,
    String habitID,
    int? quantity,
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
      DateTime now = DateTime.now(); //system date and timestamp
      await databaseConnection.execute(
        Sql.named(
            'INSERT INTO activities (user_id, habit_id, timestamp, quantity) '
            'VALUES (@user_id, @habit_id, @timestamp, @quantity)'),
        parameters: {
          'user_id': userID,
          'habit_id': habitID,
          'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss').format(now),
          'quantity': quantity,
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return false;
    } finally {
      databaseConnection.close();
    }
  }

  ///// Select
  Future<List<List<dynamic>>> selectHabitsByUserID(String userId) async {
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
          MAX(timestamp) AS most_recent_date,
          COUNT(DISTINCT date_group) AS sequential_date_count
        FROM
          date_diffs
        GROUP BY
          habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
      )
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
        sequential_date_count
      FROM
        sequential_dates
      WHERE
        most_recent_date >= 
        CASE
          WHEN frequency = 'daily' THEN CURRENT_DATE - INTERVAL '1 day'
          WHEN frequency = 'weekly' THEN CURRENT_DATE - INTERVAL '1 week'
          WHEN frequency = 'biweekly' THEN CURRENT_DATE - INTERVAL '2 weeks'
          WHEN frequency = 'monthly' THEN CURRENT_DATE - INTERVAL '1 month'
          ELSE CURRENT_DATE - INTERVAL '1 day' -- default to daily
        END
      ORDER BY
        habit_id,
        user_id;
    ''';
      List<List<dynamic>> results = await databaseConnection.execute(
        Sql.named(query),
        parameters: {
          'userId': userId,
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

  Future<List<List<dynamic>>> selectHabitsByTitle(
    String userId,
    String title,
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
          'SELECT * FROM habits WHERE user_id = @userID and title = @title',
        ),
        parameters: {
          'userID': userId,
          'title': title,
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

  Future<List<List<dynamic>>> selectHabitsByDate(
    String userId,
    DateTime date,
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
          MAX(timestamp) AS most_recent_activity,
          COUNT(DISTINCT date_group) AS sequential_date_count
        FROM
          date_diffs
        GROUP BY
          habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
      ),
      due_habits AS (
        SELECT
          sequential_dates.*,
          CASE
            WHEN frequency = 'daily' THEN most_recent_activity + INTERVAL '1 day'
            WHEN frequency = 'weekly' THEN most_recent_activity + INTERVAL '1 week'
            WHEN frequency = 'biweekly' THEN most_recent_activity + INTERVAL '2 weeks'
            WHEN frequency = 'monthly' THEN most_recent_activity + INTERVAL '1 month'
            ELSE most_recent_activity + INTERVAL '1 day' -- default to daily
          END AS next_due_date
        FROM sequential_dates
        LEFT JOIN
          latest_activities la ON h.habit_id = la.habit_id AND h.user_id = la.user_id
      )
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
        sequential_date_count,
        next_due_date
      FROM
        due_habits
      WHERE
        next_due_date = @date
        OR (next_due_date IS NULL AND h.start_date <= CURRENT_DATE)
      ORDER BY
        habit_id,
        user_id;
    ''';

      List<List<dynamic>> results = await databaseConnection.execute(
        Sql.named(query),
        parameters: {
          'userId': userId,
          'date': date,
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

  Future<List<List<dynamic>>> selectHabitsStarted(
    String userId,
    DateTime date,
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
            'SELECT * FROM habits WHERE user_id = @userID and start_date <= @date '
            'and (end_date is NULL or end_date >= @date)'),
        parameters: {
          'userID': userId,
          'date': date,
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

  Future<List<List<dynamic>>> selectHabitsEnded(
    String userId,
    DateTime date,
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
          'SELECT * FROM habits WHERE user_id = @userID and end_date < @date',
        ),
        parameters: {
          'userID': userId,
          'date': date,
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

  Future<List<List<dynamic>>> selectHabitsByCategory(
    String userId,
    String cat,
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
          'SELECT * FROM habits WHERE user_id = @userID and category = @category',
        ),
        parameters: {
          'userID': userId,
          'category': cat,
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
        h1.quantity,
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

  Future<List<List<dynamic>>> selectHabitByID(
    String userID,
    String habitID,
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
          'SELECT * FROM habits WHERE user_id = @user AND habit_id = @habit',
        ),
        parameters: {
          'user': userID,
          'habit': habitID,
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

  Future<List<List<dynamic>>> selectActivities(String userID) async {
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
        Sql.named('SELECT * FROM activities WHERE user_id = @userID'),
        parameters: {
          'userID': userID,
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

  Future<List<List<dynamic>>> selectActivitiesByHabitID(
    String userID,
    String habit,
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
          'SELECT * FROM activities WHERE user_id = @userID and habit_id = @habitID',
        ),
        parameters: {
          'userID': userID,
          'habitID': habit,
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

  Future<List<List<dynamic>>> selectActivitiesByDate(
    String userID,
    DateTime date,
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
          'SELECT * FROM activities WHERE user_id = @userID and date = @date',
        ),
        parameters: {
          'userID': userID,
          'date': date,
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

  Future<List<List<dynamic>>> selectActivitiesWithinDateRange(
    String userID,
    DateTime start,
    DateTime end,
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
          'SELECT * FROM activities WHERE user_id = @userID and date >= @startDate and date <= @endDate',
        ),
        parameters: {
          'userID': userID,
          'startDate': start,
          'endDate': end,
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
  Future<bool> updateHabitTitle(String habitID, String newTitle) async {
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
        Sql.named('UPDATE habits SET title = @title WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
          'title': newTitle,
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

  Future<bool> updateHabitNote(String habitID, String newNote) async {
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
        Sql.named('UPDATE habits SET note = @note WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
          'note': newNote,
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

  Future<bool> updateHabitEnd(String habitID, DateTime newEnd) async {
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
        Sql.named('UPDATE habits SET end_date = @end WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
          'end': newEnd,
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

  Future<bool> updateHabitFrequency(String habitID, String newFrequency) async {
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
          'UPDATE habits SET frequency = @frequency WHERE habit_id = @id',
        ),
        parameters: {
          'id': habitID,
          'frequency': newFrequency,
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

  Future<bool> updateHabitReminders(String habitID, bool newReminder) async {
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
          'UPDATE habits SET reminders = @reminder WHERE habit_id = @id',
        ),
        parameters: {
          'id': habitID,
          'reminder': newReminder,
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

  Future<bool> updateHabitReminderMessage(
    String habitID,
    String newMessage,
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
          'UPDATE habits SET reminder_message = @message WHERE habit_id = @id',
        ),
        parameters: {
          'id': habitID,
          'message': newMessage,
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

  Future<bool> updateHabitTargetType(String habitID, String newType) async {
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
        Sql.named('UPDATE habits SET target_type = @type WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
          'type': newType,
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

  Future<bool> updateHabitCategory(String habitID, String newCategory) async {
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
          'UPDATE habits SET category = @category WHERE habit_id = @id',
        ),
        parameters: {
          'id': habitID,
          'category': newCategory,
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

  Future<bool> updateHabitQuantity(String habitID, String newQuantity) async {
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
          'UPDATE habits SET quantity = @quantity WHERE habit_id = @id',
        ),
        parameters: {
          'id': habitID,
          'quantity': newQuantity,
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

  Future<bool> deleteHabitCascade(String habitID) async {
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
        Sql.named('DELETE FROM habits WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
        },
      );
      await databaseConnection.execute(
        Sql.named('DELETE FROM activities WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
        },
      );
      await databaseConnection.execute(
        Sql.named('DELETE FROM achievements WHERE habit_id = @id'),
        parameters: {
          'id': habitID,
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

  Future<bool> deleteActivity(String activityID) async {
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
        Sql.named('DELETE FROM activities WHERE activity_id = @id'),
        parameters: {
          'id': activityID,
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
