import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_screen.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/habits/habit.dart';
import 'package:spark/habits/habit_controller.dart';
import 'package:spark/user/user_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, this.friend});

  final Friend? friend;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final List<Habit> sharedHabits = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.friend != null) {
      getSharedHabits();
    }
  }

  Future<void> getSharedHabits() async {
    final habitController = context.read<HabitController>();
    final controller = context.read<UserController>();

    sharedHabits.addAll(
      await habitController.getSharedHabits(
        userId: controller.currentUserId!,
        friendUserId: widget.friend!.userId,
      ),
    );

    setState(() {});
  }

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
        ),
        Column(
          children: [
            const SizedBox(
              height: 220,
            ),
            Center(
              child: Text(
                widget.friend?.getName() ?? controller.currentUser!.getName(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Center(
              child: Text(
                widget.friend != null
                    ? ''
                    : 'Joined ${DateFormat('MMMM y').format(controller.currentUser!.joined)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        if (widget.friend == null)
                          CommonCardTile(
                            category: '',
                            title: const Text('Highest Streak'),
                            trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${controller.currentUser!.longestStreak}',
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.flare_outlined),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        CommonCardTile(
                          category: 'None',
                          title: const Text('View All Achievements'),
                          destination: AchievementsScreen(
                            userId: widget.friend?.userId,
                          ),
                          trailingWidget:
                              const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.friend != null)
                          Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: CommonCardTile(
                              title: ExpansionTile(
                                childrenPadding:
                                    const EdgeInsetsDirectional.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                shape: null,
                                tilePadding: EdgeInsets.zero,
                                title: const Text('Shared Habits'),
                                children: [
                                  for (final habit in sharedHabits)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        Text(
                                          habit.title,
                                        ),
                                      ],
                                    ),
                                  if (sharedHabits.isNotEmpty) const Divider(),
                                  if (sharedHabits.isEmpty)
                                    const Text('No shared habits...'),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 70,
                        ),
                        if (widget.friend == null)
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
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.friend == null)
                          TextButton(
                            child: const Text('Delete account'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text(
                                    'This action cannot be undone.',
                                  ),
                                  actions: [
                                    FilledButton(
                                      onPressed: () {
                                        controller.deleteUser();
                                        Navigator.popUntil(
                                          context,
                                          ModalRoute.withName('/'),
                                        );
                                      },
                                      child: const Text('Delete account'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Icon(
                Icons.person,
                size: 90,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
