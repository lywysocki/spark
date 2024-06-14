import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/profile_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Friends',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CommonCardTile(
                  category: 'None',
                  title: Text(
                    'Friend1',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  destination: Scaffold(
                    appBar: AppBar(),
                    body: const UserProfileScreen(),
                  ),
                  trailingWidget: const Icon(Icons.star),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
            child: FilledButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const _AddNewFriendDialog();
                  },
                );
              },
              child: const Text('Add new friend'),
            ),
          ),
        ],
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
  bool canAdd = false;

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
            textInputAction: TextInputAction.send,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text('Invite sent!'),
                    ),
                  );
                  Navigator.pop(context);
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
