import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      children: [
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
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const Text('Test'),
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

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }
}
