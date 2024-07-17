import 'package:spark/friends/friends_screen.dart';
import 'package:spark/friends/friendship_controller.dart';
import 'package:spark/habits/habits_screen.dart';
import 'package:spark/habits/new_habit_screen.dart';
import 'package:spark/home_screen.dart';
import 'package:spark/login/login.dart';
import 'package:spark/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:spark/theme.dart';
import 'package:spark/user/user_controller.dart';
import 'package:spark/util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// (LJ) This will pick their platform brightness. Mine is on dark I'm not really working on the dark theme yet.
    /// View.of(context).platformDispatcher.platformBrightness;
    const brightness = Brightness.light;

    TextTheme textTheme = createTextTheme(context, "Lato", "Lato");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spark',
      theme: brightness == Brightness.light
          ? theme.lightMediumContrast()
          : theme.darkMediumContrast(),
      initialRoute: '/',
      home: ChangeNotifierProvider(
        create: (context) => UserController(),
        child: const LoginScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const NewHabitScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'LOGO',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        appBar: AppBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        body: const UserProfileScreen(),
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
    icon: const Icon(Icons.home),
    builder: (context) => const HomeScreen(),
  ),
  Destination(
    title: 'Habits',
    icon: const Icon(Icons.auto_awesome),
    builder: (context) => const HabitsScreen(),
  ),
  Destination(
    title: 'Friends',
    icon: const Icon(Icons.people),
    builder: (context) => ChangeNotifierProvider(
      create: (context) => FriendshipController(currentUserId: '1'),
      child: const FriendsScreen(),
    ),
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
