import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Change password screen
class ProfileChangePasswordScreen extends StatefulWidget {
  const ProfileChangePasswordScreen({Key? key}) : super(key: key);
  @override
  _ProfileChangePasswordScreenState createState() =>
      _ProfileChangePasswordScreenState();
}

class _ProfileChangePasswordScreenState
    extends State<ProfileChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  bool? _success;
  String? _message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Back',
            );
          },
        ),
      ),
      body: passwordForm(),
    );
  }

  // Password input form
  Widget passwordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text(
              'Change your password',
            ),
            padding: const EdgeInsets.all(
              16,
            ),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordRepeatController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
            validator: (String? value) {
              if (value != _passwordController.text) {
                return 'Please enter same password';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _changePassword();
                }
              },
              child: const Text('Change Password'),
            ),
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
    );
  }

  // Attempt to change password. If successful, navigate back to home page. If
  // unsuccessful, display an error message.
  void _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(_passwordController.text);
      Navigator.pop(context);
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
