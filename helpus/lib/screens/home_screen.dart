import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/models/profile_data.dart';

// Home screen [After login]
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Profile profile = Profile.blankProfile();
  late Future<bool> future;

  @override
  void initState() {
    super.initState();
    future = checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Scaffold(
          body: const Center(
            child: SizedBox(
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ),
          appBar: AppBar(
            title: const Text('HelpUS'),
          ),
        );
      },
    );
  }

  // Checks if user already has profile. If it doesn't, creates a new one. Else,
  // obtain data from firestore.
  Future<bool> checkProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      documentReference.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'graphModel': GraphModel.blankGraphModel.toJson(),
        'moduleGrading': [],
        'todoList': [],
        'labels': Labels(Labels.defaultTags).toJson(),
      });
    }
    await Profile.generate(user.uid, profile);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(
      context,
      RoutesText.profile,
    );
    return true;
  }
}
