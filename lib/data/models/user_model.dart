import 'package:kafe/data/models/preference_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String photoURL;
  final PreferenceModel? preference;
  final String created;

  UserModel({
    this.uid = '',
    this.email = '',
    this.username = '',
    this.photoURL = '',
    this.preference,
    this.created = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      photoURL: json['photoURL'],
      preference: json['preference'] != null
          ? PreferenceModel.fromJson(json['preference'])
          : PreferenceModel(),
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'photoURL': photoURL,
      'preference': preference!.toJson(),
      'created': created,
    };
  }
}
