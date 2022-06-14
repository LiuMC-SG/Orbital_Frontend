import 'package:flutter/material.dart';
import 'package:helpus/models/todo_data.dart';

// Labels removal dialog
class LabelsRemovalDialog extends StatefulWidget {
  final Function(List<String>?) onRemove;
  final List<String> allLabels;
  const LabelsRemovalDialog({
    Key? key,
    required this.onRemove,
    required this.allLabels,
  }) : super(key: key);
  @override
  LabelsRemovalDialogState createState() => LabelsRemovalDialogState();
}

class LabelsRemovalDialogState extends State<LabelsRemovalDialog> {
  Labels allLabels = Labels.blankLabels();
  List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    allLabels.addLabels(widget.allLabels);
    selected.addAll(widget.allLabels.map((_) => false));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove labels'),
      content: SingleChildScrollView(
        child: ListBody(
          children: labelSelection(),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: removeSelected,
          child: const Text('Remove'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  // Generate all labels as checkboxes
  List<Widget> labelSelection() {
    List<Widget> temp = [];
    for (int i = 0; i < allLabels.labels.length; i++) {
      temp.add(
        CheckboxListTile(
          title: Text(allLabels.labels[i]),
          value: selected[i],
          onChanged: (bool? value) {
            setState(() {
              selected[i] = value!;
            });
          },
        ),
      );
    }
    return temp;
  }

  // Remove all labels that are checked
  void removeSelected() {
    List<String> temp = [];
    for (int i = 0; i < allLabels.labels.length; i++) {
      if (selected[i]) {
        temp.add(allLabels.labels[i]);
      }
    }
    widget.onRemove(temp);
    Navigator.pop(context);
  }
}
