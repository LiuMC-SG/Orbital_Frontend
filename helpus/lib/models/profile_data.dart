import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:helpus/models/graph_model.dart';

class Profile {
  String name;
  final String email;
  String photoURL;
  GraphModel graphModel;
  static final blankProfile = Profile('', '', '', GraphModel.blankGraphModel);

  Profile(this.name, this.email, this.photoURL, this.graphModel);

  static generate(String userUID) async {
    DocumentReference _documentReference =
        FirebaseFirestore.instance.collection('users').doc(userUID);
    DocumentSnapshot documentSnapshot = await _documentReference.get();
    Object? data = documentSnapshot.data();

    if (data == null) {
      debugPrint("profileGenerate: Object is null and cannot be parsed.");
      return Profile.blankProfile;
    } else {
      final mappedValue =
          Map<String, dynamic>.from(data as Map<Object?, Object?>);
      return Profile(
        mappedValue['name'] ?? '',
        mappedValue['email'] ?? '',
        mappedValue['photoURL'] ?? '',
        GraphModel(mappedValue['graphModel']),
      );
    }
  }

  @override
  String toString() {
    return "name: $name, email: $email, photoURL: $photoURL, graphModel: $graphModel";
  }
}
