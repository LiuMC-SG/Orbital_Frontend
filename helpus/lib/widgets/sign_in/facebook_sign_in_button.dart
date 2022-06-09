import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/sign_in/sign_in_button.dart';

// Facebook sign in widget
class FacebookSignInButton extends StatefulWidget {
  final Function(User?) checkUser;
  const FacebookSignInButton({
    Key? key,
    required this.checkUser,
  }) : super(key: key);
  @override
  FacebookSignInButtonState createState() => FacebookSignInButtonState();
}

class FacebookSignInButtonState extends State<FacebookSignInButton> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      image: const Image(
        image: AssetImage('assets/logo/facebook_logo.png'),
        width: 30,
      ),
      textLabel: SignInText.facebook,
      login: () async {
        Fluttertoast.showToast(
          msg: 'Facebook login is currently disabled',
        );
      },
    );
  }

  // Sign in with Facebook
  void facebookSignIn() async {
    try {
      if (kIsWeb) {
        facebookSignInWeb();
      } else {
        facebookSignInOthers();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('facebookSignIn: $e');
    }
  }

  // Sign in with Facebook on web
  void facebookSignInWeb() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(facebookProvider);

    // Or use signInWithRedirect
    // UserCredential userCredential = await FirebaseAuth.instance.signInWithRedirect(facebookProvider);

    widget.checkUser(userCredential.user);
  }

  // Sign in with Facebook on mobile
  void facebookSignInOthers() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    widget.checkUser(userCredential.user);
  }
}
