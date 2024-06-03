/* OPTIONS:
  boolean createUser(String username, String password, String email, [String first, String last])
  boolean createFriendship(String user1, String user2)
  boolean createGoal(String userID, String title, String note, date start, date end, String frequency, Boolean reminders, [String reminderMessage], String targetType, String category, [int quantity])
  boolean createAchievement(String userID, String goal_id, String achievementType, String achievementDescription, [int quantity])

  List<List<dynamic>> selectUsersByUsername(String username)
  List<List<dynamic>> selectUsersByEmail(String email)
  List<List<dynamic>> selectUsersByName(String first, String last)
  List<List<dynamic>> selectFriendsByUser(String userID)
  List<List<dynamic>> selectGoalsByUserID(String id)
  List<List<dynamic>> selectGoalsByTitle(String id, String title)
  List<List<dynamic>> selectGoalsStarted(String id, date date)
  List<List<dynamic>> selectGoalsEnded(String id, date date)
  List<List<dynamic>> selectGoalsByCategory(String id, String cat)
  List<List<dynamic>> selectAchievements(String id)
  List<List<dynamic>> selectAchievementsByGoalID(String id, String goal)
  List<List<dynamic>> selectAchievementsByType(String id, String type)
  List<List<dynamic>> selectAchievementsByDate(String id, String type)
  List<List<dynamic>> selectAchievementsByDateRange(String id, String type)
 */

/* TABLE FIELDS
users:    user_id, username, password, email, first_name, last_name
goals:    goal_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
friendships:   user1_id, user2_id
achievements:    achievement_id, user_id, goal_id, achievement_type, achievement_description, date, timestamp, quantity
 */

//INSERT methods
boolean createUser(String username, String password, String email, [String first, String last]) async {
  try {
    await connection.open();
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
  } on PostgreSQLException catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

boolean createFriendship(String user1, String user2) async {
  try {
    await connection.open();
    var result = await databaseConnection.query(
        'INSERT INTO friendships (user1_id, user2_id) VALUES (@user1, @user2)',
        substitutionValues: {
          'user1': user1,
          'user2': user2
        }
    );
    print(result)
    return true;
  } on PostgreSQLException catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

boolean createGoal(String userID, String title, String note, date start, date end, String frequency, Boolean reminders, [String reminderMessage], String targetType, String category, [int quantity]) async {
  try {
    await connection.open();
    var result = await databaseConnection.query(
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
    print(results)
    return true;
  } on PostgreSQLException catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

boolean createAchievement(String userID, String goal_id, String achievementType, String achievementDescription, [int quantity]) async {
  try {
    await connection.open();
    DateTime now = DateTime.now() //system date and timestamp
    var result = await databaseConnection.query(
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
    print(results)
    return true;
  } on PostgreSQLException catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}

//SELECT Functions
// Users
List<List<dynamic>> selectUsersByUsername(String username){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM users WHERE username = @name',
    substitutionValues: {
      'name': username
    }
  );
  return results;
}

List<List<dynamic>> selectUsersByEmail(String email){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM users WHERE email = @email',
    substitutionValues: {
      'email': email
    }
  );
  return results;
}

List<List<dynamic>> selectUsersByName(String first, String last){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM users WHERE first_name = @firstname AND last_name = @lastname',
    substitutionValues: {
      'firstname': first,
      'lastname': last
    }
  );
  return results;
}

// Friendships
List<List<dynamic>> selectFriendsByUser(String userID){
  List<List<dynamic>> results = await connection.query(
    'SELECT user2_id FROM users WHERE user1_id = @id',
    substitutionValues: {
      'id': userID
    }
  );
  List<List<dynamic>> results2 = await connection.query(
    'SELECT user1_id FROM users WHERE user2_id = @id',
    substitutionValues: {
      'id': userID
    }
  );

  results.addAll(results2);
  return results;
}

// Goals
List<List<dynamic>> selectGoalsByUserID(String id){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM goals WHERE user_id = @userID',
    substitutionValues: {
      'userID': id
    }
  );
  return results;
}

List<List<dynamic>> selectGoalsByTitle(String id, String title){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM goals WHERE user_id = @userID and title = @title',
    substitutionValues: {
      'userID': id,
      'title': title
    }
  );
  return results;
}

List<List<dynamic>> selectGoalsStarted(String id, date date){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM goals WHERE user_id = @userID and start_date <= @date '
        'and (end_date is NULL or end_date >= @date)',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

List<List<dynamic>> selectGoalsEnded(String id, date date){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM goals WHERE user_id = @userID and end_date < @date',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

List<List<dynamic>> selectGoalsByCategory(String id, String cat){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM goals WHERE user_id = @userID and category = @category',
    substitutionValues: {
      'userID': id,
      'category': cat
    }
  );
  return results;
}

// Achievements
List<List<dynamic>> selectAchievements(String id){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM achievements WHERE user_id = @userID',
    substitutionValues: {
      'userID': id
    }
  );
  return results;
}

List<List<dynamic>> selectAchievementsByGoalID(String id, String goal){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and goal_id = @goalID',
    substitutionValues: {
      'userID': id,
      'goalID': goal
    }
  );
  return results;
}

List<List<dynamic>> selectAchievementsByType(String id, String type){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and achievement_type = @achievementType',
    substitutionValues: {
      'userID': id,
      'achievementType': type
    }
  );
  return results;
}

List<List<dynamic>> selectAchievementsByDate(String id, Date date){
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM achievements WHERE user_id = @userID and date = @date',
    substitutionValues: {
      'userID': id,
      'date': date
    }
  );
  return results;
}

List<List<dynamic>> selectAchievementsWithinDateRange(String id, Date start, Date end){
  List<List<dynamic>> results = await connection.query(
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
Boolean updateUserUsername(String userID, String newUsername) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateUserFirstName(String userID, String newName) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateUserLastName(String userID, String newName) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateUserPassword(String userID, String newPassword) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateUserEmail(String userID, String newEmail) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalTitle(String goalID, String newTitle) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalNote(String goalID, String newNote) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalEnd(String goalID, Date newEnd) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalFrequency(String goalID, String newFrequency) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalReminders(String goalID, Boolean newReminder) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalReminderMessage(String goalID, String newMessage) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalTargetType(String goalID, String newType) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalCategory(String goalID, String newCategory) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean updateGoalQuantity(String goalID, String newQuantity) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean deleteUser(String username) async {
  try {
    await connection.open();
    await connection.query(
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

Boolean deleteGoalAndAchievements(String goalID) async {
  try {
    await connection.open();
    await connection.query(
      'DELETE FROM goals WHERE goal_id = @id',
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

Boolean deleteFriendships(String userID1, String userID2) async {
  try {
    await connection.open();
    await connection.query(
      'DELETE FROM friendships WHERE (user1_id = @id1 and user2_id = @id2) '
      'or (user2_id = @id1 and user1_id = @id2)',
      substitutionValues: {
        'id1': userID1
        'id2': userID2
      }
    );
    return true;
  } catch (e) {
    print('Error: ${e.toString()}');
    return false;
  }
}


