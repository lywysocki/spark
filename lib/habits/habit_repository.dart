import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class HabitRepository extends ChangeNotifier {
  HabitRepository();

  final databaseConnection = PostgreSQLConnection(
    '192.168.56.1', // host // 192.168.56.1 (Jill's IP address) // localhost
    5432, // port
    'spark', // database name
    username: 'postgres', // username
    password: 'get\$park3d!', // password
  );

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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'INSERT INTO habits (user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity) '
        'VALUES (@user_id, @title, @note, @start_date, @end_date, @frequency, @reminders, @reminder_message, @target_type, @category, @quantity)',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'INSERT INTO habits (habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity) '
        'VALUES (@habit_id @user_id, @title, @note, @start_date, @end_date, @frequency, @reminders, @reminder_message, @target_type, @category, @quantity)',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      DateTime now = DateTime.now(); //system date and timestamp
      await databaseConnection.query(
        'INSERT INTO activities (user_id, habit_id, timestamp, quantity) '
        'VALUES (@user_id, @habit_id, @timestamp, @quantity)',
        substitutionValues: {
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
    try {
      databaseConnection.open();
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
      List<List<dynamic>> results = await databaseConnection.query(
        query,
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM habits WHERE user_id = @userID and title = @title',
        substitutionValues: {
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
    try {
      databaseConnection.open();
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

      List<List<dynamic>> results = await databaseConnection.query(
        query,
        substitutionValues: {
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

  Future<List<List<dynamic>>> selectHabitsStarted(
    String userId,
    DateTime date,
  ) async {
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM habits WHERE user_id = @userID and start_date <= @date '
        'and (end_date is NULL or end_date >= @date)',
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM habits WHERE user_id = @userID and end_date < @date',
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM habits WHERE user_id = @userID and category = @category',
        substitutionValues: {
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

  Future<List<List<dynamic>>> selectHabitByID(
    String userID,
    String habitID,
  ) async {
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM habits WHERE user_id = @user AND habit_id = @habit',
        substitutionValues: {
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

  Future<List<List<dynamic>>> selectHabitStreaks(String userId) async {
    try {
      await databaseConnection.open();

      const query = '''
      WITH ranked_activities AS (
          SELECT
              a.habit_id,
              a.user_id,
              h.title,
              a.timestamp,
              ROW_NUMBER() OVER (PARTITION BY a.habit_id, a.user_id ORDER BY a.timestamp) AS seq
          FROM
              activities a
          JOIN
              habits h ON a.habit_id = h.habit_id AND a.user_id = h.user_id
          WHERE
              a.user_id = your_user_id
      ),
      date_diffs AS (
          SELECT
              habit_id,
              user_id,
              title,
              timestamp,
              seq,
              timestamp - INTERVAL '1 day' * (seq - 1) AS date_group
          FROM
              ranked_activities
      ),
      sequential_dates AS (
          SELECT
              habit_id,
              user_id,
              title,
              MAX(timestamp) AS most_recent_date,
              COUNT(DISTINCT date_group) AS sequential_date_count
          FROM
              date_diffs
          GROUP BY
              habit_id, user_id, title
      )
      SELECT
          habit_id,
          user_id,
          title,
          sequential_date_count
      FROM
          sequential_dates
      WHERE
          most_recent_date >= CURRENT_DATE - INTERVAL '1 day'
      ORDER BY
          habit_id,
          user_id;
    ''';

      List<List<dynamic>> results = await databaseConnection
          .query(query, substitutionValues: {'user_id': userId});

      return results;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return List.empty();
    } finally {
      await databaseConnection.close();
    }
  }

  Future<List<List<dynamic>>> selectActivities(String userID) async {
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM activities WHERE user_id = @userID',
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM activities WHERE user_id = @userID and habit_id = @habitID',
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM activities WHERE user_id = @userID and date = @date',
        substitutionValues: {
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
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM activities WHERE user_id = @userID and date >= @startDate and date <= @endDate',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET title = @title WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET note = @note WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET end_date = @end WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET frequency = @frequency WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET reminders = @reminder WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET reminder_message = @message WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET target_type = @type WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET category = @category WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'UPDATE habits SET quantity = @quantity WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'DELETE FROM habits WHERE habit_id = @id',
        substitutionValues: {
          'id': habitID,
        },
      );
      await databaseConnection.query(
        'DELETE FROM activities WHERE habit_id = @id',
        substitutionValues: {
          'id': habitID,
        },
      );
      await databaseConnection.query(
        'DELETE FROM achievements WHERE habit_id = @id',
        substitutionValues: {
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
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'DELETE FROM activities WHERE activity_id = @id',
        substitutionValues: {
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
