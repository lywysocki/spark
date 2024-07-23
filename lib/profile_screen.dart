import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/user/user_controller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, this.friend});

  final Friend? friend;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                    friend?.getName() ?? controller.currentUser!.getName(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Text(
                    friend != null
                        ? ''
                        : 'Joined ${DateFormat('MMMM y').format(controller.currentUser!.joined)}',
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
                      //TODO: highest streak
                      Text('10'),
                      SizedBox(width: 8),
                      Icon(Icons.flare_outlined),
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
                  onPressed: () {
                    controller.currentUserId = null;
                    controller.currentUser = null;
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  },
                ),
                TextButton(
                  child: const Text('Delete account'),
                  onPressed: () {
                    /// TODO: delete user account
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/'),
                    );
                  },
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
