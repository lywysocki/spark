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
              10,
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
              onPressed: () {},
              child: const Text('Add new friend'),
            ),
          ),
        ],
      ),
    );
  }
}
