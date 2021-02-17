import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/models/post.dart';

import '../utils.dart';

class PostFireStoreController extends GetxController {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var isLiked = false.obs;
  Rx<Post> post = Post().obs;
  var isUploading = false.obs;
  final storage = FirebaseStorage.instance;
  final collection = FirebaseFirestore.instance.collection("post");
  RxList<Post> userPosts = RxList();

  Rx<File> file = Rx<File>();

  void createPost(String uid) async {
    isUploading.value = true;
    var map = toFirestore(
        await uplodaPostPhoto(),
        DateTime.now().toString(),
        captionController.text,
        locationController.text,
        DateTime.now().toString(), {});
    try {
      await collection
          .doc(uid)
          .collection("userPosts")
          .doc(DateTime.now().toString())
          .set(map);
      isUploading.value = false;
      file.value = null;
      locationController.clear();
      captionController.clear();
    } on Exception catch (e) {
      isUploading.value = false;
      displayDialoag(e, 'Error');
    }
  }

  Future<String> uplodaPostPhoto() async {
    try {
      String filename = file.value.path;
      var storageRefrence = storage.ref().child('posts/$filename');
      var uploadtTast = storageRefrence.putFile(file.value);
      var storageTaskSnapshot = await uploadtTast.whenComplete(() => null);
      var url = await storageTaskSnapshot.ref.getDownloadURL();
      return url;
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
    return "";
  }

  void setLoaction(String location, String cityname) {
    print(location);
    locationController.text = "$location, $cityname";
  }

  @override
  void onClose() {
    locationController.clear();
    captionController.clear();

    super.onClose();
  }

  getUserPost(String uid) {
    try {
      var posts = collection
          .doc(uid)
          .collection("userPosts")
          .snapshots()
          .map((event) => event.docs);

      posts.listen((event) {
        if (!event.isBlank) {
          List<Post> list = [];
          event.forEach((element) {
            list.add(Post.fromFirestore(element));
          });
          userPosts.assignAll(list);
        }
      });
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  getPostById(String uid, String date) async {
    print("asdfsdf" + date);
    try {
      var post =
          await collection.doc(uid).collection("userPosts").doc(date).get();
      print(post.id);
      this.post.value = Post.fromFirestore(post);
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  handleLike(String uid, String postId) async {
    if (isLiked == null || isLiked == false) {
      await collection.doc(uid).collection("userPosts").doc(postId).update({
        "likes": {uid: true}
      });
      isLiked.value = true;
    } else {
      await collection.doc(uid).collection("userPosts").doc(postId).update({
        "likes": {uid: false}
      });
      isLiked.value = false;
    }
  }

  chekLiked(String uid, String postId) {
    var get =
        collection.doc(uid).collection("userPosts").doc(postId).snapshots();
    get.listen((event) {
      if (event["likes"][uid] != null) {
        isLiked.value = event["likes"][uid];
      }
      ;
    });
  }
}
