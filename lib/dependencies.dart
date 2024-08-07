import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_controller.dart';
import 'package:spark/friends/friendship_controller.dart';
import 'package:spark/habits/habit_controller.dart';
import 'package:spark/user/user_controller.dart';

class Dependencies extends StatelessWidget {
  const Dependencies({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HabitController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AchievementsController(
            habitController: context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FriendshipController(),
        ),
      ],
      child: child,
    );
  }
}
