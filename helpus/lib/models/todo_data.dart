// Class to track todo data
import 'dart:math';

import 'package:intl/intl.dart';

class Todo {
  int id;
  String title;
  String description;
  String deadline;
  List<String> labels;
  bool completed;

  Todo(
    this.id,
    this.title,
    this.description,
    this.deadline,
    this.labels,
    this.completed,
  );

  @override
  String toString() {
    String idString = 'id: $id';
    String titleString = 'title: $title';
    String descriptionString = 'description: $description';
    String deadlineString = 'deadline: $deadline';
    String labelsString = 'labels: $labels';
    String completedString = 'completed: $completed';
    return [
      idString,
      titleString,
      descriptionString,
      deadlineString,
      labelsString,
      completedString,
    ].join(', ');
  }

  // Generate blank todo
  static Todo blankTodo() {
    return Todo(
      0,
      '',
      '',
      DateTime.now().toString(),
      [],
      false,
    );
  }

  // Check if a task is overdue
  bool isOverdue() {
    DateTime deadlineDate = DateTime.parse(deadline);
    DateTime now = DateTime.now();
    return deadlineDate.isBefore(now);
  }

  // Deadline to string
  static String deadlineToString(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(dateTime));
  }

  // Change completion status
  void changeCompletion() {
    completed = !completed;
  }

  // Obtain id
  static int getMaxId(List<Todo> todoList) {
    if (todoList.isEmpty) {
      return -1;
    } else {
      return todoList.map((todo) => todo.id).reduce((a, b) => max(a, b));
    }
  }

  // Generate todo task from json data
  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      json['id'],
      json['title'],
      json['description'],
      json['deadline'],
      json['labels']?.cast<String>(),
      json['completed'],
    );
  }

  // Generate todo list from json data
  static List<Todo> fromJsonList(List<dynamic>? json) {
    if (json == null) {
      return [];
    }
    return json.map((e) => Todo.fromJson(e)).toList().cast<Todo>();
  }

  // Generate json data from todo task
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'labels': labels,
      'completed': completed,
    };
  }

  // Check if the todo task contains the query text
  bool contains(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        description.toLowerCase().contains(query.toLowerCase());
  }

  // Check if todo contains query tags
  bool containsTags(List<String> queryTags) {
    List<String> queryLower =
        queryTags.map((String s) => s.toLowerCase()).toList();
    List<String> labelsLower =
        labels.map((String s) => s.toLowerCase()).toList();
    for (String query in queryLower) {
      if (!labelsLower.contains(query)) {
        return false;
      }
    }
    return true;
  }
}
