import 'package:flutter/foundation.dart';

class Profile {
  final String name;
  final String photo;
  final String email;
  Profile(this.name, this.email, this.photo);

  static generate(Object? object) {
    if (object.runtimeType == Null) {
      debugPrint("Object is null and cannot be parsed.");
      return Profile("", "", "");
    } else {
      final mappedValue =
          Map<String, String>.from(object as Map<Object?, Object?>);
      return Profile(mappedValue['name'] ?? "", mappedValue['email'] ?? "",
          mappedValue['photo'] ?? "");
    }
  }

  @override
  String toString() {
    return ("name: $name, email: $email, photo: $photo");
  }
}
