import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social_hub/models/user.dart';
import 'package:social_hub/utils.dart';

class FirestoreController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  var isLiked = false.obs;
  final collection = FirebaseFirestore.instance.collection("users");
  Rx<UserModel> currentUser = UserModel().obs;
  Rx<UserModel> user = UserModel().obs;

  RxList<UserModel> searchUser = RxList();
  var email = "email".obs;
  RxList<UserModel> users = RxList();

  @override
  void onInit() {
    getAllUsers();
    gerCurrentUser();
    gerUserById(FirebaseAuth.instance.currentUser.uid);
    super.onInit();
  }

  void getAllUsers() {
    try {
      var snapshot = collection.snapshots().map((event) => event.docs);
      var doc = snapshot.map((event) {
        List<UserModel> list = [];
        print(event.length.toString() + "asdf");
        event.forEach((element) {
          print(list.length);
          print(element.data());
          list.add(UserModel.fromFirestore(element));
        });
        return list;
      });

      doc.listen((event) {
        users.assignAll(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> creatUser(String uid, Map<String, dynamic> map) async {
    var user = await collection.doc(uid).get();
    if (!user.exists) {
      return await collection.doc(uid).set(map);
    } else {
      return;
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void search(String query) async {
    var result =
        await collection.where('searchname', arrayContains: query).get();
    if (result.docs.length != 0) {
      print("not nullllllllll");
      List<UserModel> list = [];
      result.docs.forEach((element) {
        list.add(UserModel.fromFirestore(element));
        searchUser.assignAll(list);
      });
    } else {
      searchUser.clear();
    }
  }

  gerUserById(String uid) {
    try {
      var snapshot = collection.doc(uid).snapshots();
      snapshot.listen((event) {
        if (event != null) {
          user.value = UserModel.fromFirestore(event);
        }
      });
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  gerCurrentUser() {
    try {
      var snapshot =
          collection.doc(FirebaseAuth.instance.currentUser.uid).snapshots();
      snapshot.listen((event) {
        if (event != null) {
          currentUser.value = UserModel.fromFirestore(event);
        }
      });
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  @override
  void onClose() {
    bioController.clear();
    nameController.clear();
    super.onClose();
  }

  void updateUser(String uid) async {
    Map<String, dynamic> map = {};
    if (nameController.text.isNotEmpty) {
      map.addAll({
        "displayname": nameController.text,
        'searchname': setSearchParam(nameController.text)
      });
    }
    if (bioController.text.isNotEmpty) {
      print("asdfasdfasdf" + bioController.text);
      map.addAll({"bio": bioController.text});
    }
    try {
      if (map.isNotEmpty) {
        await collection.doc(uid).update(map);
        Get.back();
      } else
        displayDialoag(
            Exception("You Did not change anything"), "Can't update");
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
    nameController.clear();
    bioController.clear();
  }

  handleFollowing(String currentUid, String otherUid) async {
    try {
      var follow = await FirebaseFirestore.instance
          .collection("following")
          .doc(currentUid)
          .collection("userFollweing")
          .doc(otherUid)
          .get();

      if (follow.exists) {
        follow.reference.delete();
        await FirebaseFirestore.instance
            .collection("followers")
            .doc(otherUid)
            .collection("userFollowers")
            .doc(currentUid)
            .delete()
            .whenComplete(() => null);
        removeFollowFeedNotification(otherUid, currentUid);
      } else {
        follow.reference.set({});
        await FirebaseFirestore.instance
            .collection("followers")
            .doc(otherUid)
            .collection("userFollowers")
            .doc(currentUid)
            .set({});
        addFollowFeedNotification(otherUid, currentUid);
      }
    } on Exception catch (e) {
      displayDialoag(e, "Error");
    }
  }

  Stream<DocumentSnapshot> isFollwed(String currentUid, String otherUid) {
    return FirebaseFirestore.instance
        .collection("following")
        .doc(currentUid)
        .collection("userFollweing")
        .doc(otherUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getFollwers(String uid) {
    return FirebaseFirestore.instance
        .collection("followers")
        .doc(uid)
        .collection("userFollowers")
        .snapshots();
  }

  Stream<QuerySnapshot> getFollowing(String uid) {
    return FirebaseFirestore.instance
        .collection("following")
        .doc(uid)
        .collection("userFollweing")
        .snapshots();
  }

  void addFollowFeedNotification(String id, String uid) async {
    if (FirebaseAuth.instance.currentUser.uid != id) {
      await FirebaseFirestore.instance
          .collection("feed")
          .doc(id)
          .collection("feedItems")
          .doc(uid)
          .set({
        'username': currentUser.value.displayname,
        'avtart': currentUser.value.profileImage,
        'postphoto': "",
        'postid': "",
        'comment': '',
        'userid': FirebaseAuth.instance.currentUser.uid,
        'date': DateTime.now().toString(),
        'type': "Started Following you"
      });
    }
  }

  void removeFollowFeedNotification(String id, String uid) {
    if (FirebaseAuth.instance.currentUser.uid != id) {
      FirebaseFirestore.instance
          .collection("feed")
          .doc(id)
          .collection("feedItems")
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    }
  }
}
