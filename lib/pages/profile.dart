import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/pages/edit_profile.dart';
import 'package:social_hub/widgets/header.dart';
import 'package:social_hub/widgets/post_tile.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  var postController = Get.find<PostFireStoreController>();
  var controller = Get.find<FirestoreController>();
  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border(bottom: BorderSide(color: Colors.transparent)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 8),
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
                          offset: Offset(2, 4)),
                    ], shape: BoxShape.circle, color: Colors.blue),
                    height: 80,
                    child: Obx(
                      () => controller.currentUser.value.profileImage == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                controller.currentUser.value.profileImage,
                              ),
                            ),
                    )),
                SizedBox(width: 10),
                Obx(
                  () => Text(
                    controller.currentUser.value.displayname,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 15,
                        shadowColor: Get.theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () => Get.to(() => EditProfile()),
                    child: Text(
                      "Edit Profile",
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "posts",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => Text(
                          postController.currentUserPosts.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "follower",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: controller
                            .getFollwers(controller.currentUser.value.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return followingAndFollowerText('--');
                          } else
                            return followingAndFollowerText(
                                snapshot.data.docs.length.toString());
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "following",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: controller
                            .getFollowing(controller.currentUser.value.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return followingAndFollowerText('--');
                          } else
                            return followingAndFollowerText(
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
            PostTile(controller.currentUser.value.id)
          ],
        ),
      ),
    );
  }

  Text followingAndFollowerText(text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
