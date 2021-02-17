import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id, photoUrl, date, caption, loction;
  final Map likes;

  Post(
      {this.photoUrl,
      this.date,
      this.caption,
      this.loction,
      this.likes,
      this.id});

  factory Post.fromFirestore(DocumentSnapshot document) {
    return Post(
        photoUrl: document['photoUrl'],
        date: document['date'],
        caption: document['caption'],
        loction: document['loction'],
        likes: document["likes"],
        id: document.id);
  }
}

Map<String, dynamic> toFirestore(
    String photoUrl, date, caption, loction, id, Map likes) {
  return {
    'photoUrl': photoUrl,
    'date': date,
    'caption': caption,
    'loction': loction,
    'likes': likes,
    'id': id
  };
}
