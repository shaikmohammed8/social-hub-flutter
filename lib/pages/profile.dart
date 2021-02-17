import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return Scaffold(
      appBar: header('Profile'),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        shape: BoxShape.circle,
                        color: Colors.blue),
                    height: 60,
                    child: Obx(
                      () => controller.user.value.profileImage == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                            )
                          : CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                controller.user.value.profileImage,
                              ),
                            ),
                    )),
                Column(
                  children: [
                    Text(
                      "posts",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Text(
                        postController.userPosts.length.toString(),
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
                    Text(
                      "0",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "following",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "0",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Obx(
              () => Center(
                child: Text(
                  controller.user.value.displayname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      controller.user.value.bio,
                      maxLines: 5,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => EditProfile()),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(color: Get.theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            PostTile()
          ],
        ),
      ),
    );
  }
}
