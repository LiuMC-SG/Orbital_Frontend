import 'package:flutter/material.dart';

class AddModulesDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final Function() removeMod;
  final List<String> initialModules;
  final List<String> allModules;
  final String currModule;
  const AddModulesDialog({
    Key? key,
    required this.onAdd,
    required this.removeMod,
    required this.initialModules,
    required this.allModules,
    required this.currModule,
  }) : super(key: key);
  @override
  _AddModulesDialogState createState() => _AddModulesDialogState();
}

class _AddModulesDialogState extends State<AddModulesDialog> {
  var prereqModules = <String>[];
  var otherModules = <String>[];

  @override
  void initState() {
    super.initState();
    prereqModules.addAll(widget.initialModules);
    otherModules.addAll(widget.allModules);
    otherModules.remove(widget.currModule);
    otherModules
        .removeWhere((element) => widget.initialModules.contains(element));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Prerequisite'),
      content: dialogBody(),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                child: const Text('Remove Module'),
                onPressed: () {
                  widget.removeMod();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                child: const Text('Completed'),
                onPressed: () {
                  widget.onAdd(prereqModules);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

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

  void addModule(String module) {
    setState(() {
      prereqModules.add(module);
      otherModules.remove(module);
    });
  }

  void removeModule(String module) {
    setState(() {
      prereqModules.remove(module);
      otherModules.add(module);
    });
  }
}
