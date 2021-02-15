import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email, profileImage, displayname, bio, username;

  UserModel(
      {this.email,
      this.profileImage,
      this.displayname,
      this.bio,
      this.username});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      email: doc["email"],
      displayname: doc["displayname"],
      bio: doc["bio"],
      username: doc["username"],
      profileImage: doc["profileImage"],
    );
  }
}

Map<String, dynamic> toFirestore(
    {String username, email, displayname, bio, profileImage}) {
  return {
    'email': email,
    'displayname': displayname,
    'bio': bio,
    'username': username,
    'profileImage': profileImage
  };
}
