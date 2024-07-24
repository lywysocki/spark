import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_controller.dart';
import 'package:spark/common/common_empty_list.dart';
import 'package:spark/common/common_search_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String currentSearch = '';

  String getMedalLevel(int timesEarned) {
    if (timesEarned >= 10) {
      return 'gold';
    } else if (timesEarned >= 5) {
      return 'silver';
    } else {
      return 'bronze';
    }
  }

  @override
  Widget build(BuildContext context) {
    final achievementController = context.watch<AchievementsController>();
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Achievements',
          style: theme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CommonSearchBar(
                      currentSearch: (item) =>
                          setState(() => currentSearch = item),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const IconButton(
                    onPressed: null, // TODO(LW): add ability to filter
                    icon: Icon(Icons.filter_alt),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            achievementController.achievements.isEmpty
                ? const Expanded(
                    child: EmptyListWidget(
                      text:
                          'You don\'t have any friends yet.\n Add a new friend to get started!',
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 150,
                          mainAxisSpacing: 32.0,
                          crossAxisSpacing: 32.0,
                        ),
                        itemBuilder: (_, index) {
                          final achievement =
                              achievementController.achievements[index];

                          return _BadgeIcon(
                            timesEarned: achievement.quantity ?? 1,
                            name: achievement.achievementTitle,
                            medalLevel:
                                getMedalLevel(achievement.quantity ?? 1),
                          );
                        },
                        itemCount: achievementController.achievements.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({
    required this.name,
    this.medalLevel,
    this.timesEarned,
  });

  final String name;
  // (default) bronze, silver, gold
  final String? medalLevel;
  // if applicable
  final int? timesEarned;

  @override
  Widget build(BuildContext context) {
    final medal = medalLevel ?? 'bronze';
    final theme = Theme.of(context).textTheme;

    return Card(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          width: 115,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: theme.titleMedium,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Image.asset(
                scale: 2.5,
                'assets/images/$medal.png',
              ),
              const SizedBox(
                height: 5.0,
              ),
              if (timesEarned != null)
                Text(
                  "Times Earned: $timesEarned",
                  style: theme.titleSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAchievementsList extends StatelessWidget {
  const _EmptyAchievementsList();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_rounded,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'You haven\'t earned any achievements yet.\n Keep completing and maintaining habits to earn some!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
