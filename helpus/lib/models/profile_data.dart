import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Profile {
  String name;
  final String email;
  String photoURL;
  Profile(this.name, this.email, this.photoURL);

  static generate(String userUID) async {
    DocumentReference _documentReference =
        FirebaseFirestore.instance.collection('users').doc(userUID);
    DocumentSnapshot documentSnapshot = await _documentReference.get();
    Object? data = documentSnapshot.data();

    if (data == null) {
      debugPrint("Object is null and cannot be parsed.");
      return Profile('', '', '');
    } else {
      final mappedValue =
          Map<String, String>.from(data as Map<Object?, Object?>);
      return Profile(
        mappedValue['name'] ?? '',
        mappedValue['email'] ?? '',
        mappedValue['photoURL'] ?? '',
      );
    }
  }

  @override
  String toString() {
    return ("name: $name, email: $email, photoURL: $photoURL");
  }
}
