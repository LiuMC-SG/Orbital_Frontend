import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/sign_in/sign_in_button.dart';

// Google sign in widget
class GoogleSignInButton extends StatefulWidget {
  final Function(User?) checkUser;
  const GoogleSignInButton({
    Key? key,
    required this.checkUser,
  }) : super(key: key);
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      image: const Image(
        image: AssetImage('assets/logo/google_logo.png'),
        width: 30,
      ),
      textLabel: SignInText.google,
      login: googleSignIn,
    );
  }

  // Sign in with Google
  void googleSignIn() async {
    try {
      if (kIsWeb) {
        googleSignInWeb();
      } else {
        googleSignInOthers();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('googleSignIn: $e');
    }
  }

  // Sign in with Google on web
  void googleSignInWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // UserCredential userCredential = await FirebaseAuth.instance.signInWithRedirect(googleProvider);

    widget.checkUser(userCredential.user);
  }

  // Sign in with Google on mobile
  void googleSignInOthers() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    widget.checkUser(userCredential.user);
  }
}
