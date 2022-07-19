import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/screens/error_screen.dart';
import 'package:helpus/screens/home_screen.dart';
import 'package:helpus/screens/module_graph/module_graph_screen.dart';
import 'package:helpus/screens/profile/profile_screen.dart';
import 'package:helpus/screens/sign_in/register_screen.dart';
import 'package:helpus/screens/sign_in/sign_in_screen.dart';
import 'package:helpus/screens/todo/todo_add_screen.dart';
import 'package:helpus/screens/todo/todo_edit_screen.dart';
import 'package:helpus/screens/todo/todo_screen.dart';
import 'package:helpus/screens/tracking/module_tracking_screen.dart';
import 'package:helpus/utilities/constants.dart';

// Routes url and equivalent screens
class Routes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    late Widget page;
    late bool requireUser;
    final Uri uri = Uri.parse(settings.name ?? '');
    switch (uri.path) {
      case RoutesText.signIn:
        page = const SignInScreen();
        requireUser = false;
        break;
      case RoutesText.register:
        page = const RegisterScreen();
        requireUser = false;
        break;
      case RoutesText.home:
        page = HomeScreen();
        requireUser = true;
        break;
      case RoutesText.profile:
        page = const ProfileScreen();
        requireUser = true;
        break;
      case RoutesText.moduleGraph:
        page = const ModuleGraphScreen();
        requireUser = true;
        break;
      case RoutesText.moduleTracking:
        page = const ModuleTrackingScreen();
        requireUser = true;
        break;
      case RoutesText.todo:
        page = const TodoScreen();
        requireUser = true;
        break;
      case RoutesText.addTask:
        page = const TodoAddScreen();
        requireUser = true;
        break;
      case RoutesText.editTask:
        page = TodoEditScreen(
          id: int.tryParse(uri.queryParameters['id'] as String),
        );
        requireUser = true;
        break;
      default:
        page = const ErrorScreen();
        requireUser = false;
    }

    if (requireUser) {
      return checkUser(page, settings);
    } else {
      return createRoute(page, settings);
    }
  }

  // Checks if the user is logged in. If logged in, go to screen. Otherwise,
  // redirect to signin screen
  static MaterialPageRoute checkUser(Widget page, RouteSettings settings) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return createRoute(
        const SignInScreen(),
        RouteSettings(
          name: RoutesText.signIn,
          arguments: settings.arguments,
        ),
      );
    } else {
      return createRoute(page, settings);
    }
  }

  // Create route
  static MaterialPageRoute createRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
