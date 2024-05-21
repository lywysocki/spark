import 'package:flutter/material.dart';
import 'package:spark/friends/friends_screen.dart';
import 'package:spark/habits/habits_screen.dart';
import 'package:spark/home_screen.dart';
import 'package:spark/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SPARK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const UserProfileScreen(),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              label: destination.title,
              icon: destination.icon,
            ),
        ],
      ),
      body: _destinations[_pageIndex].builder(context),
    );
  }
}

final _destinations = <Destination>[
  Destination(
    title: 'Home',
    icon: const Icon(Icons.home_outlined),
    builder: (context) => const HomeScreen(),
  ),
  Destination(
    title: 'Habits',
    icon: const Icon(Icons.list),
    builder: (context) => const HabitsScreen(),
  ),
  Destination(
    title: 'Friends',
    icon: const Icon(Icons.people),
    builder: (context) => const FriendsScreen(),
  ),
];

class Destination {
  const Destination({
    required this.title,
    required this.icon,
    required this.builder,
  });

  final String title;
  final Icon icon;
  final WidgetBuilder builder;
}
