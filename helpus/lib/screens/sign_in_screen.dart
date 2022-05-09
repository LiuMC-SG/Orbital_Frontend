import 'package:flutter/material.dart';
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
          notifyParent: setForgetPassword,
        ),
      ];
    } else if (isRegister) {
      return [
        RegisterScreen(
          notifyParent: setRegister,
        ),
      ];
    }
    return [
      Row(),
      EmailPasswordForm(
        notifyParent: setRegister,
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
      // const GoogleSignInButton(),
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
}
