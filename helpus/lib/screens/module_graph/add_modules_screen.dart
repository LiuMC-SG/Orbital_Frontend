import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/module_data.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/widgets/add_modules_dialog.dart';
import 'package:http/http.dart' as http;

// Add module to module graph screen
class AddModulesScreen extends StatefulWidget {
  final Profile profile;
  const AddModulesScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);
  @override
  _AddModulesScreenState createState() => _AddModulesScreenState();
}

class _AddModulesScreenState extends State<AddModulesScreen> {
  final TextEditingController _filter = TextEditingController();
  bool isInitialised = false;
  var searchedModules = <CondensedModule>[];
  var selectedModules = <CondensedModule, List<String>>{};
  late final List<CondensedModule> allModules;
  late final List<String> currModules;

  // Obtain all modules from the database.
  @override
  void initState() {
    super.initState();

    List<String> nodeLabels =
        widget.profile.graphModel.nodes.map((e) => e.label).toList();
    nodeLabels.remove('master');
    currModules = nodeLabels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Modules',
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Back',
            );
          },
        ),
      ),
      body: addModule(),
    );
  }

  // Future builder for loading modules from database and displaying them.
  Widget addModule() {
    return FutureBuilder(
      future: fetchModules(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!isInitialised) {
            allModules = snapshot.data as List<CondensedModule>;
            searchedModules.addAll(allModules);
            isInitialised = true;
          }
          return generateScrollView();
        } else if (snapshot.hasError) {
          debugPrint('Error');
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Obtain all modules from the database and remove those already added to the
  // profile.
  Future<List<CondensedModule>> fetchModules() async {
    http.Response response = await http.get(
      Uri.parse('https://helpus-backend.herokuapp.com/modules/condensed_info'),
    );
    if (response.statusCode == 200) {
      List<CondensedModule> modules = jsonDecode(response.body)
          .map((element) => CondensedModule.fromJson(element))
          .toList()
          .cast<CondensedModule>();
      modules
          .removeWhere((element) => currModules.contains(element.moduleCode));
      return modules;
    } else {
      throw Exception('Failed to load module info');
    }
  }

  // Search field widget
  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      height: 40,
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

  // Main display widget. Left side has search field with all available modules.
  // Right side has selected modules.
  Widget generateScrollView() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedModules.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(
                          '${searchedModules[index].moduleCode}  ${searchedModules[index].title}'),
                      subtitle: Text(searchedModules[index].prerequisite),
                      onTap: () {
                        CondensedModule module = searchedModules[index];
                        if (!selectedModules.containsKey(module)) {
                          setState(() {
                            selectedModules[module] = <String>[];
                          });
                        }
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: const Text('Add Modules'),
                      onPressed: submitModules,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: const Text('Remove All'),
                      onPressed: removeAllModules,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedModules.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      tileColor: getColor(index),
                      title: Text(
                        selectedModules.keys.elementAt(index).moduleCode,
                      ),
                      onTap: () {
                        changeSelectedModule(index);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Search function to filter the list of modules
  void filterModules(String query) {
    List<CondensedModule> dummySearchList = <CondensedModule>[];
    dummySearchList.addAll(allModules);
    if (query.isNotEmpty) {
      List<CondensedModule> dummyListData = <CondensedModule>[];
      for (var item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        searchedModules.clear();
        searchedModules.addAll(dummyListData);
      });
    } else {
      setState(() {
        searchedModules.clear();
        searchedModules.addAll(allModules);
      });
    }
  }

  // Color of selected modules depending on whether it has prerequisites
  Color getColor(int index) {
    if (selectedModules.keys.elementAt(index).prerequisite == '') {
      return Colors.green;
    }
    if (selectedModules.values.elementAt(index).isNotEmpty) {
      return Colors.green;
    }
    return Colors.red;
  }

  // If the selected module has no prerequisites, then it prompts to remove the
  // selected module only. Otherwise, then it would prompt dialog to add
  // prerequisite to the module.
  void changeSelectedModule(int index) {
    if (selectedModules.keys.elementAt(index).prerequisite != '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddModulesDialog(
            onAdd: onAdd(index),
            removeMod: () {
              removeModule(index);
            },
            initialModules:
                selectedModules[selectedModules.keys.elementAt(index)] ??
                    <String>[],
            allModules: selectedModules.keys.map((e) => e.moduleCode).toList(),
            selectedModule: selectedModules.keys.elementAt(index).moduleCode,
            currModules: currModules,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Prerequisite'),
            content: const Text('This module has no prerequisite'),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: const Text('Remove Module'),
                  onPressed: () {
                    removeModule(index);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  // Add modules to the selected modules
  Function(List<String>?) onAdd(int index) {
    return (List<String>? modules) {
      setState(() {
        selectedModules[selectedModules.keys.elementAt(index)]?.clear();
        selectedModules[selectedModules.keys.elementAt(index)]
            ?.addAll(modules ?? <String>[]);
      });
    };
  }

  // Remove selected module and all other modules that depend on it
  void removeModule(int index) {
    CondensedModule module = selectedModules.keys.elementAt(index);
    setState(() {
      selectedModules.remove(module);
      selectedModules.forEach((key, value) {
        value.remove(module.moduleCode);
      });
    });
  }

  // Remove all selected modules
  void removeAllModules() {
    setState(() {
      selectedModules.clear();
    });
  }

  // Submit selected modules to the database. Each module is a node and edge is
  // from prereq module to the selected module.
  void submitModules() async {
    bool havePrerequisite = false;
    for (var i = 0; i < selectedModules.length; i++) {
      if (selectedModules.keys.elementAt(i).prerequisite != '' &&
          selectedModules.values.elementAt(i).isEmpty) {
        havePrerequisite = true;
      }
    }
    if (havePrerequisite) {
      Fluttertoast.showToast(msg: 'Not all Modules Perequisites are satisfied');
    } else {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      final mappedValue = Map<String, dynamic>.from(
          documentSnapshot.data() as Map<Object?, Object?>);

      // Update firestore graph model
      GraphModel updatedGraphModel = GraphModel(mappedValue['graphModel']);
      final int startId = updatedGraphModel.maxId() + 1;
      int counter = startId;
      for (var i = 0; i < selectedModules.length; i++) {
        String moduleCode = selectedModules.keys.elementAt(i).moduleCode;
        if (updatedGraphModel.getNodeId(moduleCode) == -1) {
          updatedGraphModel.addNode(GraphNode(
            counter,
            selectedModules.keys.elementAt(i).moduleCode,
          ));
          counter++;
        }
      }
      for (var i = 0; i < selectedModules.length; i++) {
        for (var prereq in selectedModules.values.elementAt(i)) {
          if (prereq != 'master') {
            updatedGraphModel.addEdge(GraphEdge(
              updatedGraphModel.getNodeId(prereq),
              updatedGraphModel
                  .getNodeId(selectedModules.keys.elementAt(i).moduleCode),
            ));
          }
        }
      }
      documentReference.set(
        {'graphModel': updatedGraphModel.toJson()},
        SetOptions(merge: true),
      );
      widget.profile.graphModel = updatedGraphModel;

      // Update firestore moduleGrading
      List<ModuleGrading> updatedModuleGrading = mappedValue['moduleGrading']
          .map<ModuleGrading>((e) => ModuleGrading.fromJson(e))
          .toList();
      List<String> updatedModuleGradingString =
          updatedModuleGrading.map((e) => e.moduleCode).toList();
      for (var module in selectedModules.keys) {
        if (!updatedModuleGradingString.contains(module.moduleCode)) {
          updatedModuleGrading.add(ModuleGrading(
            module.moduleCode,
            allModules
                .where((element) => element.moduleCode == module.moduleCode)
                .first
                .mc,
            '',
            false,
          ));
        }
      }
      documentReference.set(
        {
          'moduleGrading': updatedModuleGrading
              .map(
                (e) => e.toJson(),
              )
              .toList()
        },
        SetOptions(merge: true),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }
}
