import 'package:flutter/material.dart';

// Password text field widget
class PasswordTextField extends StatefulWidget {
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
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool hidden = true;

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
          controller: widget.passwordController,
          obscureText: hidden,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            labelText: widget.labelText,
            hintText: 'Enter your password',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                hidden ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  hidden = !hidden;
                });
              },
            ),
          ),
          validator: widget.validator ?? defaultValidator,
        ),
      ),
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
