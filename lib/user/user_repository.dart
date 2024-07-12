import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class UserRepository extends ChangeNotifier {
  UserRepository();

  final databaseConnection = PostgreSQLConnection(
    '192.168.56.1', // host // 192.168.56.1 (Jill's IP address) // localhost
    5432, // port
    'spark', // database name
    username: 'postgres', // username
    password: 'get\$park3d!', // password
  );

  ////// Create
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

  ////// Insert
  Future<List<List<dynamic>>> selectUsersByUserID(String userId) async {
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT * FROM users WHERE user_id = @id',
        substitutionValues: {
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

  Future<List<List<dynamic>>> selectUsersByName(
    String first,
    String last,
  ) async {
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
    String userInfo,
    String password,
  ) async {
    try {
      databaseConnection.open();
      List<List<dynamic>> results = await databaseConnection.query(
        'SELECT user_id FROM users WHERE (username = @username OR email = @email) AND password = @password',
        substitutionValues: {
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

  ////// Delete
  Future<bool> deleteUser(String userId) async {
    try {
      await databaseConnection.open();
      await databaseConnection.query(
        'DELETE FROM users WHERE user_id = @userId',
        substitutionValues: {
          'userId': userId,
        },
      );
      await databaseConnection.query(
        'DELETE FROM habits WHERE user_id = @userId',
        substitutionValues: {
          'userId': userId,
        },
      );
      await databaseConnection.query(
        'DELETE FROM activities WHERE user_id = @userId',
        substitutionValues: {
          'userId': userId,
        },
      );
      await databaseConnection.query(
        'DELETE FROM achievements WHERE user_id = @userId',
        substitutionValues: {
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
