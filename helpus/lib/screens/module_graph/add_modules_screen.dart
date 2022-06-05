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
  Modules searchedModules = Modules([]);
  late Modules allModules;
  late Future<Modules> futureModules;
  late DocumentReference documentReference;
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    _filter.addListener(filterModules);
    futureModules = fetchModules();
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
      future: futureModules,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allModules = snapshot.data as Modules;
          searchedModules = allModules;
          return generateScrollView();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Future<Modules> fetchModules() async {
    http.Response response = await http
        .get(Uri.parse('http://127.0.0.1:8000/modules/condensed_info'));

    if (response.statusCode == 200) {
      return Modules.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load module info');
    }
  }

  Widget buildModule(CondensedModule module) {
    return ListTile(
      title: Text('${module.moduleCode}  ${module.title}'),
      subtitle: Text(module.prerequisite),
    );
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      height: 40,
      child: TextField(
        controller: _filter,
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded),
          hintText: 'Search Modules by Module Code',
        ),
      ),
    );
  }

  Widget generateScrollView() {
    return Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: searchedModules.length(),
            itemBuilder: ((context, index) {
              return buildModule(searchedModules.get(index));
            }),
          ),
        ),
      ],
    );
  }

  void filterModules() {
    setState(() {
      searchedModules = allModules.filter(_filter.text);
    });
    debugPrint(searchedModules.toString());
    debugPrint('Called');
  }

  void debounce() {
    debouncer?.cancel();
    debouncer = Timer(
      const Duration(milliseconds: 1000),
      filterModules,
    );
  }

  @override
  void dispose() {
    _filter.dispose();
    debouncer?.cancel();
    super.dispose();
  }
}
