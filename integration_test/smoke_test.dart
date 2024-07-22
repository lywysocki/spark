import 'package:flutter/material.dart';
import 'package:spark/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(app.MyApp, () {
    testWidgets('smoke', (tester) async {
      await binding.setSurfaceSize(const Size(390, 850));

      app.main();
      await tester.pumpAndSettle();

      Future<void> traverse(List<String> items) async {
        for (final item in items) {
          final itemFinder = find.descendant(
            of: find.byType(NavigationDestination),
            matching: find.text(item),
          );
          expect(itemFinder, findsOneWidget);
          await tester.tap(itemFinder);
          await tester.pumpAndSettle();
        }
      }

      Future<void> goBack() async {
        final backButton = find.byIcon(Icons.arrow_back);
        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }

      /// SignUp
      final signup = find.text('Don\'t have an account? Sign up here!');
      expect(signup, findsOne);
      await tester.tap(signup);
      await tester.pumpAndSettle();

      /// Login
      final login = find.text('Already have an account? Login here!');
      expect(login, findsOne);
      await tester.tap(login);
      await tester.pumpAndSettle();

      /// Enter test specific account information; SMOKE_TEST, Smoke_test0
      final username = find.ancestor(
        of: find.text('Enter your username or email*'),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(username, 'SMOKE_TEST');
      await tester.pumpAndSettle();

      final password = find.ancestor(
        of: find.text('Enter your password*'),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(password, 'Smoke_test0');
      await tester.pumpAndSettle();

      final loginButton = find.ancestor(
        of: find.text('Login'),
        matching: find.byType(FilledButton),
      );
      expect(loginButton, findsOne);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      /// LOGGED IN

      /// Friends, Habits, and Home screen
      await traverse(['Friends', 'Habits', 'Home']);

      /// ProfileScreen
      final profile = find.byIcon(Icons.account_circle_outlined);
      expect(profile, findsOneWidget);
      await tester.tap(profile);
      await tester.pumpAndSettle();

      /// All Achievements
      final allAchievements = find.text('View All Achievements');
      expect(allAchievements, findsOne);
      await tester.tap(allAchievements);
      await tester.pumpAndSettle();

      await goBack();
      await goBack();

      await traverse(['Friends']);

      final newFriend = find.text('Add new friend');
      expect(newFriend, findsOne);
      await tester.tap(newFriend);
      await tester.pumpAndSettle();

      final close = find.text('Close');
      expect(close, findsOne);
      await tester.tap(close);
      await tester.pumpAndSettle();

      /// New Habit Form
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final form = find.text('New Habit Form');
      expect(form, findsOne);
    });
  });
}
