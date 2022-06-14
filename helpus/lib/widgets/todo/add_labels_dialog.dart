import 'package:flutter/material.dart';

// Add label dialog
class AddLabelDialog extends StatefulWidget {
  final Function(String) addLabel;
  const AddLabelDialog({
    Key? key,
    required this.addLabel,
  }) : super(key: key);
  @override
  AddLabelDialogState createState() => AddLabelDialogState();
}

class AddLabelDialogState extends State<AddLabelDialog> {
  final TextEditingController _labelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New label'),
      content: dialogBody(),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            widget.addLabel(_labelController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Main dialog box body
  Widget dialogBody() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: _labelController,
        decoration: const InputDecoration(
          hintText: 'Label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
