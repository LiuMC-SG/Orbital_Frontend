import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final Function(bool) notifyParent;
  const RegisterScreen({Key? key, required this.notifyParent})
      : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  bool? _success;
  String? _message;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Register with email and password'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
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
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            validator: (String? value) {
              if (value != _passwordController.text) {
                return 'Please enter same password';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _registerWithEmailAndPassword();
                }
              },
              child: const Text('Sign Up'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null ? '' : _message ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  void _registerWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      widget.notifyParent(false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('registerWithPassword: The password provided is too weak.');
        setState(() {
          _message = "Set a stronger password!";
        });
      } else if (e.code == 'email-already-in-use') {
        debugPrint(
            'registerWithPassword: The account already exists for that email.');
        setState(() {
          _message =
              "An account with this email already exist! Please use another email";
        });
      } else if (e.code == 'invalid-email') {
        debugPrint('registerWithPassword: The email is not valid.');
        _message = "Invalid Email. Please try again";
      }
    } catch (e) {
      debugPrint('registerWithPassword: $e');
    } finally {
      setState(() {
        _success = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }
}
