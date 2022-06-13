import 'package:flutter/material.dart';
import 'package:helpus/widgets/multi_selection_dialog.dart';

// Labels selection dialog
class LabelsSelectionDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final List<String> initialLabels;
  final List<String> allModules;
  const LabelsSelectionDialog({
    Key? key,
    required this.onAdd,
    required this.initialLabels,
    required this.allModules,
  }) : super(key: key);
  @override
  LabelsSelectionDialogState createState() => LabelsSelectionDialogState();
}

class LabelsSelectionDialogState extends State<LabelsSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return MultiSelectionDialog(
      onAdd: widget.onAdd,
      initialSelection: widget.initialLabels,
      allSelection: widget.allModules,
      removedSelection: const [],
      currSelection: '',
      additionalSelection: const [],
      actions: const [],
      dialogTitle: 'Select labels',
    );
  }
}
