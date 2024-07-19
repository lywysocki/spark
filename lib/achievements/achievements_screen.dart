import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_controller.dart';
import 'package:spark/common/common_search_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AchievementsController>();
    final theme = Theme.of(context).textTheme;
    String currentSearch = '';

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
                    onPressed: null,
                    icon: Icon(Icons.filter_alt),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                    mainAxisSpacing: 32.0,
                    crossAxisSpacing: 32.0,
                  ),

                  /// TODO(LW): add in specific badge object
                  itemBuilder: (_, index) => _BadgeIcon(
                    /// TODO: fill with real value
                    timesEarned: 10,

                    /// TODO: fill with achievement name
                    name: 'Achievement',

                    /// TODO: fill with real value or leave null
                    medalLevel: index % 3 == 0 ? 'silver' : null,
                  ),

                  /// TODO: fill with allAchievements.length
                  itemCount: controller.achievements.length,
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
  // bronze, silver, (default) gold
  final String? medalLevel;
  // if applicable
  final int? timesEarned;

  @override
  Widget build(BuildContext context) {
    final medal = medalLevel ?? 'gold';
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
