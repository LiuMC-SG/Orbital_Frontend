import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/widgets/sign_in/password_text_field.dart';

// Change password dialog
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);
  @override
  ChangePasswordDialogState createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  bool? _success;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: passwordForm(),
      actions: <Widget>[
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextButton(
                  child: const Text('Change Password'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    } else {
                      _success = null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Password input form
  Widget passwordForm() {
    return SizedBox(
      width: 300,
      height: 200,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            PasswordTextField(
              passwordController: _passwordController,
              labelText: 'Password',
            ),
            PasswordTextField(
              passwordController: _passwordRepeatController,
              labelText: 'Confirm Password',
              validator: (String? value) {
                if (value != _passwordController.text) {
                  return 'Please enter same password';
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
                _success == null ? '' : _message ?? '',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Attempt to change password. If successful, navigate back to home page. If
  // unsuccessful, display an error message.
  void _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(_passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('registerWithPassword: The password provided is too weak.');
        setState(() {
          _message = 'Set a stronger password!';
        });
      } else if (e.code == 'email-already-in-use') {
        debugPrint(
            'registerWithPassword: The account already exists for that email.');
        setState(() {
          _message =
              'An account with this email already exist! Please use another email';
        });
      } else if (e.code == 'invalid-email') {
        debugPrint('registerWithPassword: The email is not valid.');
        _message = 'Invalid Email. Please try again';
      }
    } catch (e) {
      debugPrint('changePassword: $e');
    } finally {
      setState(() {
        _success = true;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }
}
