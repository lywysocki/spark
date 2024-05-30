import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const CommonCardTile(
            category: 'None',
            title: Text('View All Achievements'),
            destination: AchievementsScreen(),
            trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
