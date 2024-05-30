import 'package:flutter/material.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';

class ViewHabitScreen extends StatelessWidget {
  const ViewHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: [
          Text('View Habit'),
          CommonCardTile(
            category: 'None',
            title: Text('Achievements'),
            destination: AchievementsScreen(),
            trailingWidget: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
