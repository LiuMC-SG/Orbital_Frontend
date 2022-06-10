import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';

// Template screen
class TemplateScreen extends StatefulWidget {
  const TemplateScreen({Key? key}) : super(key: key);
  @override
  TemplateScreenState createState() => TemplateScreenState();
}

class TemplateScreenState extends State<TemplateScreen> {
  Profile profile = Profile.blankProfile();
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = setInitial();
  }

  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return body();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget body() {
    return const Text('Template');
  }
}
