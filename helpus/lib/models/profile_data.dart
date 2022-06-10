import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/module_data.dart';
import 'package:helpus/models/todo_data.dart';

// Profile class to store user profile data
class Profile {
  String name;
  String email;
  String photoURL;
  GraphModel graphModel;
  List<ModuleGrading> moduleGrading;
  List<Todo> todoList;

  Profile(
    this.name,
    this.email,
    this.photoURL,
    this.graphModel,
    this.moduleGrading,
    this.todoList,
  );

  // Generate blank profile
  static blankProfile() {
    return Profile(
      '',
      '',
      '',
      GraphModel.blankGraphModel,
      <ModuleGrading>[],
      <Todo>[],
    );
  }

  // Generate profile from firestore using firebase userid
  static generate(String userUID, Profile profile) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(userUID);

    documentReference.snapshots().listen(
      (event) {
        setProfile(event.data(), profile);
      },
      onError: (error) {
        debugPrint('profileGenerate: Listener failed with $error');
      },
    );

    DocumentSnapshot documentSnapshot = await documentReference.get();

    await setProfile(documentSnapshot.data(), profile);
    return profile;
  }

  // Set profile from firestore data
  static Future<void> setProfile(Object? data, Profile profile) async {
    if (data == null) {
      debugPrint('profileGenerate: Object is null and cannot be parsed.');
    } else {
      final mappedValue =
          Map<String, dynamic>.from(data as Map<Object?, Object?>);
      profile
        ..name = mappedValue['name'] ?? ''
        ..email = mappedValue['email'] ?? ''
        ..photoURL = mappedValue['photoURL'] ?? ''
        ..graphModel = GraphModel(mappedValue['graphModel'])
        ..moduleGrading =
            ModuleGrading.fromJsonList(mappedValue['moduleGrading'])
        ..todoList = Todo.fromJsonList(mappedValue['todoList']);
    }
  }

  @override
  String toString() {
    String nameString = 'name: $name';
    String emailString = 'email: $email';
    String photoURLString = 'photoURL: $photoURL';
    String graphModelString = 'graphModel: $graphModel';
    String moduleGradingString = 'moduleGrading: $moduleGrading';
    String todoListString = 'todoList: $todoList';
    return [
      nameString,
      emailString,
      photoURLString,
      graphModelString,
      moduleGradingString,
      todoListString,
    ].join(', ');
  }

  // Check if profiles are identical
  bool equals(Profile profile) {
    return email == profile.email;
  }
}
