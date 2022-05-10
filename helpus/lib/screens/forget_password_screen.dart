import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/utilities/constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool? _sent;
  String? _message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Email Your Email',
            ),
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text(
                'Send Email',
              ),
              onPressed: resetPassword,
            ),
            TextButton(
                child: const Text(
                  'Sign In',
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesText.signIn,
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    String message = "Email sent if it is one of the registered users.";
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('forgetPassword: The email is not valid.');
        message = "Invalid Email. Please try again";
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
