import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id, email, profileImage, displayname, bio, username;

  UserModel(
      {this.email,
      this.id,
      this.profileImage,
      this.displayname,
      this.bio,
      this.username});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      id: doc['id'],
      email: doc["email"],
      displayname: doc["displayname"],
      bio: doc["bio"],
      username: doc["username"],
      profileImage: doc["profileImage"],
    );
  }
}

Map<String, dynamic> toFirestore(
    {String id, username, email, displayname, bio, profileImage}) {
  return {
    'id': id,
    'email': email,
    'displayname': displayname,
    'bio': bio,
    'username': username,
    'profileImage': profileImage
  };
}
