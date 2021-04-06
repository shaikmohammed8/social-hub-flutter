import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/models/user.dart';

import '../utils.dart';

class Authentication extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var pageIndex = 0.obs;
  var pageController = PageController();
  var isAuth = false.obs;

  GoogleSignIn googleSignIn = GoogleSignIn();

  void isUserAuthenticated() {
    _auth.authStateChanges().listen((event) {
      if (event != null) {
        isAuth.value = true;
      }
      if (event == null) {
        isAuth.value = false;
      }
    });
  }

  void onPageChange(int index) {
    pageIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  onInit() {
    isUserAuthenticated();
    super.onInit();
  }

  void logout() async {
    await GoogleSignIn().disconnect();
    _auth.signOut().then((value) => isAuth.value = false);
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Map<String, dynamic> map = toFirestore(
        id: _auth.currentUser.uid,
        username: "",
        email: _auth.currentUser.email,
        displayname: _auth.currentUser.displayName,
        bio: "",
        profileImage: _auth.currentUser.photoURL);
    map.addAll({"searchname": setSearchParam(_auth.currentUser.displayName)});

    await FirestoreController().creatUser(_auth.currentUser.uid, map);
  }
}
