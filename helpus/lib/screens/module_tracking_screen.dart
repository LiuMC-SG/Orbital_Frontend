import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/module_data.dart';
import 'package:helpus/models/profile_data.dart';

// Module tracking screen
class ModuleTrackingScreen extends StatefulWidget {
  const ModuleTrackingScreen({Key? key}) : super(key: key);
  @override
  _ModuleTrackingScreenState createState() => _ModuleTrackingScreenState();
}

class _ModuleTrackingScreenState extends State<ModuleTrackingScreen> {
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
              child: Text('Total MC: ${moduleInfo[1]}'),
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
          ),
        ),
        Expanded(
          child: DataTable(
            columns: createColumn(),
            rows: createRow(),
          ),
        ),
      ],
    );
  }

  // Create column for DataTable
  List<DataColumn> createColumn() {
    return <DataColumn>[
      DataColumn(
        label: Container(
          child: const Text(
            'Module Code',
          ),
          alignment: Alignment.center,
        ),
      ),
      DataColumn(
        label: Container(
          child: const Text(
            'MC',
          ),
          alignment: Alignment.center,
        ),
      ),
      DataColumn(
        label: Container(
          child: const Text(
            'Grade',
          ),
          alignment: Alignment.center,
        ),
      ),
      DataColumn(
          label: Container(
        child: const Text(
          'S/U',
        ),
        alignment: Alignment.center,
      )),
    ];
  }

  // Create row for DataTable
  List<DataRow> createRow() {
    List<DataRow> tempRow = [];
    for (int i = 0; i < moduleGrading.length; i++) {
      tempRow.add(DataRow(
        cells: <DataCell>[
          DataCell(
            Container(
              child: Text(
                moduleGrading[i].moduleCode,
              ),
              alignment: Alignment.center,
            ),
          ),
          DataCell(
            Container(
              child: Text(
                moduleGrading[i].mc.toString(),
              ),
              alignment: Alignment.center,
            ),
          ),
          DataCell(
            Container(
              child: DropdownButton<String>(
                items: ModuleGrading.grades
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    moduleGrading[i].grade = value!;
                    updateModuleInfo();
                  });
                },
                value: moduleGrading[i].grade,
              ),
              alignment: Alignment.center,
            ),
          ),
          DataCell(
            Container(
              child: Checkbox(
                value: moduleGrading[i].isSU,
                onChanged: (bool? value) {
                  setState(() {
                    moduleGrading[i].changeSU();
                    updateModuleInfo();
                  });
                },
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ));
    }
    return tempRow;
  }
}
