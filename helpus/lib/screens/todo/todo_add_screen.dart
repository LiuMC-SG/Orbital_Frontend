import 'package:flutter/material.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/screens/todo/todo_data_screen.dart';

// Task add screen
class TodoAddScreen extends StatefulWidget {
  const TodoAddScreen({Key? key}) : super(key: key);
  @override
  TodoAddScreenState createState() => TodoAddScreenState();
}

class TodoAddScreenState extends State<TodoAddScreen> {
  @override
  Widget build(BuildContext context) {
    return TodoDataScreen(
      todoTask: Todo.blankTodo(),
      edit: false,
    );
  }
}
