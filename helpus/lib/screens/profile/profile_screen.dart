import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/profile/profile_info_edit.dart';
import 'package:helpus/widgets/profile/profile_info_static.dart';
import 'package:helpus/widgets/profile/profile_photo_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile profile = Profile.blankProfile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setInitial(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePhotoEdit(
                profile: profile,
              ),
              const SizedBox(
                height: 5,
              ),
              ProfileInfoEdit(
                title: 'Name',
                value: profile.name,
                submission: setName,
              ),
              ProfileInfoStatic(
                title: 'Email',
                value: profile.email,
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                children: [
                  ElevatedButton(
                    child: const Text('Change Password'),
                    onPressed: changePassword,
                  ),
                  ElevatedButton(
                    child: const Text('Delete Account'),
                    onPressed: deleteAccount,
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);
    return true;
  }

  void setName(String name) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    documentReference.set(
      {'name': name},
      SetOptions(merge: true),
    );
    Fluttertoast.showToast(
      msg: 'Name has been updated',
    );
  }

  void changePassword() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user!.providerData[0].providerId != 'password') {
      Fluttertoast.showToast(
          msg:
              'Account is from 3rd party authentication services. Password cannot be changed');
    } else {
      Navigator.pushNamed(
        context,
        RoutesText.changePassword,
      );
    }
  }

  void deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    try {
      await FirebaseStorage.instance.ref().child('users/${user!.uid}').delete();
    } on FirebaseException catch (e) {
      debugPrint('deleteAccount: ${e.message}');
    }
    await user!.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesText.signIn,
      (route) => false,
    );
  }
}
