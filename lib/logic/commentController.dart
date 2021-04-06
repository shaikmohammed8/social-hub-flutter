import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/utils.dart';

class CommentController extends GetxController {
  var postController = Get.find<PostFireStoreController>();
  var postComment = TextEditingController();

  RxList<Map<String, dynamic>> comments = RxList();

  final collection = FirebaseFirestore.instance.collection("comment");

  void addComment(String postId, String uid, String oppositeUid, String name,
      String postimage, String avatar) async {
    try {
      await collection.doc(postId).collection("postComments").doc().set({
        "date": DateTime.now().toString(),
        "comment": postComment.text,
        "username": name,
        'avtar': avatar,
        "userid": uid,
      });
      addCommentFeedNotification(
          postId, oppositeUid, uid, name, avatar, postimage);
      postComment.clear();
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  @override
  void onClose() {
    postComment.clear();
    super.onClose();
  }

  void getComments(postId) {
    print("object" + postId);
    var docs = collection
        .doc(postId)
        .collection("postComments")
        .orderBy("date", descending: false)
        .snapshots();
    var comment = docs.map((event) => event.docs);
    comment.listen((event) {
      if (event.isNotEmpty) {
        print(event);
        List<Map<String, dynamic>> list = [];
        event.forEach((element) {
          list.add(element.data());
        });
        comments.assignAll(list);
        print("asdfasdf" + comment.length.toString());
      } else
        comments.clear();
    });
  }

  void addCommentFeedNotification(String postId, String uid, String userId,
      String name, String avtarUrl, String postUrl) async {
    if (FirebaseAuth.instance.currentUser.uid !=
        postController.post.value.userid) {
      await FirebaseFirestore.instance
          .collection("feed")
          .doc(uid)
          .collection("feedItems")
          .add({
        'username': name,
        'avtart': avtarUrl,
        'postphoto': postUrl,
        'postid': postId,
        'userid': userId,
        'date': DateTime.now().toString(),
        'type': "comment",
        'comment': postComment.text,
      });
    }
  }
}
