//users table fields:
//user_id, username, password, email, first_name, last_name

//goals table fields:
//goal_id, user_id, title, note, start_date, end_date, frequency, reminders, reminder_message, target_type, category, quantity

//friendships table fields:
//user1_id, user2_id

//achievements table fields:
//achievement_id, user_id, goal_id, achievement_type, achievement_description, date, timestamp, quantity

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
