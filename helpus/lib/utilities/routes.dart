import 'package:flutter/material.dart';
import 'package:helpus/screens/sign_in/forget_password_screen.dart';
import 'package:helpus/screens/home_screen.dart';
import 'package:helpus/screens/sign_in/register_screen.dart';
import 'package:helpus/screens/sign_in/sign_in_screen.dart';
import 'package:helpus/screens/todo/todo_add_screen.dart';
import 'package:helpus/utilities/constants.dart';

// Routes url and equivalent screens
class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RoutesText.signIn: (context) => const SignInScreen(
          user: null,
        ),
    RoutesText.forgetPassword: (context) => const ForgetPasswordScreen(),
    RoutesText.register: (context) => const RegisterScreen(),
    RoutesText.home: (context) => HomeScreen(),
    RoutesText.addTask: (context) => const TodoAddScreen(),
  };
}
