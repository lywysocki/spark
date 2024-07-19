import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_repository.dart';

import 'package:spark/achievements/achievement.dart';

//achievements:    achievement_id, user_id, habit_id, achievement_title, timestamp, quantity
class AchievementsController extends ChangeNotifier {
  AchievementsController({required this.currentUserId}) {
    if (currentUserId.isNotEmpty) {
      _load();
    }
  }
  final String currentUserId;

  final AchievementsRepository _achievementsRepo = AchievementsRepository();

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
    await _achievementsRepo.createAchievement(
      currentUserId,
      habitID,
      achievementTitle,
      quantity,
    );
  }

  Future<List<Achievement>> getAchievements() async {
    /// Returned Items:
    /// achievementID,
    /// userID,
    /// habitID,
    /// achievementTitle,
    /// time,
    /// quantity
    final userAchievements =
        await _achievementsRepo.selectAchievements(currentUserId);

    List<Achievement> mappedAchievements = userAchievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByHabitId(
    String habitId,
  ) async {
    final achievements = await _achievementsRepo.selectAchievementsByHabitID(
      currentUserId,
      habitId,
    );

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByAchievementType(
    String achievementType,
  ) async {
    final achievements = await _achievementsRepo.selectAchievementsByType(
      currentUserId,
      achievementType,
    );

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByDate(
    DateTime date,
  ) async {
    final achievements =
        await _achievementsRepo.selectAchievementsByDate(currentUserId, date);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final achievements = await _achievementsRepo
        .selectAchievementsWithinDateRange(currentUserId, start, end);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            item[0],
            item[1],
            item[2],
            item[3],
            item[4],
            item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }
}
