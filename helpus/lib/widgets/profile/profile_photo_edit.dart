import 'package:flutter/material.dart';
import 'package:helpus/utilities/constants.dart';

class ProfilePhotoEdit extends StatelessWidget {
  final String imagePath;

  const ProfilePhotoEdit({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return CircleAvatar(
      radius: 75,
      backgroundColor: color,
      child: CircleAvatar(
        // backgroundImage: NetworkImage(imagePath),
        backgroundColor: Colors.black,
        radius: 72,
      ),
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
}
