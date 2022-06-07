import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:helpus/models/graph_model.dart';

class Profile {
  String name;
  String email;
  String photoURL;
  GraphModel graphModel;

  Profile(this.name, this.email, this.photoURL, this.graphModel);

  static blankProfile() {
    return Profile('', '', '', GraphModel.blankGraphModel);
  }

  static generate(String userUID, Profile profile) async {
    DocumentReference _documentReference =
        FirebaseFirestore.instance.collection('users').doc(userUID);

    _documentReference.snapshots().listen(
      (event) {
        setProfile(event.data(), profile);
      },
      onError: (error) {
        debugPrint('profileGenerate: Listener failed with $error');
      },
    );

    DocumentSnapshot documentSnapshot = await _documentReference.get();

    await setProfile(documentSnapshot.data(), profile);
    return profile;
  }

  static Future<void> setProfile(Object? data, Profile profile) async {
    if (data == null) {
      debugPrint('profileGenerate: Object is null and cannot be parsed.');
    } else {
      final mappedValue =
          Map<String, dynamic>.from(data as Map<Object?, Object?>);
      profile
        ..name = mappedValue['name']
        ..email = mappedValue['email']
        ..photoURL = mappedValue['photoURL']
        ..graphModel = GraphModel(mappedValue['graphModel']);
    }
  }

  @override
  String toString() {
    return 'name: $name, email: $email, photoURL: $photoURL, graphModel: $graphModel';
  }

  bool equals(Profile profile) {
    return email == profile.email;
  }
}
