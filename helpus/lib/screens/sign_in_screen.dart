import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/sign_in/google_sign_in_button.dart';
import '../widgets/sign_in/email_sign_in.dart';
import 'register_screen.dart';
import 'forget_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isForgetPassword = false;
  bool isRegister = false;
  User? _user;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: elements(),
          ),
        ),
      ),
    );
  }

  List<Widget> elements() {
    if (isForgetPassword) {
      return [
        ForgetPasswordScreen(
          setForgetPassword: setForgetPassword,
        ),
      ];
    } else if (isRegister) {
      return [
        RegisterScreen(
          setRegister: setRegister,
        ),
      ];
    }
    return [
      Row(),
      EmailPasswordForm(
        setRegister: setRegister,
        setUser: setUser,
      ),
      TextButton(
        onPressed: () {
          setState(() {
            isForgetPassword = true;
          });
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
      Row(),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          _email == null ? '' : 'Sign in with $_email',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      Row(),
      GoogleSignInButton(
        setUser: setUser,
      ),
    ];
  }

  void setForgetPassword(bool isForgetPassword) {
    setState(() {
      this.isForgetPassword = isForgetPassword;
    });
  }

  void setRegister(bool isRegister) {
    setState(() {
      this.isRegister = isRegister;
    });
  }

  void setUser(User? user) {
    setState(() {
      _user = user;
      _email = user!.email;
    });
  }
}
