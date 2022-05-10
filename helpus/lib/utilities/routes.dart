import 'package:flutter/material.dart';
import 'package:helpus/screens/sign_in_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SignInScreen(),
  };
}
