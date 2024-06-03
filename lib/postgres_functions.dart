/*
users table fields:
   user_id, username, password, email, first_name, last_name
goals table fields:
  goal_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity
friendships table fields:
  user1_id, user2_id
achievements table fields:
  achievement_id, user_id, goal_id, achievement_type, achievement_description, date, timestamp, quantity
*/

//INSERT methods
boolean createUser(String username, String password, String email, [String first, String last]){
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
  return result;
}

boolean createFriendship(String user1, String user2){
  var result = await databaseConnection.query(
      'INSERT INTO friendships (user1_id, user2_id) VALUES (@user1, @user2)',
      substitutionValues: {
        'user1': user1,
        'user2': user2
      }
  );
  return result;
}

boolean createGoal(String userID, String title, String note, date start, date end, String frequency, Boolean reminders, [String reminderMessage], String targetType, String category, [int quantity]){
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
  return result;
}

boolean createAchievement(String userID, String goal_id, String achievementType, String achievementDescription, [int quantity]){
//system date and timestamp
  DateTime now = DateTime.now()
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
  return result;
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

List<List<dynamic>> selectGoalsEnded(String id, String cat){
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
