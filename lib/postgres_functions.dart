/* TABLE FIELDS
users:    user_id, username, password, email, first_name, last_name
habits:    habit_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
friendships:   user1_id, user2_id
achievements:    achievement_id, user_id, habit_id, achievement_title, date, timestamp, quantity
activities: user_id, habit_id, timestamp, quanity
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

final databaseConnection = PostgreSQLConnection(
  '192.168.56.1', // host //change to 192.168.56.1 (Jill's IP address)
  5432, // port
  'spark', // database name
  username: 'postgres', // username
  password: 'get\$park3d!', // password
);

//INSERT methods
Future<bool> createUser(
  String? username,
  String? password,
  String? email,
  String? first,
  String? last,
) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'INSERT INTO users(username, password, email, first_name, last_name) VALUES (@username, @password, @email, @firstname, @lastname)',
      substitutionValues: {
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

Future<bool> createAchievement(
  String userID,
  String habitID,
  String achievementTitle,
  int? quantity,
) async {
  try {
    await databaseConnection.open();
    DateTime now = DateTime.now(); //system date and timestamp
    await databaseConnection.query(
      'INSERT INTO achievements (user_id, habit_id, achievement_type, achievement_description, date, timestamp, quantity) '
      'VALUES (@user_id, @habit_id, @achievement_title, @date, @timestamp, @quantity)',
      substitutionValues: {
        'user_id': userID,
        'habit_id': habitID,
        'achievement_type': achievementTitle,
        'date': DateFormat('yyyy-MM-dd').format(now),
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

Future<bool> createActivity(
  String userID,
  String habitID,
  String achievementTitle,
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

//SELECT Functions
// Users
Future<List<List<dynamic>>> selectUsersByUserID(String id) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM users WHERE user_id = @id',
      substitutionValues: {
        'id': id,
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
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM users WHERE username = @name',
      substitutionValues: {
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
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM users WHERE email = @email',
      substitutionValues: {
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

Future<List<List<dynamic>>> selectUsersByName(String first, String last) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM users WHERE first_name = @firstname AND last_name = @lastname',
      substitutionValues: {
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
  String user,
  String password,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT user_id FROM users WHERE (username = @username OR email = @email) AND password = @password',
      substitutionValues: {
        'username': user,
        'email': user,
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

// Friendships
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

// Habit
Future<List<List<dynamic>>> selectHabitsByUserID(String id) async {
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
        'userId': id,
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

Future<List<List<dynamic>>> selectHabitsByTitle(String id, String title) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM habits WHERE user_id = @userID and title = @title',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectHabitsByDate(String id, DateTime date) async {
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
        'userID': id,
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
  String id,
  DateTime date,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM habits WHERE user_id = @userID and start_date <= @date '
      'and (end_date is NULL or end_date >= @date)',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectHabitsEnded(String id, DateTime date) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM habits WHERE user_id = @userID and end_date < @date',
      substitutionValues: {
        'userID': id,
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
  String id,
  String cat,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM habits WHERE user_id = @userID and category = @category',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectSharedHabits(String id1, id2) async {
  try {
    databaseConnection.open();

    const query = '''
      SELECT
        h1.habit_id,
        h1.title
      FROM habits as h1
      JOIN habits as h2
        on h1.habit_id = h2.habit_id
      WHERE (h1.user_id = @user1 and h2.user_id = @user2)
        or (h1.user_id = @user2 and h2.user_id = @user1)
    ''';
    List<List<dynamic>> results = await databaseConnection.query(
      query,
      substitutionValues: {
        'user1': id1,
        'user2': id2,
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

// Achievements
Future<List<List<dynamic>>> selectAchievements(String id) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM achievements WHERE user_id = @userID',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectAchievementsByHabitID(
  String id,
  String habit,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM achievements WHERE user_id = @userID and habit_id = @habitID',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectAchievementsByType(
  String id,
  String type,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM achievements WHERE user_id = @userID and achievement_title = @achievementType',
      substitutionValues: {
        'userID': id,
        'achievementType': type,
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

Future<List<List<dynamic>>> selectAchievementsByDate(
  String id,
  DateTime date,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM achievements WHERE user_id = @userID and date = @date',
      substitutionValues: {
        'userID': id,
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

Future<List<List<dynamic>>> selectAchievementsWithinDateRange(
  String id,
  DateTime start,
  DateTime end,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM achievements WHERE user_id = @userID and date >= @startDate and date <= @endDate',
      substitutionValues: {
        'userID': id,
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

//Activities
Future<List<List<dynamic>>> selectActivities(String id) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM activities WHERE user_id = @userID',
      substitutionValues: {
        'userID': id,
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
  String id,
  String habit,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM activities WHERE user_id = @userID and habit_id = @habitID',
      substitutionValues: {
        'userID': id,
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
  String id,
  DateTime date,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM activities WHERE user_id = @userID and date = @date',
      substitutionValues: {
        'userID': id,
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
  String id,
  DateTime start,
  DateTime end,
) async {
  try {
    databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
      'SELECT * FROM activities WHERE user_id = @userID and date >= @startDate and date <= @endDate',
      substitutionValues: {
        'userID': id,
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

//UPDATE functions
Future<bool> updateUserUsername(String userID, String newUsername) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET username = @username WHERE user_id = @id',
      substitutionValues: {
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
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET first_name = @firstName WHERE user_id = @id',
      substitutionValues: {
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
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET last_name = @lastName WHERE user_id = @id',
      substitutionValues: {
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
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET password = @password WHERE user_id = @id',
      substitutionValues: {
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
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET email = @email WHERE user_id = @id',
      substitutionValues: {
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

//DELETE funcitons
//User
Future<bool> deleteUser(String username) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'DELETE FROM users WHERE username = @username',
      substitutionValues: {
        'username': username,
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

//Habit, associated activities and achievements
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

Future<bool> deleteAchievement(String achievementID) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'DELETE FROM achievements WHERE achievement_id = @id',
      substitutionValues: {
        'id': achievementID,
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
