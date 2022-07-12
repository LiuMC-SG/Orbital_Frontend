import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Forget password dialog
class ForgetPasswordDialog extends StatefulWidget {
  const ForgetPasswordDialog({Key? key}) : super(key: key);
  @override
  ForgetPasswordDialogState createState() => ForgetPasswordDialogState();
}

class ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  bool? _sent;
  String? _message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text('Enter Your Email'),
      content: SizedBox(
        width: 300,
        height: 80,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                _sent == null ? '' : _message ?? '',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: resetPassword,
          child: const Text(
            'Send Email',
          ),
        ),
      ],
    );
  }

  // Attempt to send password reset email. If successful, show success message.
  // Otherwise, show error message.
  Future<void> resetPassword() async {
    String message = 'Email sent if it is one of the registered users.';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('forgetPassword: The email is not valid.');
        message = 'Invalid Email. Please try again';
      } else if (e.code == 'user-not-found') {
        debugPrint('forgetPassword: No user exist with this email.');
      }
    }
    setState(() {
      _sent = true;
      _message = message;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
