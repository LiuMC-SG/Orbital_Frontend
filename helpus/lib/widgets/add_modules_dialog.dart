import 'package:flutter/material.dart';

// Add module dialog
class AddModulesDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final Function() removeMod;
  final List<String> initialModules;
  final List<String> allModules;
  final String selectedModule;
  final List<String> currModules;
  const AddModulesDialog({
    Key? key,
    required this.onAdd,
    required this.removeMod,
    required this.initialModules,
    required this.allModules,
    required this.selectedModule,
    required this.currModules,
  }) : super(key: key);
  @override
  AddModulesDialogState createState() => AddModulesDialogState();
}

class AddModulesDialogState extends State<AddModulesDialog> {
  var prereqModules = <String>[];
  var otherModules = <String>[];

  // Initialise the lists of prereq modules already added and modules not added
  // in
  @override
  void initState() {
    super.initState();

    prereqModules.addAll(widget.initialModules);
    prereqModules.remove('master');

    otherModules.addAll(widget.allModules);
    otherModules.addAll(widget.currModules);
    otherModules.remove(widget.selectedModule);
    otherModules
        .removeWhere((element) => widget.initialModules.contains(element));

    prereqModules.sort();
    otherModules.sort();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Prerequisite'),
      content: dialogBody(),
      actions: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextButton(
                child: const Text('Remove Module'),
                onPressed: () {
                  widget.removeMod();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextButton(
                child: const Text('Completed'),
                onPressed: () {
                  widget.onAdd(prereqModules);
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextButton(
                child: const Text('Waive Prereq'),
                onPressed: () {
                  widget.onAdd(['master']);
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextButton(
                child: const Text('Clear Prereq'),
                onPressed: () {
                  widget.onAdd(<String>[]);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Main dialog box body
  Widget dialogBody() {
    return SizedBox(
      width: 300,
      height: 300,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: otherModules.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    otherModules[index],
                  ),
                  onTap: () {
                    addModule(otherModules[index]);
                  },
                );
              }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.compare_arrows_rounded),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: prereqModules.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    prereqModules[index],
                  ),
                  onTap: () {
                    removeModule(prereqModules[index]);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Adds a module to the prereq list
  void addModule(String module) {
    setState(() {
      prereqModules.add(module);
      otherModules.remove(module);

      prereqModules.sort();
    });
  }

  // Remove module in prereq list
  void removeModule(String module) {
    setState(() {
      prereqModules.remove(module);
      otherModules.add(module);

      otherModules.sort();
    });
  }
}
