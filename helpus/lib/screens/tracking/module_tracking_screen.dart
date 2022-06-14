import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/module_data.dart';
import 'package:helpus/models/profile_data.dart';

// Module tracking screen
class ModuleTrackingScreen extends StatefulWidget {
  const ModuleTrackingScreen({Key? key}) : super(key: key);
  @override
  ModuleTrackingScreenState createState() => ModuleTrackingScreenState();
}

class ModuleTrackingScreenState extends State<ModuleTrackingScreen> {
  Profile profile = Profile.blankProfile();
  late List<String> moduleInfo;
  late List<ModuleGrading> moduleGrading;
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = setInitial();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return moduleTrackingWidget();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Obtain profile information from firestore.
  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    setState(() {
      moduleInfo = ModuleGrading.calcModules(profile.moduleGrading);
      moduleGrading = profile.moduleGrading;
    });
    return true;
  }

  // Update module info
  void updateModuleInfo() {
    setState(() {
      moduleInfo = ModuleGrading.calcModules(moduleGrading);
    });
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    documentReference.set(
      {'moduleGrading': moduleGrading.map((e) => e.toJson())},
      SetOptions(merge: true),
    );
  }

  // Main display
  Widget moduleTrackingWidget() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Total MC: ${moduleInfo[2]}'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Included MC: ${moduleInfo[1]}'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('CAP: ${moduleInfo[0]}'),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            color: Colors.black,
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: createColumn(),
              rows: createRow(),
              columnSpacing: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Create column for DataTable
  List<DataColumn> createColumn() {
    return const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'Module Code',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'MC',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Grade',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'S/U',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  // Create row for DataTable
  List<DataRow> createRow() {
    return moduleGrading
        .asMap()
        .map(
          (index, module) => MapEntry(
            index,
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Center(
                    child: Text(
                      moduleGrading[index].moduleCode,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      moduleGrading[index].mc.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: DropdownButton<String>(
                      items: ModuleGrading.grades
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          moduleGrading[index].grade = value!;
                          updateModuleInfo();
                        });
                      },
                      value: moduleGrading[index].grade,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Checkbox(
                      value: moduleGrading[index].isSU,
                      onChanged: (bool? value) {
                        setState(() {
                          moduleGrading[index].changeSU();
                          updateModuleInfo();
                        });
                      },
                    ),
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
