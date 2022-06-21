import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/sign_in/facebook_sign_in_button.dart';
import 'package:helpus/widgets/sign_in/google_sign_in_button.dart';
import 'package:helpus/widgets/sign_in/email_sign_in.dart';

// Sign in screen
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool isForgetPassword = false;
  bool isRegister = false;
  User? _user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration.zero, () {
      checkUser(_user);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            children: [
              Image.asset(
                'assets/logo/HelpUS logo.png',
                height: 180,
                width: 400,
              ),
              EmailPasswordForm(
                checkUser: checkUser,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesText.forgetPassword,
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              buildRowDivider(
                size: size,
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                children: [
                  GoogleSignInButton(
                    checkUser: checkUser,
                  ),
                  FacebookSignInButton(
                    checkUser: checkUser,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Divider of line and text between normal email password sign in and 3rd
  // party authentication
  Widget buildRowDivider({required Size size}) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: size.width * 0.8,
        child: Row(
          children: const <Widget>[
            Expanded(
              child: Divider(
                color: Colors.black45,
                thickness: 1.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Text(
                'Or',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black45,
                thickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Check user then perform login function.
  void checkUser(User? user) async {
    if (user != null) {
      Future.delayed(
        Duration.zero,
        () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesText.home,
            (route) => false,
          );
        },
      );
    }
  }
}
