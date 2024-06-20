/* TABLE FIELDS
users:    user_id, username, password, email, first_name, last_name
goals:    goal_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
friendships:   user1_id, user2_id
achievements:    achievement_id, user_id, goal_id, achievement_type, achievement_description, date, timestamp, quantity
 */


import 'dart:ffi';
import 'package:flutter/cupertino.dart';
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
Future<bool> createUser(String username, String password, String email, String? first, String? last) async {
  try {
    await databaseConnection.open();
    var result = await databaseConnection.query(
        'INSERT INTO users(username, password, email, first_name, last_name) VALUES (@username, @password, @email, @firstname, @lastname)',
        substitutionValues: {
          'username': username,
          'password': password,
          'email': email,
          'firstname': first,
          'lastname': last
        }
    );
    print(result);
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  } finally {
    await databaseConnection.close();
  }
}

Future<bool> createFriendship(String user1, String user2) async {
  try {
    await databaseConnection.open();
    var result = await databaseConnection.query(
        'INSERT INTO friendships (user1_id, user2_id) VALUES (@user1, @user2)',
        substitutionValues: {
          'user1': user1,
          'user2': user2
        }
    );
    print(result);
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  } finally {
    await databaseConnection.close();
  }
}

Future<bool> createGoal(String userID, String title, String note, DateTime start, DateTime end, String frequency, bool reminders, String? reminderMessage, String targetType, String category, int? quantity) async {
  try {
    await databaseConnection.open();
    var results = await databaseConnection.query(
      'INSERT INTO goals (user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity) '
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
        'quantity': quantity
      }
    );
    print(results);
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  } finally {
    databaseConnection.close();
  }
}

Future<bool> createAchievement(String userID, String goal_id, String achievementType, String achievementDescription, int? quantity) async {
  try {
    await databaseConnection.open();
    DateTime now = DateTime.now(); //system date and timestamp
    var results = await databaseConnection.query(
        'INSERT INTO goals (user_id, goal_id, achievement_type, achievement_description, date, timestamp, quantity) '
        'VALUES (@user_id, @goal_id, @achievement_type, @achievement_description, @date, @timestamp, @quantity)',
        substitutionValues: {
          'user_id': userID,
          'goal_id': goal_id,
          'achievement_type': achievementType,
          'achievement_description': achievementDescription,
          'date': DateFormat('yyyy-MM-dd').format(now),
          'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss').format(now),
          'quantity': quantity
        }
    );
    print(results);
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  } finally {
    databaseConnection.close();
  }
}

//SELECT Functions
// Users
Future<List<List<dynamic>>> selectUsersByUsername(String username) async{
  databaseConnection.open();
  List<List<dynamic>> results = await databaseConnection.query(
    'SELECT * FROM users WHERE username = @name',
    substitutionValues: {
      'name': username
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectUsersByEmail(var databaseConnection, String email) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM users WHERE email = @email',
    substitutionValues: {
      'email': email
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectUsersByName(var databaseConnection, String first, String last) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM users WHERE first_name = @firstname AND last_name = @lastname',
    substitutionValues: {
      'firstname': first,
      'lastname': last
    }
  );
  return results;
}

// Friendships
Future<List<List<dynamic>>> selectFriendsByUser(var databaseConnection, String userID) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT user2_id FROM users WHERE user1_id = @id',
    substitutionValues: {
      'id': userID
    }
  );
  List<List<dynamic>> results2 = databaseConnection.query(
    'SELECT user1_id FROM users WHERE user2_id = @id',
    substitutionValues: {
      'id': userID
    }
  );

  results.addAll(results2);
  return results;
}

// Goals
Future<List<List<dynamic>>> selectGoalsByUserID(var databaseConnection, String id) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM goals WHERE user_id = @userID',
    substitutionValues: {
      'userID': id
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectGoalsByTitle(var databaseConnection, String id, String title) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM goals WHERE user_id = @userID and title = @title',
    substitutionValues: {
      'userID': id,
      'title': title
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectGoalsStarted(var databaseConnection, String id, DateTime date) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM goals WHERE user_id = @userID and start_date <= @date '
        'and (end_date is NULL or end_date >= @date)',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectGoalsEnded(var databaseConnection, String id, DateTime date) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM goals WHERE user_id = @userID and end_date < @date',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectGoalsByCategory(var databaseConnection, String id, String cat) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM goals WHERE user_id = @userID and category = @category',
    substitutionValues: {
      'userID': id,
      'category': cat
    }
  );
  return results;
}

