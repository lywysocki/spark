import 'package:flutter/material.dart';
import 'package:spark/postgres_functions.dart';

import 'package:spark/achievements/achievement.dart';

class AchievementsController extends ChangeNotifier {
  AchievementsController({required this.currentUserId});
  final String currentUserId;

  List<Achievement> _achievements = [];

  List<Achievement> get achievements => _achievements;

  Future<void> _load() async {
    _achievements = await getAchievements();
    notifyListeners();
  }

  Future<void> setAchievement(
    String habitID,
    String achievementTitle,
    int? quantity,
  ) async {
    await createAchievement(currentUserId, habitID, achievementTitle, quantity);
  }

  Future<List<Achievement>> getAchievements() async {
    /// Returned Items:
    /// achievementID,
    /// userID,
    /// habitID,
    /// achievementTitle,
    /// date,
    /// time,
    /// quantity
    final userAchievements = await selectAchievements(currentUserId);

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
    String habitId,
  ) async {
    final achievements =
        await selectAchievementsByHabitID(currentUserId, habitId);

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
    String achievementType,
  ) async {
    final achievements =
        await selectAchievementsByType(currentUserId, achievementType);

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
    DateTime date,
  ) async {
    final achievements = await selectAchievementsByDate(currentUserId, date);

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
    DateTime start,
    DateTime end,
  ) async {
    final achievements =
        await selectAchievementsWithinDateRange(currentUserId, start, end);

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
