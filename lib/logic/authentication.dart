import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/models/user.dart';

class Authentication extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var pageIndex = 0.obs;
  var pageController = PageController();
  var isAuth = false.obs;

  GoogleSignIn googleSignIn = GoogleSignIn();

  void isUserAuthenticated() {
    if (FirebaseAuth.instance.currentUser != null) {
      isAuth.value = true;
    }
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

  void logout() {
    FirebaseAuth.instance.signOut().then((value) => isAuth.value = false);
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
        username: "",
        email: _auth.currentUser.email,
        displayname: _auth.currentUser.displayName,
        bio: "",
        profileImage: _auth.currentUser.photoURL);
    map.addAll({"searchname": setSearchParam(_auth.currentUser.displayName)});

    await FirestoreController().creatUser(_auth.currentUser.uid, map);
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}
