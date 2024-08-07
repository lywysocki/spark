import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class AchievementsRepository extends ChangeNotifier {
  AchievementsRepository();

  ////// Create
  Future<bool> createAchievement(
    String userID,
    String habitID,
    String achievementTitle,
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
            '''INSERT INTO achievements (user_id, habit_id, achievement_title, timestamp, quantity)
        VALUES (@user_id, @habit_id, @achievement_title, @timestamp, @quantity)'''),
        parameters: {
          'user_id': userID,
          'habit_id': habitID,
          'achievement_title': achievementTitle,
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
        Sql.named('SELECT * FROM achievements WHERE user_id = @userID'),
        parameters: {
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
          'SELECT * FROM achievements WHERE user_id = @userID and habit_id = @habitID',
        ),
        parameters: {
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
          'SELECT * FROM achievements WHERE user_id = @userID and achievement_title = @achievementType',
        ),
        parameters: {
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
          'SELECT * FROM achievements WHERE user_id = @userID and date = @date',
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

  Future<List<List<dynamic>>> selectAchievementsWithinDateRange(
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
          'SELECT * FROM achievements WHERE user_id = @userID and date >= @startDate and date <= @endDate',
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

  ////// Delete
  Future<bool> deleteAchievement(String achievementID) async {
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
        Sql.named('DELETE FROM achievements WHERE achievement_id = @id'),
        parameters: {
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
