import 'package:flutter/material.dart';
import 'package:helpus/widgets/multi_selection_dialog.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiSelectionDialog(
      onAdd: widget.onAdd,
      initialSelection: widget.initialModules,
      allSelection: widget.allModules,
      removedSelection: const ['master'],
      currSelection: widget.selectedModule,
      additionalSelection: widget.currModules,
      actions: [
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
      dialogTitle: 'Select Prerequisite',
    );
  }
}
