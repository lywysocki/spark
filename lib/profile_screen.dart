import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Profile'),
        CommonCardTile(
          title: 'View All Achievements',
          destination: AchievementsScreen(),
          trailingIcon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}
