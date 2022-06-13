import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/models/todo_data.dart';

// Task data screen
class TodoDataScreen extends StatefulWidget {
  final Todo todoTask;
  final bool edit;
  const TodoDataScreen({
    Key? key,
    required this.todoTask,
    required this.edit,
  }) : super(key: key);
  @override
  TodoDataScreenState createState() => TodoDataScreenState();
}

class TodoDataScreenState extends State<TodoDataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final currDate = DateTime.now();
  late DateTime deadline;
  late Labels labels;
  late bool completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoTask.title);
    _descriptionController =
        TextEditingController(text: widget.todoTask.description);
    deadline = DateTime.parse(widget.todoTask.deadline);
    labels = widget.todoTask.labels;
    completed = widget.todoTask.completed;
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  // Main display
  Widget body() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.edit ? 'Edit todo task' : 'Create new todo task',
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.edit
                        ? 'Edit your todo task'
                        : 'Create your new todo task',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Decription',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter your description';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(
                        16,
                      ),
                      child: Text('Deadline:'),
                    ),
                    GestureDetector(
                      onTap: showDateTimePicker,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Text(Todo.deadlineToString(deadline.toString())),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(
                        16,
                      ),
                      child: Text('Labels:'),
                    ),
                    GestureDetector(
                      onTap: showLabelPicker,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: const Text('Select Labels'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(
                        16,
                      ),
                      child: Text('Completed:'),
                    ),
                    Checkbox(
                      value: completed,
                      onChanged: (bool? value) {
                        setState(() {
                          completed = value!;
                        });
                      },
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: createTask,
                    child: Text(
                      widget.edit ? 'Edit task' : 'Create task',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Datetime picker
  void showDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: deadline,
      firstDate: DateTime(currDate.year - 10),
      lastDate: DateTime(currDate.year + 10),
      helpText: 'Select deadline',
    ).then(
      (yearValue) {
        if (yearValue == null) {
          return;
        }
        showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: deadline.hour,
                  minute: deadline.minute,
                ),
                helpText: 'Select time')
            .then(
          (timeValue) {
            if (timeValue == null) {
              return;
            }
            setState(() {
              deadline = DateTime(
                yearValue.year,
                yearValue.month,
                yearValue.day,
                timeValue.hour,
                timeValue.minute,
              );
            });
          },
        );
      },
    );
  }

  // Label picker
  void showLabelPicker() {}

  // Create new todo task
  void createTask() async {
    if (_formKey.currentState!.validate()) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      final mappedValue = Map<String, dynamic>.from(
          documentSnapshot.data() as Map<Object?, Object?>);

      // Update firestore todo tasks
      List<Todo> updatedTodoList = Todo.fromJsonList(mappedValue['todoList']);
      final int id;
      if (widget.edit) {
        id = widget.todoTask.id;
        updatedTodoList.removeWhere((todo) => todo.id == id);
      } else {
        id = Todo.getMaxId(updatedTodoList) + 1;
      }

      updatedTodoList.add(
        Todo(
          id,
          _titleController.text,
          _descriptionController.text,
          deadline.toString(),
          labels,
          completed,
        ),
      );

      await documentReference.set(
        {
          'todoList': updatedTodoList
              .map(
                (e) => e.toJson(),
              )
              .toList(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
    }
  }
}
