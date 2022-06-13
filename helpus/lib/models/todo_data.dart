import 'dart:math';

import 'package:intl/intl.dart';

// Class to track todo data
class Todo {
  int id;
  String title;
  String description;
  String deadline;
  Labels labels;
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
      Labels.blankLabels(),
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
      Labels.fromJson(json['labels']),
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
      'labels': labels.toJson(),
      'completed': completed,
    };
  }

  // Check if title or description contain query
  bool checkTitleDescription(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        description.toLowerCase().contains(query.toLowerCase());
  }

  // Check if the todo task contains the query text
  bool contains(String query) {
    List<String> querySplit = query.toLowerCase().split(' ');
    List<String> queryList = [];
    List<String> dummyList = [];
    for (String queryWord in querySplit) {
      if (queryWord.contains('label:')) {
        queryList.add(queryWord);
        queryList.add(dummyList.join(' '));
        dummyList.clear();
      } else {
        dummyList.add(queryWord);
      }
    }
    queryList.add(dummyList.join(' '));
    for (String query in queryList) {
      if (query.contains('label:')) {
        String label = query.replaceAll('label:', '');
        if (!labels.contains(label)) {
          return false;
        }
      } else {
        if (!checkTitleDescription(query)) {
          return false;
        }
      }
    }
    return true;
  }
}

class Labels {
  List<String> labels;

  static List<String> defaultTags = [
    'Exam',
    'Assignment',
    'Tutorial',
  ];

  static Labels blankLabels() {
    return Labels(defaultTags);
  }

  Labels(this.labels);

  // Generate tags from json data
  static Labels fromJson(List<dynamic>? json) {
    if (json == null) {
      return Labels.blankLabels();
    }
    return Labels(
      json.cast<String>(),
    );
  }

  // Generate json data from tags
  List<String> toJson() {
    return labels;
  }

  // Add new label if it does not already exist in the current list
  void addLabel(String newLabel) {
    if (!labels.contains(newLabel)) {
      labels.add(newLabel);
    }
  }

  // Add labels in the list if they do not already exist in the current list
  void addLabels(List<String> newLabels) {
    for (String newLabel in newLabels) {
      addLabel(newLabel);
    }
  }

  // Map over each element
  List<dynamic> map(Function(String) function) {
    return labels.map(function).toList();
  }

  // Check if the list contains the query
  bool contains(String query) {
    return labels.contains(query);
  }

  @override
  String toString() {
    return labels.toString();
  }
}
