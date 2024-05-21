import 'package:flutter/material.dart';
import 'package:spark/common/common_tile.dart';
import 'package:spark/profile_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Friends'),
        CommonCardTile(
          title: 'Friend1',
          destination: Scaffold(
            appBar: AppBar(),
            body: const UserProfileScreen(),
          ),
          trailingIcon: const Icon(Icons.star),
        ),
      ],
    );
  }
}
