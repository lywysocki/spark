import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class AchievementsRepository extends ChangeNotifier {
  AchievementsRepository();

  final databaseConnection = PostgreSQLConnection(
    '192.168.56.1', // host // 192.168.56.1 (Jill's IP address) // localhost
    5432, // port
    'spark', // database name
    username: 'my_flutter_user', // username
    password: 'jyjsuX-2puzka', // password
  );

  ////// Create
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
        'INSERT INTO achievements (user_id, habit_id, achievement_type, achievement_description, timestamp, quantity) '
        'VALUES (@user_id, @habit_id, @achievement_title, @timestamp, @quantity)',
        substitutionValues: {
          'user_id': userID,
          'habit_id': habitID,
          'achievement_type': achievementTitle,
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

  ////// Select
  Future<List<List<dynamic>>> selectAchievements(String userId) async {
    try {
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM achievements WHERE user_id = @userID',
        substitutionValues: {
          'userID': userId,
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
    String userId,
    String habitId,
  ) async {
    try {
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM achievements WHERE user_id = @userID and habit_id = @habitID',
        substitutionValues: {
          'userID': userId,
          'habitID': habitId,
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
    String userId,
    String type,
  ) async {
    try {
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM achievements WHERE user_id = @userID and achievement_title = @achievementType',
        substitutionValues: {
          'userID': userId,
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
    String userId,
    DateTime date,
  ) async {
    try {
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM achievements WHERE user_id = @userID and date = @date',
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

  Future<List<List<dynamic>>> selectAchievementsWithinDateRange(
    String userID,
    DateTime start,
    DateTime end,
  ) async {
    try {
      await databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM achievements WHERE user_id = @userID and date >= @startDate and date <= @endDate',
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

  ////// Delete
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
}
