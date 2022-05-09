import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailPasswordForm extends StatefulWidget {
  final Function(bool) notifyParent;
  const EmailPasswordForm({Key? key, required this.notifyParent})
      : super(key: key);
  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool? _success;
  String? _userEmail;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Sign in with email and password'),
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                child: const Text('Sign In'),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  widget.notifyParent(true);
                },
                child: const Text('Register'),
              ),
            )
          ]),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success ?? false
                      ? 'Successfully signed in ' + (_userEmail ?? "")
                      : 'Sign in failed'),
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    User? user;
    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('signInWithPassword: No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint(
            'signInWithPassword: Wrong password provided for that user.');
      }
    }

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user!.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
