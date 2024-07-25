import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_repository.dart';

import 'package:spark/achievements/achievement.dart';

//achievements:    achievement_id, user_id, habit_id, achievement_title, timestamp, quantity
class AchievementsController extends ChangeNotifier {
  AchievementsController() {
    if (_currentUserId.isNotEmpty) {
      load();
    }
  }
  String _currentUserId = '';

  final AchievementsRepository _achievementsRepo = AchievementsRepository();

  final List<Achievement> _achievements = [];

  List<Achievement> get achievements => _achievements;

  Future<void> load() async {
    _achievements.clear();
    _achievements.addAll(await getAchievements());
    if (hasListeners) notifyListeners();
  }

  Future<void> updateUser(String newUserId) async {
    _currentUserId = newUserId;
    await load();
  }

  Future<void> setAchievement(
    String habitID,
    String achievementTitle,
    int? quantity,
  ) async {
    await _achievementsRepo.createAchievement(
      _currentUserId,
      habitID,
      achievementTitle,
      quantity,
    );
  }

  Future<List<Achievement>> getAchievements({String? userId}) async {
    /// Returned Items:
    /// achievementID,
    /// userID,
    /// habitID,
    /// achievementTitle,
    /// time,
    /// quantity
    final userAchievements =
        await _achievementsRepo.selectAchievements(userId ?? _currentUserId);

    List<Achievement> mappedAchievements = userAchievements
        .map(
          (item) => Achievement(
            achievementId: item[0].toString(),
            userId: item[1].toString(),
            habitId: item[2].toString(),
            achievementTitle: item[3],
            time: item[4],
            quantity: item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByHabitId(
    String habitId,
  ) async {
    final achievements = await _achievementsRepo.selectAchievementsByHabitID(
      _currentUserId,
      habitId,
    );

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            achievementId: item[0].toString(),
            achievementTitle: item[1],
            habitId: item[2].toString(),
            time: item[3],
            userId: item[4].toString(),
            quantity: item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByAchievementType(
    String achievementType,
  ) async {
    final achievements = await _achievementsRepo.selectAchievementsByType(
      _currentUserId,
      achievementType,
    );

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            achievementId: item[0].toString(),
            achievementTitle: item[1],
            habitId: item[2].toString(),
            time: item[3],
            userId: item[4].toString(),
            quantity: item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }

  Future<List<Achievement>> getByDate(
    DateTime date,
  ) async {
    final achievements =
        await _achievementsRepo.selectAchievementsByDate(_currentUserId, date);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            achievementId: item[0].toString(),
            achievementTitle: item[1],
            habitId: item[2].toString(),
            time: item[3],
            userId: item[4].toString(),
            quantity: item[5],
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
        .selectAchievementsWithinDateRange(_currentUserId, start, end);

    List<Achievement> mappedAchievements = achievements
        .map(
          (item) => Achievement(
            achievementId: item[0].toString(),
            achievementTitle: item[1],
            habitId: item[2].toString(),
            time: item[3],
            userId: item[4].toString(),
            quantity: item[5],
          ),
        )
        .toList();

    return mappedAchievements;
  }
}
