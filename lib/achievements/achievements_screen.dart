import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievement.dart';
import 'package:spark/achievements/achievements_controller.dart';
import 'package:spark/common/common_empty_list.dart';
import 'package:spark/common/common_loading.dart';
import 'package:spark/common/common_search_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key, this.userId});

  final String? userId;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String currentSearch = '';
  List<Achievement> achievements = [];
  bool loading = true;
  late AchievementsController achievementController;

  String getMedalLevel(int? timesEarned) {
    if (timesEarned == null || timesEarned >= 15) {
      return 'gold';
    } else if (timesEarned >= 5) {
      return 'silver';
    } else {
      return 'bronze';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    achievementController = context.read<AchievementsController>();

    if (widget.userId == null) {
      checkAchievements();
    }
    achievements.clear();
    getAchievements();
  }

  Future<void> getAchievements() async {
    loading = true;
    await achievementController.load(userId: widget.userId);

    achievements = achievementController.achievements;

    final tempNames = [];
    final List<Achievement> singleAchievements = [];
    for (final a in achievements) {
      if (!tempNames.contains(a.achievementTitle)) {
        singleAchievements.add(a);
        tempNames.add(a.achievementTitle);
      } else {
        final update = singleAchievements.firstWhereOrNull(
          (element) => element.achievementTitle == a.achievementTitle,
        );
        update?.earned();
      }
    }

    achievements.clear();
    achievements.addAll(singleAchievements);

    loading = false;
    setState(() {});
  }

  Future<void> checkAchievements() async {
    loading = true;

    await achievementController.checkForAchievements();

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final displayAchievements = achievements
        .where(
          (element) => element.achievementTitle
              .toLowerCase()
              .contains(currentSearch.toLowerCase()),
        )
        .toList();
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
        child: loading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 140.0),
                child: CommonLoadingWidget(),
              )
            : Column(
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  achievements.isEmpty
                      ? const EmptyListWidget(
                          text:
                              'You haven\'t earned any achievements yet.\n Keep completing and maintaining habits to earn some!',
                        )
                      : Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width ~/ 150,
                                mainAxisSpacing: 32.0,
                                crossAxisSpacing: 32.0,
                              ),
                              itemBuilder: (_, index) {
                                final achievement = displayAchievements[index];

                                return _BadgeIcon(
                                  timesEarned: achievement.quantity,
                                  name: achievement.achievementTitle,
                                  medalLevel:
                                      getMedalLevel(achievement.quantity),
                                );
                              },
                              itemCount: displayAchievements.length,
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
                textAlign: TextAlign.center,
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
