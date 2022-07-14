import 'package:helpus/models/todo_data.dart';

class Calendar {
  List<Todo> todoList = [];

  // Generate iCalender
  String generateICalender() {
    String iCalender = 'BEGIN:VCALENDAR\n';
    iCalender += 'VERSION:2.0\n';
    iCalender += 'PRODID:-//HelpUS//To-do//EN\n';
    for (Todo todo in todoList) {
      iCalender += 'BEGIN:VEVENT\n';
      iCalender += 'UID:${todo.id}@helpus.com\n';
      iCalender += 'SUMMARY:${todo.title}\n';
      iCalender += 'DESCRIPTION:${todo.description}\n';
      iCalender += 'DTSTART:${todo.getDeadlineDate()}\n';
      iCalender += 'CATEGORIES:${todo.labels.getJoinedLabels()}\n';
      iCalender += 'END:VTODO\n';
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
