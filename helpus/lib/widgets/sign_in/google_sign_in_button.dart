import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:helpus/utilities/constants.dart';

class GoogleSignInButton extends StatefulWidget {
  final Function(User?) setUser;
  const GoogleSignInButton({Key? key, required this.setUser}) : super(key: key);
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(GoogleColors.googleBlue),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  primary: FirebaseColors.firebaseNavy),
              child: Image.asset(
                'assets/logo/google_logo.png',
                width: 35,
              ),
              onPressed: googleSignIn,
            ),
    );
  }

  void googleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      if (kIsWeb) {
        googleSignInWeb();
      } else {
        googleSignInOthers();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("googleSignIn: $e");
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

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

    widget.setUser(userCredential.user);
  }

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

    widget.setUser(userCredential.user);
  }
}
