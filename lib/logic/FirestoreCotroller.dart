import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social_hub/models/post.dart' as post;
import 'package:social_hub/models/user.dart';
import 'package:social_hub/utils.dart';

class FirestoreController extends GetxController {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var isUploading = false.obs;
  final storage = FirebaseStorage.instance;
  final collection = FirebaseFirestore.instance.collection("users");
  Rx<File> file = Rx<File>();
  Rx<UserModel> user = UserModel().obs;

  RxList<UserModel> searchUser = RxList();
  var email = "email".obs;
  RxList<UserModel> users = RxList();

  @override
  void onInit() {
    getAllUsers();
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

  void gerUserById(String uid) {
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

  void createPost(String uid) async {
    isUploading.value = true;
    var map = post.toFirestore(
        await uplodaPostPhoto(),
        DateTime.now().toString(),
        captionController.text,
        locationController.text,
        DateTime.now().toString(), {});
    try {
      var collection = FirebaseFirestore.instance
          .collection("post")
          .doc(uid)
          .collection("userPosts")
          .doc(DateTime.now().toString())
          .set(map);
      isUploading.value = false;
      file.value = null;
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
  }

  @override
  void onClose() {
    locationController.clear();
    captionController.clear();
    super.onClose();
  }

  void setLoaction(String location, String cityname) {
    print(location);
    locationController.text = "$location, $cityname";
  }
}
