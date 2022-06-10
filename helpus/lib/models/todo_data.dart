// Class to track todo data
class Todo {
  String title;
  String description;
  String deadline;
  List<String> labels;
  bool completed;

  Todo(
    this.title,
    this.description,
    this.deadline,
    this.labels,
    this.completed,
  );

  @override
  String toString() {
    String titleString = 'title: $title';
    String descriptionString = 'description: $description';
    String deadlineString = 'deadline: $deadline';
    String labelsString = 'labels: $labels';
    String completedString = 'completed: $completed';
    return [
      titleString,
      descriptionString,
      deadlineString,
      labelsString,
      completedString,
    ].join(', ');
  }

  // Check if a task is overdue
  bool isOverdue() {
    DateTime deadlineDate = DateTime.parse(deadline);
    DateTime now = DateTime.now();
    return deadlineDate.isBefore(now);
  }

  // Change completion status
  void changeCompletion() {
    completed = !completed;
  }

  // Generate todo task from json data
  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
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