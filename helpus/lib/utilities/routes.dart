import 'package:flutter/material.dart';
import 'package:helpus/screens/profile/profile_change_password.dart';
import 'package:helpus/screens/sign_in/forget_password_screen.dart';
import 'package:helpus/screens/home_screen.dart';
import 'package:helpus/screens/sign_in/register_screen.dart';
import 'package:helpus/screens/sign_in/sign_in_screen.dart';
import 'package:helpus/utilities/constants.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RoutesText.signIn: (context) => const SignInScreen(
          user: null,
        ),
    RoutesText.forgetPassword: (context) => const ForgetPasswordScreen(),
    RoutesText.register: (context) => const RegisterScreen(),
    RoutesText.home: (context) => HomeScreen(),
    RoutesText.changePassword: (context) => const ProfileChangePasswordScreen(),
  };
}
