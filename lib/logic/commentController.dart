import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social_hub/utils.dart';

class CommentController extends GetxController {
  var postComment = TextEditingController();

  RxList<Map<String, dynamic>> comments = RxList();

  final collection = FirebaseFirestore.instance.collection("comment");

  void addComment(String postId, String uid) async {
    try {
      var doc =
          await collection.doc(postId).collection("postComments").doc().set({
        "date": DateTime.now().toString(),
        "comment": postComment.text,
        "userid": uid,
      });
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
    var docs = collection.doc(postId).collection("postComments").snapshots();
    var comment = docs.map((event) => event.docs);
    comment.listen((event) {
      if (event.isNotEmpty) {
        print(event);
        List<Map<String, dynamic>> list = [];
        event.forEach((element) {
          list.add(element.data());
        });
        comments.assignAll(list);
      } else
        comments.clear();
    });
  }
}
