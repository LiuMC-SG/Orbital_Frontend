import 'package:flutter/material.dart';

// Multi selection dialog
class MultiSelectionDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final List<String> initialSelection;
  final List<String> allSelection;
  final List<String> removedSelection;
  final List<String> additionalSelection;
  final String currSelection;
  final List<Widget> actions;
  final String dialogTitle;
  const MultiSelectionDialog({
    Key? key,
    required this.onAdd,
    required this.initialSelection,
    required this.allSelection,
    required this.removedSelection,
    required this.additionalSelection,
    required this.currSelection,
    required this.actions,
    required this.dialogTitle,
  }) : super(key: key);
  @override
  MultiSelectionDialogState createState() => MultiSelectionDialogState();
}

class MultiSelectionDialogState extends State<MultiSelectionDialog> {
  var addedSelection = <String>[];
  var otherSelection = <String>[];
  List<Widget> actions = <Widget>[];

  // Initialise the lists of prereq modules already added and modules not added
  // in
  @override
  void initState() {
    super.initState();

    addedSelection.addAll(widget.initialSelection);
    addedSelection
        .removeWhere((element) => widget.removedSelection.contains(element));

    otherSelection.addAll(widget.allSelection);
    otherSelection.addAll(widget.additionalSelection);
    otherSelection.remove(widget.currSelection);
    otherSelection
        .removeWhere((element) => widget.initialSelection.contains(element));

    addedSelection.sort();
    otherSelection.sort();

    actions.addAll([
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextButton(
          child: const Text('Complete'),
          onPressed: () {
            widget.onAdd(addedSelection);
            Navigator.of(context).pop();
          },
        ),
      ),
    ]);
    actions.addAll(widget.actions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: dialogBody(),
      actions: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceEvenly,
          children: actions,
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
              itemCount: otherSelection.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    otherSelection[index],
                  ),
                  onTap: () {
                    addSelection(otherSelection[index]);
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
              itemCount: addedSelection.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    addedSelection[index],
                  ),
                  onTap: () {
                    removeSelection(addedSelection[index]);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Adds a selection to the prereq list
  void addSelection(String selection) {
    setState(() {
      addedSelection.add(selection);
      otherSelection.remove(selection);

      addedSelection.sort();
    });
  }

  // Remove selection in prereq list
  void removeSelection(String selection) {
    setState(() {
      addedSelection.remove(selection);
      otherSelection.add(selection);

      otherSelection.sort();
    });
  }
}
