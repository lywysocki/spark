import 'package:flutter/material.dart';
import 'package:spark/postgres_functions.dart';

import 'package:spark/achievements/achievement.dart';

class AchievementsController extends ChangeNotifier {
  AchievementsController();
  List<Achievement> _achievements = [];
  final _tempUserID = '1';

  List<Achievement> get achievements => _achievements;

  Future<void> _load() async {
    _achievements = await getAchievements(_tempUserID);
    notifyListeners();
  }

  Future<void> setAchievement(
    String userID,
    String habitID,
    String achievementTitle,
    int? quantity,
  ) async {
    await createAchievement(userID, habitID, achievementTitle, quantity);
  }

  Future<List<Achievement>> getAchievements(String userId) async {
    /// Returned Items:
    /// achievementID,
    /// userID,
    /// habitID,
    /// achievementTitle,
    /// date,
    /// time,
    /// quantity
    final userAchievements = await selectAchievements(userId);

    List<Achievement> mappedAchievements = userAchievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
            item[6],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByHabitId(
    String userId,
    String habitId,
  ) async {
    final achievements = await selectAchievementsByHabitID(userId, habitId);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
            item[6],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByAchievementType(
    String userId,
    String achievementType,
  ) async {
    final achievements =
        await selectAchievementsByType(userId, achievementType);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
            item[6],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByDate(
    String userId,
    DateTime date,
  ) async {
    final achievements = await selectAchievementsByDate(userId, date);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
            item[6],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final achievements =
        await selectAchievementsWithinDateRange(userId, start, end);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
            item[6],
          ),
        )
        .toList();

    return mappedAchievements;
  }
}
