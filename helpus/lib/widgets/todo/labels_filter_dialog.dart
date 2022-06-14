import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/widgets/todo/add_labels_dialog.dart';
import 'package:helpus/widgets/todo/remove_labels_dialog.dart';

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
  late Labels labels;

  @override
  void initState() {
    super.initState();
    labels = widget.labels;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select label'),
      content: dialogBody(),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          child: const Text('Add Label'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddLabelDialog(
                  addLabel: addLabel,
                );
              },
            );
          },
        ),
        TextButton(
          child: const Text('Remove Labels'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LabelsRemovalDialog(
                  allLabels: labels.labels,
                  onRemove: removeLabel,
                );
              },
            );
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
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

  // Add label to firestore
  void addLabel(String label) async {
    setState(() {
      labels.addLabel(label);
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await documentReference.set(
      {
        'labels': labels.toJson(),
      },
      SetOptions(merge: true),
    );
  }

  // Remove label from firestore
  void removeLabel(List<String>? labelList) async {
    setState(() {
      labels.removeLabels(labelList);
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await documentReference.set(
      {
        'labels': labels.toJson(),
      },
      SetOptions(merge: true),
    );
  }
}
