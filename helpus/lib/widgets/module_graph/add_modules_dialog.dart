import 'package:flutter/material.dart';

// Add module dialog
class AddModulesDialog extends StatefulWidget {
  final Function(List<String>?) onAdd;
  final Function removeMod;
  final List<String> selectedModules;
  final List<String> allModules;
  final String currModule;
  final String prerequisite;
  const AddModulesDialog({
    Key? key,
    required this.onAdd,
    required this.removeMod,
    required this.selectedModules,
    required this.allModules,
    required this.currModule,
    required this.prerequisite,
  }) : super(key: key);
  @override
  AddModulesDialogState createState() => AddModulesDialogState();
}

class AddModulesDialogState extends State<AddModulesDialog> {
  final TextEditingController _filter = TextEditingController();
  List<String> allModules = [];
  List<String> filteredList = [];
  Map<String, bool> selectedModules = {};
  bool allSelected = false;

  // Initialise the lists of prereq modules already added and modules not added
  // in
  @override
  void initState() {
    super.initState();

    allModules.addAll(widget.allModules);
    allModules.remove(widget.currModule);
    allModules.sort();

    for (String module in allModules) {
      if (widget.selectedModules.contains(module)) {
        selectedModules[module] = true;
      } else {
        selectedModules[module] = false;
      }
    }

    filteredList.addAll(allModules);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Prerequisite',
      ),
      content: dialogBody(),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: onAdd,
          child: const Text('Confirm Prerequisites'),
        ),
        TextButton(
          child: const Text('Remove Module'),
          onPressed: () {
            widget.removeMod();
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
      height: 600,
      child: Column(
        children: [
          Text(
            'Hint: ${widget.prerequisite}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          buildSearch(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: createColumn(),
                rows: createRow(),
                columnSpacing: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add selected prerequisites
  void onAdd() {
    List<String> temp = [];
    for (String module in allModules) {
      if (selectedModules[module] ?? false) {
        temp.add(module);
      }
    }
    widget.onAdd(temp);
    Navigator.of(context).pop();
  }

  // Search field widget
  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          filterModules(value);
        },
        controller: _filter,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  // Search function to filter the list of todo tasks
  void filterModules(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(allModules);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      for (String item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredList.clear();
        filteredList.addAll(dummyListData);
        allSelected = false;
      });
    } else {
      setState(() {
        filteredList.clear();
        filteredList.addAll(allModules);
        allSelected = false;
      });
    }
  }

  // Obtain selected icon
  IconData getIconData(String index) {
    if (index == '') {
      if (allSelected) {
        return Icons.check_box;
      } else if (selectedModules[index] ?? false) {
        return Icons.indeterminate_check_box_rounded;
      } else {
        return Icons.check_box_outline_blank;
      }
    } else {
      if (selectedModules[index] ?? false) {
        return Icons.check_box;
      } else {
        return Icons.check_box_outline_blank;
      }
    }
  }

  // Check if all of the modules are selected
  void checkSelection() {
    bool newValue = true;
    for (bool val in selectedModules.values) {
      if (!val) {
        newValue = false;
        break;
      }
    }
    setState(() {
      allSelected = newValue;
    });
  }

  // Change overall selection
  void changeSelection() {
    bool newValue = !allSelected;
    setState(() {
      allSelected = newValue;
      selectedModules.clear();
      selectedModules.addAll({
        for (String module in filteredList) module: newValue,
      });
    });
  }

  // Create column for DataTable
  List<DataColumn> createColumn() {
    return <DataColumn>[
      DataColumn(
        label: Center(
          child: IconButton(
            splashRadius: 0.1,
            icon: Icon(getIconData('')),
            onPressed: () {
              changeSelection();
            },
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text('Modules'),
        ),
      ),
    ];
  }

  // Create row for DataTable
  List<DataRow> createRow() {
    List<DataRow> rows = <DataRow>[];

    for (String module in filteredList) {
      rows.add(
        DataRow(
          cells: [
            DataCell(
              Center(
                child: IconButton(
                  splashRadius: 0.1,
                  icon: Icon(getIconData(module)),
                  onPressed: () {
                    bool oldValue = selectedModules[module] ?? true;
                    setState(() {
                      selectedModules[module] = !oldValue;
                    });
                  },
                ),
              ),
            ),
            DataCell(
              Text(
                module,
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
