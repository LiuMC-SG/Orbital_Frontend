import 'package:helpus/models/todo_data.dart';

class Calendar {
  List<Todo> todoList = [];

  // Generate iCalender
  String generateICalender() {
    String iCalender = 'BEGIN:VCALENDAR\n';
    iCalender += 'VERSION:2.0\n';
    iCalender += 'PRODID:-//HelpUS//To-do//EN\n';
    String currTime = DateTime.now()
        .toUtc()
        .toIso8601String()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll(RegExp(r'\.\d\d\dZ'), 'Z');
    for (Todo todo in todoList) {
      iCalender += 'BEGIN:VEVENT\n';
      iCalender += 'UID:${todo.id}@helpus.com\n';
      iCalender += 'DTSTAMP:$currTime\n';
      iCalender += 'SUMMARY:${todo.title}\n';
      iCalender += 'DESCRIPTION:${todo.description}\n';
      iCalender += 'DTSTART:${todo.getDeadlineDate()}\n';
      iCalender += 'CATEGORIES:${todo.labels.getJoinedLabels()}\n';
      iCalender += 'END:VEVENT\n';
    }
    iCalender += 'END:VCALENDAR\n';
    return iCalender;
  }

  // Add todo
  void addTodo(Todo todo) {
    todoList.add(todo);
  }

  // Add todo list
  void addTodoList(List<Todo> todoList) {
    this.todoList.addAll(todoList);
  }
}
