import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  final String? Function(String?)? validator;
  const EmailTextField({
    Key? key,
    this.validator,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      validator: validator ?? defaultValidator,
    );
  }

  String? defaultValidator(String? value) {
    final bool isValid = EmailValidator.validate(value!.trim());
    if (!isValid) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
