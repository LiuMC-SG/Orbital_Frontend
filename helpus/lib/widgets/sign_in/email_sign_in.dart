import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/sign_in/email_text_field.dart';
import 'package:helpus/widgets/sign_in/password_text_field.dart';

// Email sign in widget
class EmailPasswordForm extends StatefulWidget {
  final Function(User?) checkUser;
  const EmailPasswordForm({
    Key? key,
    required this.checkUser,
  }) : super(key: key);
  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool? _success;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text(
              'Sign in with email and password',
            ),
            padding: const EdgeInsets.all(
              16,
            ),
            alignment: Alignment.center,
          ),
          EmailTextField(
            emailController: _emailController,
          ),
          PasswordTextField(
            passwordController: _passwordController,
            labelText: 'Password',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutesText.register,
                    );
                  },
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              _success == null || _success == true
                  ? ''
                  : 'Sign in failed. Check you keyed in the correct email and password.',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Sign in with email and password.
  void _signInWithEmailAndPassword() async {
    User? user;

    // Attempt to sign in with email and password
    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('signInWithPassword: No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint(
            'signInWithPassword: Wrong password provided for that user.');
      }
    }

    // Check if user is signed in. If so, navigate to home.
    if (user != null) {
      setState(() {
        _success = true;
        widget.checkUser(user);
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
