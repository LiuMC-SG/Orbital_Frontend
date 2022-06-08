import 'package:flutter/material.dart';

// Password text field widget
class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  final String? Function(String?)? validator;
  final String labelText;
  const PasswordTextField({
    Key? key,
    this.validator,
    required this.passwordController,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: validator ?? defaultValidator,
    );
  }

  // Check if text is of password format
  String? defaultValidator(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter password';
    }
    return null;
  }
}
