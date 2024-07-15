import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spark/common/common_habit_header.dart';
import 'package:spark/common/common_textfield.dart';
import 'package:spark/main.dart';
import 'package:spark/user/user_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hasAccount = true;
  bool loading = false;
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
          loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 150.0),
                  child: CircularProgressIndicator(),
                )
              : hasAccount
                  ? _UserInfoForm(
                      loading: () {
                        loading = !loading;
                      },
                      onPressed: () {
                        hasAccount = !hasAccount;
                        setState(() {});
                      },
                      isSignUp: false,
                    )
                  : _UserInfoForm(
                      loading: () {
                        loading = !loading;
                      },
                      onPressed: () {
                        hasAccount = !hasAccount;
                        setState(() {});
                      },
                      isSignUp: true,
                    ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class _UserInfoForm extends StatefulWidget {
  const _UserInfoForm({
    required this.onPressed,
    required this.loading,
    required this.isSignUp,
  });

  final VoidCallback onPressed;
  final Function loading;
  final bool isSignUp;

  @override
  State<_UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<_UserInfoForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
          ),
          child: _UserFormFields(
            loading: widget.loading,
            isSignUp: widget.isSignUp,
          ),
        ),
        TextButton(
          onPressed: widget.onPressed,
          child: Text(
            !widget.isSignUp
                ? 'Don\'t have an account? Sign up here!'
                : 'Already have an account? Login here!',
          ),
        ),
      ],
    );
  }
}

class _UserFormFields extends StatefulWidget {
  const _UserFormFields({
    this.isSignUp = false,
    required this.loading,
  });

  final bool isSignUp;
  final Function loading;

  @override
  State<_UserFormFields> createState() => _UserFormFieldsState();
}

class _UserFormFieldsState extends State<_UserFormFields> {
  UserController? controller;
  final userFormKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? password;
  String? fName;
  String? lName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<UserController>();
    userFormKey.currentState?.reset();
    email = null;
    password = null;
    fName = null;
    lName = null;
  }

  void onChanged(value) {
    setState(() {});
  }

  Future<SnackBar?> signUp() async {
    try {
      await controller!.signUp(
        username: username!,
        email: email!,
        pass: password!,
        fName: fName!,
        lName: lName,
      );
      return null;
    } catch (e) {
      return SnackBar(
        content: Text('$e'),
      );
    }
  }

  Future<SnackBar?> login() async {
    try {
      await controller!.login(
        username: username!,
        pass: password!,
      );
      return null;
    } catch (e) {
      return SnackBar(
        content: Text('$e'),
      );
    }
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
                fName = input;
                return null;
              },
            ),
          if (widget.isSignUp)
            _FormFieldWidget(
              onChanged: onChanged,
              title: 'Last name',
              hintText: 'Enter your last name',
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
                lName = input;

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
                username = input;

                return null;

                ///TODO: if username exists, 'This username already exists.'
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

                ///TODO: 'Incorrect username or password.'
                return null;
              },
            ),
          _FormFieldWidget(
            onChanged: onChanged,
            title: 'Password*',
            hintText:
                widget.isSignUp ? 'Enter a password' : 'Enter your password*',
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'Field cannot be blank.';
              }
              password = input;

              return null;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: FilledButton(
              onPressed: userFormKey.currentState?.validate() ?? false
                  ? () {
                      if (widget.isSignUp) {
                        signUp().then((value) {
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
                  : null,
              child: Text(widget.isSignUp ? 'Sign up' : 'Login'),
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
  });

  final String title;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

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
          onChanged: onChanged,
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
