import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_repository.dart';

import 'package:spark/achievements/achievement.dart';
import 'package:spark/habits/habit_controller.dart';

//achievements:    achievement_id, user_id, habit_id, achievement_title, timestamp, quantity
class AchievementsController extends ChangeNotifier {
  AchievementsController({required HabitController habitController})
      : _habitController = habitController {
    if (_currentUserId.isNotEmpty) {
      load();
    }
  }

  final HabitController _habitController;
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

  Future<void> checkForAchievements() async {
    final achievements = await getAchievements();
    final habits = _habitController.allHabits;
    debugPrint("Habits: $habits");

    //Check for 'First Habit' achievement
    final firstHabitAchievement = achievements.any(
      (achievement) => achievement.achievementTitle == 'First Habit!',
    );
    final hasAHabit = habits.isNotEmpty;
    debugPrint('Has Habits: $hasAHabit');
    debugPrint('First Habit Achievement Exists: $firstHabitAchievement');
    if (hasAHabit && !firstHabitAchievement) {
      debugPrint('Creating "First Habit!" Achievement');
      await setAchievement(habits.first.habitId, 'First Habit!', null);
    }

    //Check for Streak-based Achievements
    for (final habit in habits) {
      final currentStreak = habit.streak ?? 0;

      final streakMilestones = {
        7: '1-Week Streak!',
        30: '1-Month Streak!',
        180: '6-Month Streak!',
        365: 'Year Long Streak!',
      };

      for (final milestone in streakMilestones.keys) {
        if (currentStreak == milestone) {
          final achievementTitle = streakMilestones[milestone]!;
          final alreadyAchieved = (await getAchievements()).any(
            (achievement) =>
                achievement.achievementTitle == achievementTitle &&
                achievement.habitId == habit.habitId,
          );

          if (!alreadyAchieved) {
            await setAchievement(habit.habitId, achievementTitle, 1);
          } else {
            // TODO: Need to add in ability to update streak # for achievements
            break;
          }
        }
      }
    }

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
            achievementTitle: item[3].toString(),
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
