import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userid, postId, photoUrl, date, caption, loction;
  final Map likes;

  Post(
      {this.userid,
      this.photoUrl,
      this.date,
      this.caption,
      this.loction,
      this.likes,
      this.postId});

  factory Post.fromFirestore(DocumentSnapshot document) {
    return Post(
        photoUrl: document['photoUrl'],
        date: document['date'],
        caption: document['caption'],
        loction: document['loction'],
        likes: document["likes"],
        userid: document['userid'],
        postId: document.id);
  }
}

Map<String, dynamic> toFirestore(
    String photoUrl, date, caption, loction, postId, userid, Map likes) {
  return {
    'userid': userid,
    'photoUrl': photoUrl,
    'date': date,
    'caption': caption,
    'loction': loction,
    'likes': likes,
    'postid': postId
  };
}
