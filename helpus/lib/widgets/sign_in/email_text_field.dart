import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

// Email text field widget
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.mail_outline_rounded),
            labelText: 'Email',
            hintText: 'Enter your email',
            border: InputBorder.none,
          ),
          validator: validator ?? defaultValidator,
        ),
      ),
    );
  }

  // Check if text is of email format
  String? defaultValidator(String? value) {
    final bool isValid = EmailValidator.validate(value!.trim());
    if (!isValid) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
