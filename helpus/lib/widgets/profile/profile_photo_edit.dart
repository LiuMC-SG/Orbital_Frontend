import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/profile/profile_photo.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoEdit extends StatefulWidget {
  final Profile profile;
  const ProfilePhotoEdit({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _ProfilePhotoEditState createState() => _ProfilePhotoEditState();
}

class _ProfilePhotoEditState extends State<ProfilePhotoEdit> {
  ProfilePhoto _profilePhoto = ProfilePhoto(profile: Profile('', '', ''));
  @override
  Widget build(BuildContext context) {
    _profilePhoto = ProfilePhoto(profile: widget.profile);
    return Center(
      child: Stack(
        children: [
          profilePhoto(FirebaseColors.firebaseBlue),
          Positioned(
            child: editIcon(FirebaseColors.firebaseBlue),
            right: 10,
            top: 10,
          ),
        ],
      ),
    );
  }

  // Builds Profile Image which border color and thickness 5
  Widget profilePhoto(Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(
            width: 3,
            color: color,
          ),
        ),
        fixedSize: const Size(150, 150),
      ),
      onPressed: setPicture,
      child: _profilePhoto,
    );
  }

  // Builds Edit Icon on Profile Picture
  Widget editIcon(Color color) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: color,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 13,
        child: Icon(
          Icons.mode_edit_rounded,
          color: color,
        ),
      ),
    );
  }

  void setPicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    Reference reference =
        FirebaseStorage.instance.ref().child('users/${user!.uid}');
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        String photoURL;
        await reference.putData(await image.readAsBytes());
        photoURL = await reference.getDownloadURL();
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection("users").doc(user.uid);
        documentReference.set(
          {'photoURL': photoURL},
          SetOptions(merge: true),
        );
        widget.profile.photoURL = photoURL;
        setState(() {
          _profilePhoto = ProfilePhoto(profile: widget.profile);
        });
      } on FirebaseException catch (e) {
        debugPrint("setPicture: ${e.message}");
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      Fluttertoast.showToast(
        msg: "No image selected",
      );
    }
  }
}
