import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/models/post.dart';

import '../utils.dart';

class PostFireStoreController extends GetxController {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var user = Get.find<FirestoreController>();
  var nullPost = false.obs;
  var isLiked = false.obs;
  var likesCount = 0.obs;
  RxList<QueryDocumentSnapshot> feeds = RxList();
  Rx<Post> post = Post().obs;
  var isUploading = false.obs;
  final storage = FirebaseStorage.instance;
  final collection = FirebaseFirestore.instance.collection("post");
  RxList<Post> userPosts = RxList();
  RxList<Post> currentUserPosts = RxList();

  Rx<File> file = Rx<File>();

  void createPost(String uid) async {
    isUploading.value = true;
    var map = toFirestore(
        await uplodaPostPhoto(),
        DateTime.now().toString(),
        captionController.text,
        locationController.text,
        DateTime.now().toString(),
        uid, {});
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

  currentUserPost(String uid) {
    try {
      var posts = collection
          .doc(uid)
          .collection("userPosts")
          .orderBy("date", descending: true)
          .snapshots()
          .map((event) => event.docs);

      posts.listen((event) {
        if (!event.isBlank) {
          List<Post> list = [];
          event.forEach((element) {
            list.add(Post.fromFirestore(element));
          });
          currentUserPosts.assignAll(list);
        }
      });
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  // getUserPost(String uid) {
  //   try {
  //     var posts = collection
  //         .doc(uid)
  //         .collection("userPosts")
  //         .orderBy("date", descending: true)
  //         .snapshots()
  //         .map((event) => event.docs);

  //     posts.listen((event) {
  //       if (!event.isBlank) {
  //         List<Post> list = [];
  //         event.forEach((element) {
  //           list.add(Post.fromFirestore(element));
  //         });
  //         userPosts.assignAll(list);
  //       } else {
  //         nullPost.value = true;
  //       }
  //     });
  //   } on Exception catch (e) {
  //     displayDialoag(e, "Error");
  //   }
  // }

  Stream<List<QueryDocumentSnapshot>> getUserPost(String uid) {
    try {
      var posts = collection
          .doc(uid)
          .collection("userPosts")
          .orderBy("date", descending: true)
          .snapshots()
          .map((event) => event.docs);

      return posts;
    } on Exception catch (e) {
      displayDialoag(e, "Error");
      return null;
    }
  }

  Future<Post> getPostById(String uid, String date) async {
    print("asdfsdf" + date);
    DocumentSnapshot post;
    try {
      post = await collection.doc(uid).collection("userPosts").doc(date).get();
      if (post.exists) {
        this.post.value = Post.fromFirestore(post);
        return Post.fromFirestore(post);
      } else
        nullPost.value = true;
      return Post.fromFirestore(post);
    } on Exception catch (e) {
      displayDialoag(e, "Error");
      return null;
    }
  }

  handleLike(String uid, String postId, String name, String avtar) async {
    await FirebaseFirestore.instance
        .collection("likes")
        .doc(postId)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot value) {
      if (!value.exists) {
        value.reference.set({'name': name, 'avtar': avtar, 'userid': uid});
        addLikeFeedNotification(postId, post.value.photoUrl, uid);
      } else {
        value.reference.delete();
        removeLikeFeedNotification(postId, uid);
      }
    });
  }

  chekLiked(String postId) {
    var get = FirebaseFirestore.instance
        .collection("likes")
        .doc(postId)
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
    get.listen((event) {
      if (event.exists) {
        isLiked.value = true;
      } else
        isLiked.value = false;
    });
  }

  likeCount(String postId) {
    var likes = FirebaseFirestore.instance
        .collection('likes')
        .doc(postId)
        .collection('users')
        .snapshots()
        .map((event) => event.docs);
    likes.listen((event) {
      likesCount.value = event.length;
    });
  }

  void addLikeFeedNotification(String postId, String postUrl, String id) async {
    if (FirebaseAuth.instance.currentUser.uid != post.value.userid) {
      print("add like");
      await FirebaseFirestore.instance
          .collection("feed")
          .doc(id)
          .collection("feedItems")
          .doc(postId)
          .set({
        'username': user.currentUser.value.displayname,
        'avtart': user.currentUser.value.profileImage,
        'postphoto': postUrl,
        'postid': postId,
        'comment': '',
        'userid': FirebaseAuth.instance.currentUser.uid,
        'date': DateTime.now().toString(),
        'type': "like"
      });
    }
  }

  void removeLikeFeedNotification(String postId, String id) {
    if (FirebaseAuth.instance.currentUser.uid != post.value.userid) {
      print("remove like");
      FirebaseFirestore.instance
          .collection("feed")
          .doc(id)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    }
  }

  void getFeedNotification() {
    print("""asdfasdfasd""" + 'element.exists.toString()');
    var snapshot = FirebaseFirestore.instance
        .collection("feed")
        .doc(user.currentUser.value.id)
        .collection("feedItems")
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) => event.docs);
    print("""asdfasdfasd""" + snapshot.length.toString());
    snapshot.listen((event) {
      print("""asdfasdfasd""" + event.length.toString());
      List<QueryDocumentSnapshot> list = [];
      event.forEach((element) {
        list.add(element);
        print("""asdfasdfasd""" + event.length.toString());
      });
      feeds.assignAll(list);
    });
  }
}
