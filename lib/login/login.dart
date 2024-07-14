import 'package:flutter/material.dart';
import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_textfield.dart';
import 'package:spark/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hasAccount = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 80,
            child: Image.asset(
              'assets/images/spark.png',
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '  Welcome back!',
            style: theme.titleLarge,
          ),
          hasAccount
              ? _LoginForm(
                  onPressed: () {
                    hasAccount = !hasAccount;
                    setState(() {});
                  },
                )
              : _SignUpForm(
                  onPressed: () {
                    hasAccount = !hasAccount;
                    setState(() {});
                  },
                ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 30.0,
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
          ),
          child: _UserFormFields(),
        ),
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
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text('Don\'t have an account? Sign up here!'),
        ),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 30.0,
            bottom: 15.0,
            left: 10.0,
            right: 10.0,
          ),
          child: _UserFormFields(
            isSignUp: true,
          ),
        ),
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
          child: const Text('Sign up'),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text('Already have an account? Sign up here!'),
        ),
      ],
    );
  }
}

class _UserFormFields extends StatefulWidget {
  const _UserFormFields({this.isSignUp = false});

  final bool isSignUp;

  @override
  State<_UserFormFields> createState() => _UserFormFieldsState();
}

class _UserFormFieldsState extends State<_UserFormFields> {
  final _userFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isSignUp)
            _FormFieldWidget(
              title: 'First name*',
              hintText: 'Enter your first name*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                return null;
              },
            ),
          if (widget.isSignUp)
            const _FormFieldWidget(
              title: 'Last name',
              hintText: 'Enter your last name',
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              title: 'Email',
              hintText: 'Enter your email*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                return null;
              },
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              title: 'Username',
              hintText: 'Enter a username*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                return null;

                ///TODO: if username exists, 'This username already exists.'
              },
            ),
          if (!widget.isSignUp)
            _FormFieldWidget(
              title: 'Username or email*',
              hintText: 'Enter your username or email*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }

                ///TODO: 'Incorrect username or password.'
                return null;
              },
            ),
          _FormFieldWidget(
            title: 'Password*',
            hintText:
                widget.isSignUp ? 'Enter a password' : 'Enter your password*',
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'Field cannot be blank.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _FormFieldWidget extends StatelessWidget {
  const _FormFieldWidget({
    required this.title,
    required this.hintText,
    this.validator,
  });

  final String title;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonHabitHeader(
          text: title,
          bottomPadding: 0,
          topPadding: 0,
        ),
        CommonTextfield(
          validator: validator,
          hintText: hintText,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
