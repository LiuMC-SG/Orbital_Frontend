import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/sign_in/email_text_field.dart';
import 'package:helpus/widgets/sign_in/password_text_field.dart';

// Register new user screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  bool? _success;
  String? _message;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.width > 600) {
      size = Size(600, size.width);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(100, 0, 111, 157),
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(150, 0, 111, 157),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            alignment: Alignment.center,
            width: size.width,
            height: 700,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 20.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image.asset(
                          'assets/icon/app_icon.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            16,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Register with email and password',
                          ),
                        ),
                        EmailTextField(
                          emailController: _emailController,
                        ),
                        PasswordTextField(
                          passwordController: _passwordController,
                          labelText: 'Password',
                        ),
                        PasswordTextField(
                          passwordController: _passwordRepeatController,
                          labelText: 'Confirm Password',
                          validator: (String? value) {
                            if (value != _passwordController.text) {
                              return 'Please enter same password';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _registerWithEmailAndPassword();
                                  } else {
                                    _success = null;
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
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
                                    RoutesText.signIn,
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Back to Sign In',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            _success == null ? '' : _message ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Attempt to register with provided email and password. If successful, sign
  // in with the user credentials. Otherwise, display error message.
  void _registerWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        RoutesText.home,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('registerWithPassword: The password provided is too weak.');
        setState(() {
          _message = 'Set a stronger password!';
        });
      } else if (e.code == 'email-already-in-use') {
        debugPrint(
            'registerWithPassword: The account already exists for that email.');
        setState(() {
          _message =
              'An account with this email already exist! Please use another email';
        });
      } else if (e.code == 'invalid-email') {
        debugPrint('registerWithPassword: The email is not valid.');
        _message = 'Invalid Email. Please try again';
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
