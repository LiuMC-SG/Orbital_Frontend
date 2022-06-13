import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/screens/todo/todo_data_screen.dart';

// Task edit screen
class TodoEditScreen extends StatefulWidget {
  final int? id;
  const TodoEditScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  @override
  TodoEditScreenState createState() => TodoEditScreenState();
}

class TodoEditScreenState extends State<TodoEditScreen> {
  Profile profile = Profile.blankProfile();
  late Todo todoTask;
  bool exist = true;
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = setInitial();
  }

  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    List<Todo> todoList =
        profile.todoList.where((element) => element.id == widget.id).toList();
    if (todoList.isEmpty) {
      setState(() {
        exist = false;
      });
    } else {
      setState(() {
        todoTask = todoList.first;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return body();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget body() {
    if (exist) {
      return TodoDataScreen(
        todoTask: todoTask,
        edit: true,
        labels: profile.labels,
        profile: profile,
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Edit todo task',
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: 'Back',
              );
            },
          ),
        ),
        body: const Center(
          child: Text('Task not found'),
        ),
      );
    }
  }
}
