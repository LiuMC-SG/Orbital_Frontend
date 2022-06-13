import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/screens/todo/todo_data_screen.dart';

// Task add screen
class TodoAddScreen extends StatefulWidget {
  const TodoAddScreen({Key? key}) : super(key: key);
  @override
  TodoAddScreenState createState() => TodoAddScreenState();
}

class TodoAddScreenState extends State<TodoAddScreen> {
  Profile profile = Profile.blankProfile();
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = setInitial();
  }

  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TodoDataScreen(
            todoTask: Todo.blankTodo(),
            edit: false,
            labels: profile.labels,
            profile: profile,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
