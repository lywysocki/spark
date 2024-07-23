import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/common/common_loading.dart';
import 'package:spark/common/common_search_bar.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/friends/friend.dart';
import 'package:spark/friends/friendship_controller.dart';
import 'package:spark/profile_screen.dart';
import 'package:spark/theme.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String currentSearch = '';
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FriendshipController>();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Friends',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CommonSearchBar(
            hintText: 'Search friends',
            currentSearch: (e) {
              setState(() {
                currentSearch = e;
              });
            },
          ),
          controller.loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80.0),
                  child: Center(
                    child: CommonLoadingWidget(),
                  ),
                )
              : _FriendTiles(
                  currentSearch: currentSearch,
                ),
          const SizedBox(
            height: 15,
          ),
          if (!controller.loading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: controller,
                          child: const _AddNewFriendDialog(),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Add New Friend',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FriendTiles extends StatefulWidget {
  const _FriendTiles({required this.currentSearch});

  final String currentSearch;

  @override
  State<_FriendTiles> createState() => _FriendTilesState();
}

class _FriendTilesState extends State<_FriendTiles> {
  FriendshipController? controller;
  List<Friend> allFriends = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<FriendshipController>();
    allFriends.clear();
    allFriends.addAll(controller!.allFriends);
    allFriends.addAll(controller!.pendingRequests);
  }

  @override
  Widget build(BuildContext context) {
    final displayFriends = allFriends.where(
      (element) => element.username
          .toLowerCase()
          .contains(widget.currentSearch.toLowerCase()),
    );
    return displayFriends.isEmpty
        ? const _EmptyFriendsList()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final friend in displayFriends)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: CommonCardTile(
                    category: 'None',
                    title: Text(
                      friend.username,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    destination: Scaffold(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      appBar: AppBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      body: const UserProfileScreen(),
                    ),
                    trailingWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (friend.isPending)
                          IconButton(
                            onPressed: () async {
                              await controller!.acceptRequest(friend.userId);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.check_rounded,
                              color: greenDark,
                            ),
                          ),
                        if (friend.isPending)
                          IconButton(
                            onPressed: () async {
                              await controller!.rejectRequest(friend.userId);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: redDark,
                            ),
                          ),
                        if (!friend.isPending)
                          PopupMenuButton(
                            elevation: 10,
                            menuPadding: EdgeInsets.zero,
                            shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            onSelected: (value) async {
                              switch (value) {
                                case 'remove':
                                  return showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return _RemoveFriendDialog(
                                        friend: friend,
                                      );
                                    },
                                  );
                                default:
                                  throw UnimplementedError();
                              }
                            },
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'remove',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person_remove_rounded,
                                      color: redDark,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Remove',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }
}

class _EmptyFriendsList extends StatelessWidget {
  const _EmptyFriendsList();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_rounded,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'You don\'t have any friends yet.\n Add a new friend to get started!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewFriendDialog extends StatefulWidget {
  const _AddNewFriendDialog();

  @override
  State<_AddNewFriendDialog> createState() => _AddNewFriendDialogState();
}

class _AddNewFriendDialogState extends State<_AddNewFriendDialog> {
  final TextEditingController _textController = TextEditingController();
  final userFormKey = GlobalKey<FormState>();

  bool canAdd = false;
  FriendshipController? controller;
  String? username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<FriendshipController>();
    userFormKey.currentState?.reset();
    username = null;
  }

  Future<SnackBar> sendFriendRequest() async {
    try {
      await controller!.sendFriendRequest(username!);
      return const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Invite Sent'),
      );
    } catch (e) {
      return SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('$e'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.removeListener(() {});
    _textController.addListener(() {
      canAdd = _textController.text.isNotEmpty;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: userFormKey,
      title: const Row(
        children: [
          Icon(Icons.person_add_alt_1_outlined),
          SizedBox(
            width: 10,
          ),
          Text('Add New Friend'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Please enter your friend\'s username.',
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _textController,
            onChanged: (value) {
              setState(() {
                username = value.toString();
              });
            },
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Username',
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: canAdd
              ? () {
                  sendFriendRequest().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(value);
                    Navigator.pop(context);
                  });
                }
              : null,
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _RemoveFriendDialog extends StatelessWidget {
  const _RemoveFriendDialog({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.person_remove_rounded),
          SizedBox(
            width: 10,
          ),
          Text('Remove Friend'),
        ],
      ),
      content: Text(
        'Are you sure you want to remove ${friend.username} as a friend?',
      ),
      actions: [
        FilledButton(
          onPressed: () {
            final controller = context.read<FriendshipController>();
            controller.rejectRequest(friend.userId).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text('${friend.username} removed from friends list'),
                ),
              );
              Navigator.pop(context);
            });
          },
          child: const Text('Remove'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