// Achievements
Future<List<List<dynamic>>> selectAchievements(var databaseConnection, String id) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM achievements WHERE user_id = @userID',
    substitutionValues: {
      'userID': id
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectAchievementsByGoalID(var databaseConnection, String id, String goal) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and goal_id = @goalID',
    substitutionValues: {
      'userID': id,
      'goalID': goal
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectAchievementsByType(var databaseConnection, String id, String type) async{
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and achievement_type = @achievementType',
    substitutionValues: {
      'userID': id,
      'achievementType': type
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectAchievementsByDate(var databaseConnection, String id, DateTime date) async {
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and date = @date',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

Future<List<List<dynamic>>> selectAchievementsWithinDateRange(var databaseConnection, String id, DateTime start, DateTime end) async {
  databaseConnection.open();
  List<List<dynamic>> results = databaseConnection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and date >= @startDate and date <= @endDate',
    substitutionValues: {
      'userID': id,
      'startDate': start,
      'endDate': end
    }
  );
  return results;
}

//UPDATE functions
Future<bool> updateUserUsername(var databaseConnection, String userID, String newUsername) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET username = @username WHERE user_id = @id',
      substitutionValues: {
        'id': userID,
        'username': newUsername
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateUserFirstName(var databaseConnection, String userID, String newName) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET first_name = @firstName WHERE user_id = @id',
      substitutionValues: {
        'id': userID,
        'firstName': newName
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateUserLastName(var databaseConnection, String userID, String newName) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET last_name = @lastName WHERE user_id = @id',
      substitutionValues: {
        'id': userID,
        'lastName': newName
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateUserPassword(var databaseConnection, String userID, String newPassword) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET password = @password WHERE user_id = @id',
      substitutionValues: {
        'id': userID,
        'password': newPassword
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateUserEmail(var databaseConnection, String userID, String newEmail) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE users SET email = @email WHERE user_id = @id',
      substitutionValues: {
        'id': userID,
        'email': newEmail
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalTitle(var databaseConnection, String goalID, String newTitle) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET title = @title WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'title': newTitle
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalNote(var databaseConnection, String goalID, String newNote) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET note = @note WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'note': newNote
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalEnd(var databaseConnection, String goalID, DateTime newEnd) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET end_date = @end WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'end': newEnd
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalFrequency(var databaseConnection, String goalID, String newFrequency) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET frequency = @frequency WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'frequency': newFrequency
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalReminders(var databaseConnection, String goalID, bool newReminder) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET reminders = @reminder WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'reminder': newReminder
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalReminderMessage(var databaseConnection, String goalID, String newMessage) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET reminder_message = @message WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'message': newMessage
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalTargetType(var databaseConnection, String goalID, String newType) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET target_type = @type WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'type': newType
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalCategory(var databaseConnection, String goalID, String newCategory) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET category = @category WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'category': newCategory
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> updateGoalQuantity(var databaseConnection, String goalID, String newQuantity) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'UPDATE goals SET quantity = @quantity WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID,
        'quantity': newQuantity
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> deleteUser(var databaseConnection, String username) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'DELETE FROM users WHERE username = @username',
      substitutionValues: {
        'username': username
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> deleteGoalAndAchievements(var databaseConnection, String goalID) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'DELETE FROM goals WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID
      }
    );
    await databaseConnection.query(
      'DELETE FROM achievements WHERE goal_id = @id',
      substitutionValues: {
        'id': goalID
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

Future<bool> deleteFriendships(var databaseConnection, String userID1, String userID2) async {
  try {
    await databaseConnection.open();
    await databaseConnection.query(
      'DELETE FROM friendships WHERE (user1_id = @id1 and user2_id = @id2) '
      'or (user2_id = @id1 and user1_id = @id2)',
      substitutionValues: {
        'id1': userID1,
        'id2': userID2
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}


