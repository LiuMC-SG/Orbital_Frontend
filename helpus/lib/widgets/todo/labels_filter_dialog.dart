import 'package:flutter/material.dart';
import 'package:helpus/models/todo_data.dart';

// Label filter dialog
class LabelFilterDialog extends StatefulWidget {
  final Function(String) addSelectedLabel;
  final Labels labels;
  const LabelFilterDialog({
    Key? key,
    required this.addSelectedLabel,
    required this.labels,
  }) : super(key: key);
  @override
  LabelFilterDialogState createState() => LabelFilterDialogState();
}

class LabelFilterDialogState extends State<LabelFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select label'),
      content: dialogBody(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  // Main dialog box body
  Widget dialogBody() {
    return SizedBox(
      width: 300,
      height: 300,
      child: ListView(
        children: widget.labels.labels.map((label) {
          return ListTile(
            title: Text(label),
            onTap: () {
              widget.addSelectedLabel(label);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
