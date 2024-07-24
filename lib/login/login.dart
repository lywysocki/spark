import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/achievements/achievements_controller.dart';

import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_loading.dart';
import 'package:spark/common/common_textfield.dart';
import 'package:spark/friends/friendship_controller.dart';
import 'package:spark/main.dart';
import 'package:spark/user/user_controller.dart';

import 'package:spark/habits/habit_controller.dart';

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
            hasAccount ? '  Welcome back!' : '  Welcome!',
            style: theme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              bottom: 30.0,
              left: 10.0,
              right: 10.0,
            ),
            child: _UserFormFields(
              isSignUp: !hasAccount,
              onPageChanged: () {
                hasAccount = !hasAccount;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserFormFields extends StatefulWidget {
  const _UserFormFields({
    this.isSignUp = false,
    required this.onPageChanged,
  });

  final bool isSignUp;
  final Function onPageChanged;

  @override
  State<_UserFormFields> createState() => _UserFormFieldsState();
}

class _UserFormFieldsState extends State<_UserFormFields> {
  FriendshipController? _friendshipController;
  HabitController? _habitController;
  AchievementsController? _achievementsController;
  UserController? controller;
  final userFormKey = GlobalKey<FormState>();
  bool loading = false;

  String? username;
  String? email;
  String? password;
  String? fName;
  String? lName;

  @override
  void initState() {
    super.initState();
    userFormKey.currentState?.reset();

    _friendshipController = context.read<FriendshipController>();
    _habitController = context.read<HabitController>();
    _achievementsController = context.read<AchievementsController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<UserController>();
    email = null;
    password = null;
    fName = null;
    lName = null;
  }

  void onChanged(value) {
    setState(() {});
  }

  void changeLoading() {
    loading = !loading;
    setState(() {});
  }

  Future<SnackBar?> signUp() async {
    changeLoading();
    try {
      await controller!.signUp(
        username: username!,
        email: email!,
        pass: password!,
        fName: fName!,
        lName: lName,
      );
      await updateControllers();

      return null;
    } catch (e) {
      return SnackBar(
        content: Text('$e'),
      );
    } finally {
      changeLoading();
    }
  }

  Future<SnackBar?> login() async {
    changeLoading();
    try {
      await controller!.login(
        username: username!,
        pass: password!,
      );
      await updateControllers();

      return null;
    } catch (e) {
      return SnackBar(
        content: Text('$e'),
      );
    } finally {
      changeLoading();
    }
  }

  Future<void> updateControllers() async {
    final userId = (await controller!.getCurrentUser()).userId;

    await _friendshipController!.updateUser(userId);
    await _habitController!.updateUser(userId);
    await _achievementsController!.updateUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: userFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'First name*',
              hintText: 'Enter your first name*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                String regexSpecial = '^(?=.*[-+_!@#\$(){}%^&/<>`~*., ?]).+\$';
                String reqs = '';
                if (input.length > 25) {
                  reqs += 'First name cannot be longer than 25 characters\n';
                }
                if (RegExp(regexSpecial).hasMatch(input)) {
                  reqs += 'First name cannot contain special characters';
                }
                if (reqs.isNotEmpty) return reqs;

                fName = input;
                return null;
              },
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'Last name',
              hintText: 'Enter your last name',
              validator: (input) {
                if (input != null) {
                  String regexSpecial =
                      '^(?=.*[-+_!@#\$(){}%^&/<>`~*., ?]).+\$';
                  String reqs = '';
                  if (input.length > 25) {
                    reqs += 'Last name cannot be longer than 25 characters\n';
                  }
                  if (RegExp(regexSpecial).hasMatch(input)) {
                    reqs += 'Last name cannot contain special characters';
                  }
                  if (reqs.isNotEmpty) return reqs;
                }

                lName = input;

                return null;
              },
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'Email',
              hintText: 'Enter your email*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                String regexSpecial = '^(?=.*[-+!#\$(){}%^&/<>`~*, ?]).+\$';
                String reqs = '';
                if (!input.contains('@') || !input.contains('.')) {
                  reqs += 'Must be a valid email address';
                }
                if (input.length > 40) {
                  reqs += 'Email cannot be longer than 40 characters\n';
                }
                if (RegExp(regexSpecial).hasMatch(input)) {
                  reqs += 'Email cannot contain special characters';
                }
                if (reqs.isNotEmpty) return reqs;

                email = input;

                return null;
              },
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'Username',
              hintText: 'Enter a username*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                String regexSpecial = '^(?=.*[-+!@#\$(){}%^&/<>`~*., ?]).+\$';
                String reqs = '';
                if (input.length > 25) {
                  reqs += 'Username cannot be longer than 25 characters\n';
                }
                if (RegExp(regexSpecial).hasMatch(input)) {
                  reqs += 'Username cannot contain special characters';
                }
                if (reqs.isNotEmpty) return reqs;

                username = input;

                return null;
              },
            ),
          if (!widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'Username or email*',
              hintText: 'Enter your username or email*',
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Field cannot be blank.';
                }
                username = input;

                return null;
              },
            ),
          _FormFieldWidget(
            hideText: widget.isSignUp ? false : true,
            onChanged: onChanged,
            title: 'Password*',
            hintText:
                widget.isSignUp ? 'Enter a password' : 'Enter your password*',
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'Field cannot be blank.';
              }
              if (widget.isSignUp) {
                String regexCases = '^(?=.*[a-z])(?=.*[A-Z]).+\$';
                String regexNumber = '^(?=.*\\d).+\$';
                String regexSpecial = '^(?=.*[-+_!@#\$%^&*., ?]).+\$';
                String reqs = '';
                if (input.length < 8) {
                  reqs += 'Password must be at least 8 characters\n';
                }
                if (!RegExp(regexCases).hasMatch(input)) {
                  reqs += 'Password must contain all character cases\n';
                }
                if (!RegExp(regexNumber).hasMatch(input)) {
                  reqs += 'Password must be contain at least 1 number\n';
                }
                if (!RegExp(regexSpecial).hasMatch(input)) {
                  reqs += 'Password must contain at least 1 special character';
                }
                if (reqs.isNotEmpty) return reqs;
              }
              password = input;

              return null;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CommonLoadingWidget(),
                  )
                : FilledButton(
                    onPressed: () {
                      if (userFormKey.currentState?.validate() != true) {
                        return;
                      }
                      if (widget.isSignUp) {
                        signUp().then((value) {
                          if (value != null) {
                            ScaffoldMessenger.of(context).showSnackBar(value);
                            return;
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const MyHomePage();
                                },
                              ),
                            );
                          }
                        });
                      } else {
                        login().then((value) {
                          if (value != null) {
                            ScaffoldMessenger.of(context).showSnackBar(value);
                            return;
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const MyHomePage();
                                },
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: Text(widget.isSignUp ? 'Sign up' : 'Login'),
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                widget.onPageChanged();
                userFormKey.currentState?.reset();
                setState(() {});
              },
              child: Text(
                !widget.isSignUp
                    ? 'Don\'t have an account? Sign up here!'
                    : 'Already have an account? Login here!',
              ),
            ),
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
    this.onChanged,
    this.hideText = false,
  });

  final String title;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? hideText;

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
          hideText: hideText ?? false,
          onChanged: onChanged,
          validator: validator,
          hintText: hintText,
          initialValue: null,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
