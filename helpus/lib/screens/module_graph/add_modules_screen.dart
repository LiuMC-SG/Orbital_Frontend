import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/models/module_data.dart';
import 'package:http/http.dart' as http;

class AddModulesScreen extends StatefulWidget {
  const AddModulesScreen({Key? key}) : super(key: key);
  @override
  _AddModulesScreenState createState() => _AddModulesScreenState();
}

class _AddModulesScreenState extends State<AddModulesScreen> {
  final TextEditingController _filter = TextEditingController();
  bool isInitialised = false;
  var searchedModules = <CondensedModule>[];
  var selectedModules = <CondensedModule, List<String>>{};
  late final List<CondensedModule> allModules;
  late DocumentReference documentReference;

  @override
  void initState() {
    super.initState();
    documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
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

  Future<List<CondensedModule>> fetchModules() async {
    http.Response response = await http.get(Uri.parse(
        'https://helpus-backend.herokuapp.com/modules/condensed_info'));
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body).runtimeType.toString());
      return jsonDecode(response.body)
          .map((element) => CondensedModule.fromJson(element))
          .toList()
          .cast<CondensedModule>();
    } else {
      throw Exception('Failed to load module info');
    }
  }

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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: const Text('Add Modules'),
                    onPressed: submitModules,
                  ),
                ),
              ),
              ListView.builder(
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
            ],
          ),
        ),
      ],
    );
  }

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

  Color getColor(int index) {
    if (selectedModules.keys.elementAt(index).prerequisite == '') {
      return Colors.green;
    }
    if (selectedModules.values.elementAt(index).isNotEmpty) {
      return Colors.green;
    }
    return Colors.red;
  }

  void changeSelectedModule(int index) {
    if (selectedModules.keys.elementAt(index).prerequisite != '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Prerequisite'),
            content: const Text('This module has a prerequisite'),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: const Text('Completed'),
                  onPressed: () {
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

  void submitModules() async {
    if (selectedModules.containsValue(false)) {
      Fluttertoast.showToast(msg: 'Not all Modules Perequisites are satisfied');
    } else {
      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, List<dynamic>> updatedGraphModel =
          documentSnapshot['graphModel'];
      debugPrint(updatedGraphModel.toString());
      final int? maxId = updatedGraphModel['nodes']?.fold(
          -1, (previousValue, element) => max(previousValue!, element['id']));

      documentReference.set(
        {'graphModel': updatedGraphModel},
        SetOptions(merge: true),
      );
    }
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }
}
