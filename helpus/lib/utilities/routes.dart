import 'package:flutter/material.dart';
import 'package:helpus/screens/error_screen.dart';
import 'package:helpus/screens/sign_in/forget_password_screen.dart';
import 'package:helpus/screens/home_screen.dart';
import 'package:helpus/screens/sign_in/register_screen.dart';
import 'package:helpus/screens/sign_in/sign_in_screen.dart';
import 'package:helpus/screens/todo/todo_add_screen.dart';
import 'package:helpus/screens/todo/todo_edit_screen.dart';
import 'package:helpus/utilities/constants.dart';

// Routes url and equivalent screens
class Routes {
  // static Map<String, Widget Function(BuildContext)> routes = {
  //   RoutesText.signIn: (context) => const SignInScreen(
  //         user: null,
  //       ),
  //   RoutesText.forgetPassword: (context) => const ForgetPasswordScreen(),
  //   RoutesText.register: (context) => const RegisterScreen(),
  //   RoutesText.home: (context) => HomeScreen(),
  //   RoutesText.addTask: (context) => const TodoAddScreen(),
  //   RoutesText.editTask: (context) => const TodoEditScreen(),
  // };

  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    late Widget page;
    final Uri uri = Uri.parse(settings.name ?? '');
    switch (uri.path) {
      case RoutesText.signIn:
        page = const SignInScreen(
          user: null,
        );
        break;
      case RoutesText.forgetPassword:
        page = const ForgetPasswordScreen();
        break;
      case RoutesText.register:
        page = const RegisterScreen();
        break;
      case RoutesText.home:
        page = HomeScreen();
        break;
      case RoutesText.addTask:
        page = const TodoAddScreen();
        break;
      case RoutesText.editTask:
        page = TodoEditScreen(
          id: int.tryParse(uri.queryParameters['id'] as String),
        );
        break;
      default:
        page = const ErrorScreen();
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
