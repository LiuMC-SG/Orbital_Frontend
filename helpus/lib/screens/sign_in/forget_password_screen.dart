import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/utilities/constants.dart';

// Forget password screen
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool? _sent;
  String? _message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: resetPassword,
                      child: const Text(
                        'Send Email',
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Sign In',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutesText.signIn,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
