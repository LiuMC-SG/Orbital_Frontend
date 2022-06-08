import 'package:flutter/material.dart';

// Module tracking screen
class ModuleTrackingScreen extends StatefulWidget {
  const ModuleTrackingScreen({Key? key}) : super(key: key);
  @override
  _ModuleTrackingScreenState createState() => _ModuleTrackingScreenState();
}

class _ModuleTrackingScreenState extends State<ModuleTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Module Tracking'),
    );
  }
}
