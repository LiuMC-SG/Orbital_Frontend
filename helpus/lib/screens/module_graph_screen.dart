import 'package:flutter/material.dart';

class ModuleGraphScreen extends StatefulWidget {
  const ModuleGraphScreen({Key? key}) : super(key: key);
  @override
  _ModuleGraphScreenState createState() => _ModuleGraphScreenState();
}

class _ModuleGraphScreenState extends State<ModuleGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Module Graph"),
    );
  }
}
