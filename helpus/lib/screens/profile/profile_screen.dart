import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/profile/profile_info_edit.dart';
import 'package:helpus/widgets/profile/profile_info_static.dart';
import 'package:helpus/widgets/profile/profile_photo_edit.dart';

class ProfileScreen extends StatefulWidget {
  final String userUID = FirebaseAuth.instance.currentUser!.uid;
  ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentReference? _documentReference;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setProfile(widget.userUID),
      initialData: Profile("", "", ""),
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePhotoEdit(
              imagePath: snapshot.data!.photo,
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileInfoEdit(
                title: 'Name',
                value: snapshot.data!.name,
                submission: (String) {}),
            ProfileInfoStatic(
              title: 'Email',
              value: snapshot.data!.email,
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 20,
              children: [
                ElevatedButton(
                  child: const Text("Change Password"),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutesText.changePassword,
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text("Delete Account"),
                  onPressed: deleteAccount,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<Profile> setProfile(String userUID) async {
    _documentReference =
        FirebaseFirestore.instance.collection('users').doc(userUID);
    DocumentSnapshot documentSnapshot = await _documentReference!.get();
    return Profile.generate(documentSnapshot.data());
  }

  void setProfilePicture() {}

  void setName(String name) {
    _documentReference!.set({'name', name}, SetOptions(merge: true));
  }

  void deleteAccount() {}
}
