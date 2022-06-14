import 'package:flutter/material.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/widgets/multi_selection_dialog.dart';

// Labels selection dialog
class LabelsSelectionDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final List<String> initialLabels;
  final List<String> allLabels;
  const LabelsSelectionDialog({
    Key? key,
    required this.onAdd,
    required this.initialLabels,
    required this.allLabels,
  }) : super(key: key);
  @override
  LabelsSelectionDialogState createState() => LabelsSelectionDialogState();
}

class LabelsSelectionDialogState extends State<LabelsSelectionDialog> {
  Labels allLabels = Labels.blankLabels();

  @override
  void initState() {
    super.initState();
    allLabels.addLabels(widget.allLabels);
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectionDialog(
      onAdd: widget.onAdd,
      initialSelection: widget.initialLabels,
      allSelection: allLabels.toJson(),
      removedSelection: const [],
      currSelection: '',
      additionalSelection: const [],
      actions: const [],
      dialogTitle: 'Select labels',
    );
  }
}
