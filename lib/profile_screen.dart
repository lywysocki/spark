import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(190),
              topLeft: Radius.circular(190),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Center(
                  child: Text(
                    'User Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Text(
                    'Joined June 2024',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const CommonCardTile(
                  category: '',
                  title: Text('Highest Streak'),
                  trailingWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('10'),
                      SizedBox(width: 8),
                      Icon(Icons.star),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CommonCardTile(
                  category: 'None',
                  title: Text('View All Achievements'),
                  destination: AchievementsScreen(),
                  trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('Delete account'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.person,
                size: 90,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
