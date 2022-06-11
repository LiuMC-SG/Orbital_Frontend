import 'package:flutter/material.dart';

// Error Screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text('Error. Page not found.'),
        ),
      ),
    );
  }
}
