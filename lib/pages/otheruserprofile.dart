import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/widgets/header.dart';
import 'package:social_hub/widgets/post_tile.dart';

// ignore: must_be_immutable
class OtherUserProfile extends StatelessWidget {
  final uid;
  OtherUserProfile(this.uid);
  var postController = Get.find<PostFireStoreController>();
  var controller = Get.find<FirestoreController>();
  @override
  Widget build(BuildContext context) {
    return buildScaffold(uid);
  }

  Scaffold buildScaffold(String uid) {
    controller.isFollwed(FirebaseAuth.instance.currentUser.uid, uid);
    controller.gerUserById(uid);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(
          start: 0,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        border: Border(bottom: BorderSide(color: Colors.transparent)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 11),
                    width: 80,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(2, 4))
                    ], shape: BoxShape.circle, color: Colors.blue),
                    height: 80,
                    child: Obx(
                      () => controller.user.value.profileImage == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                controller.user.value.profileImage,
                              ),
                            ),
                    )),
                SizedBox(width: 10),
                Obx(
                  () => Text(
                    controller.user.value.displayname,
                    style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontWeight: FontWeight.w900,
                        fontSize: 24),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  right: 11.0, left: 11, bottom: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: controller.isFollwed(
                        FirebaseAuth.instance.currentUser.uid, uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else if (snapshot.data.exists) {
                        return followButton(
                            uid, "Following", Colors.white, Colors.red);
                      } else
                        return followButton(uid, "follow",
                            Get.theme.primaryColor, Colors.white);
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        "posts",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<List<QueryDocumentSnapshot>>(
                          stream: postController.getUserPost(uid),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return postCountText("0");
                            } else if (snapshot.data == null) {
                              return postCountText("0");
                            } else
                              return postCountText(
                                  snapshot.data.length.toString());
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "follower",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: controller.getFollwers(uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return followerText('--');
                          } else
                            return followerText(
                                snapshot.data.docs.length.toString());
                        },
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "following",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: controller.getFollowing(uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return followerText('--');
                          } else
                            return followerText(
                                snapshot.data.docs.length.toString());
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 10),
              child: Text(
                "Posts",
                style: TextStyle(
                    foreground: Paint()
                      ..color = Colors.black87
                      ..strokeWidth = 1.1
                      ..style = PaintingStyle.stroke,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                          blurRadius: 5,
                          color: Colors.grey,
                          offset: Offset(4, 4))
                    ]),
              ),
            ),
            PostTile(uid)
          ],
        ),
      ),
    );
  }

  Text postCountText(text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Text followerText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  ElevatedButton followButton(
      String uid, String text, Color color, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(90, 35),
          primary: color,
          shadowColor: Get.theme.primaryColor,
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: () {
        controller.handleFollowing(FirebaseAuth.instance.currentUser.uid, uid);
      },
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
