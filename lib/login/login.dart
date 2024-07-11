import 'package:flutter/material.dart';
import 'package:spark/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Login'),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MyHomePage();
                  },
                ),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
