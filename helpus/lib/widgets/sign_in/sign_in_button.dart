import 'package:flutter/material.dart';
import 'package:helpus/utilities/constants.dart';

class SignInButton extends StatefulWidget {
  final Image image;
  final String textLabel;
  final Function() login;

  const SignInButton({
    Key? key,
    required this.image,
    required this.textLabel,
    required this.login,
  }) : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                GoogleColors.googleBlue,
              ),
            )
          : ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.all(
                  20,
                ),
                primary: FirebaseColors.firebaseNavy,
              ),
              icon: widget.image,
              label: Text(
                widget.textLabel,
              ),
              onPressed: () async {
                setState(() {
                  isSigningIn = true;
                });
                await widget.login();
                setState(() {
                  isSigningIn = false;
                });
              },
            ),
    );
  }
}
