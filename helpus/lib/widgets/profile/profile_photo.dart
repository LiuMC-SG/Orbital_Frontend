import 'package:flutter/material.dart';
import 'package:helpus/models/profile_data.dart';

class ProfilePhoto extends StatelessWidget {
  final Profile profile;
  final Icon base = const Icon(Icons.perm_identity_rounded);
  const ProfilePhoto({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profile.photoURL == '') {
      return base;
    }

    try {
      return CircleAvatar(
        backgroundImage: NetworkImage(profile.photoURL),
        backgroundColor: Colors.black,
        radius: 75,
      );
    } catch (e) {
      debugPrint('profilePhoto: $e');
      return base;
    }
  }
}
