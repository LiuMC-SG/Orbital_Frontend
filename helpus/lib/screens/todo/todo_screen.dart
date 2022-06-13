import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/todo/labels_filter_dialog.dart';

// Task screen
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);
  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final TextEditingController _filter = TextEditingController();
  Profile profile = Profile.blankProfile();
  List<Todo> todoList = [];
  List<Todo> filteredList = [];
  List<bool> selectedTask = [];
  bool allSelected = false;
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = setInitial();
  }

  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    setState(() {
      todoList.clear();
      todoList = profile.todoList;
      filteredList.clear();
      filteredList.addAll(todoList);
      selectedTask.clear();
      selectedTask.addAll(todoList.map((_) => false));
      _filter.text = '';
    });
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

  // Search field widget
  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          filterModules(value);
        },
        controller: _filter,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  // Search function to filter the list of todo tasks
  void filterModules(String query) {
    List<Todo> dummySearchList = <Todo>[];
    dummySearchList.addAll(todoList);
    if (query.isNotEmpty) {
      List<Todo> dummyListData = <Todo>[];
      for (Todo item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredList.clear();
        filteredList.addAll(dummyListData);
        selectedTask.clear();
        selectedTask.addAll(filteredList.map((_) => false));
        allSelected = false;
      });
    } else {
      setState(() {
        filteredList.clear();
        filteredList.addAll(todoList);
        selectedTask.clear();
        selectedTask.addAll(todoList.map((_) => false));
        allSelected = false;
      });
    }
  }

  // Update todo list info
  void updateModuleInfo() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    documentReference.set(
      {'todoList': todoList.map((e) => e.toJson())},
      SetOptions(merge: true),
    );
  }

  // Main body of diplaying all todo tasks
  Widget body() {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: buildSearch(),
            ),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LabelFilterDialog(
                      addSelectedLabel: addSelectedLabel,
                      labels: profile.labels,
                    );
                  },
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.local_offer_rounded),
                  Text('Labels'),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesText.addTask,
                  ).then((value) {
                    setState(() {
                      _future = setInitial();
                    });
                  });
                },
                child: const Text('Add Task'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  deleteTasks();
                },
                child: const Text('Delete Tasks'),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            color: Colors.black,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: [
              DataTable(
                columns: createColumnInitial(),
                rows: createRowInitial(),
                columnSpacing: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: createColumnExtra(),
                    rows: createRowExtra(),
                    columnSpacing: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add selected label to the filter
  void addSelectedLabel(String label) {
    setState(() {
      _filter.text = '${_filter.text} label:$label';
      filterModules(_filter.text);
    });
  }

  // Change overall selection
  void changeSelection() {
    bool newValue = !allSelected;
    setState(() {
      allSelected = newValue;
      selectedTask.clear();
      selectedTask.addAll(filteredList.map((_) => newValue));
    });
  }

  // Check if all of the tasks are selected
  void checkSelection() {
    bool newValue = true;
    for (bool val in selectedTask) {
      if (!val) {
        newValue = false;
        break;
      }
    }
    setState(() {
      allSelected = newValue;
    });
  }

  // Obtain selected icon
  IconData getIconData(int index) {
    if (index == -1) {
      if (allSelected) {
        return Icons.check_box;
      } else if (selectedTask.contains(true)) {
        return Icons.indeterminate_check_box_rounded;
      } else {
        return Icons.check_box_outline_blank;
      }
    } else {
      if (selectedTask[index]) {
        return Icons.check_box;
      } else {
        return Icons.check_box_outline_blank;
      }
    }
  }

  // Delete selected tasks
  void deleteTasks() async {
    List<Todo> selectedList = [];
    for (int i = 0; i < selectedTask.length; i++) {
      if (selectedTask[i]) {
        selectedList.add(filteredList[i]);
      }
    }
    setState(() {
      filteredList.removeWhere((element) => selectedList.contains(element));
      todoList.removeWhere((element) => selectedList.contains(element));
      selectedTask.clear();
      selectedTask.addAll(filteredList.map((_) => false));
      allSelected = false;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await documentReference.set(
      {
        'todoList': todoList
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      },
      SetOptions(merge: true),
    );
  }

  // Create initial column for DataTable
  List<DataColumn> createColumnInitial() {
    return <DataColumn>[
      DataColumn(
        label: Center(
          child: IconButton(
            icon: Icon(getIconData(-1)),
            onPressed: () {
              changeSelection();
            },
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'Task',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  // Create extra column for DataTable
  List<DataColumn> createColumnExtra() {
    return <DataColumn>[
      const DataColumn(
        label: Expanded(
          child: Text(
            'Deadline',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'Completion Status',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'Labels',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'Edit',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  // Create initial row for DataTable
  List<DataRow> createRowInitial() {
    return filteredList
        .asMap()
        .map(
          (index, module) => MapEntry(
            index,
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Center(
                    child: IconButton(
                      icon: Icon(getIconData(index)),
                      onPressed: () {
                        setState(() {
                          selectedTask[index] = !selectedTask[index];
                          checkSelection();
                        });
                      },
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredList[index].title),
                      Text(
                        filteredList[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }

  // Create row for DataTable
  List<DataRow> createRowExtra() {
    return filteredList
        .asMap()
        .map(
          (index, module) => MapEntry(
            index,
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    Todo.deadlineToString(filteredList[index].deadline),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Center(
                    child: Checkbox(
                      value: filteredList[index].completed,
                      onChanged: (bool? value) {
                        setState(() {
                          filteredList[index].changeCompletion();
                          updateModuleInfo();
                        });
                      },
                    ),
                  ),
                ),
                DataCell(
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: filteredList[index].labels.map((e) {
                      return Chip(
                        label: Text(e),
                      );
                    }).cast<Widget>(),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    splashRadius: 20,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit_task?id=${filteredList[index].id}',
                      ).then((value) {
                        setState(() {
                          _future = setInitial();
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }
}
