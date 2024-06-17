import 'package:flutter/material.dart' hide SearchBar;
import 'package:spark/common/common_search_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    const num = 7;
    String currentSearch = '';

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Achievements',
              style: theme.titleLarge,
            ),
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
                      onPressed: null, icon: Icon(Icons.filter_alt)),
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                    mainAxisSpacing: 32.0,
                    crossAxisSpacing: 32.0,
                  ),
                  //TODO(LW): add in specific badge object
                  itemBuilder: (_, index) => Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[100],
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ACHIEVEMENT",
                            style: theme.titleMedium,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Icon(
                            Icons.bug_report_outlined,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text("Times Earned: $num"),
                        ],
                      ),
                    ),
                  ),
                  itemCount: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
