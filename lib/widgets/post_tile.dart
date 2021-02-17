import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/widgets/post.dart';

class PostTile extends StatelessWidget {
  var controller = Get.find<PostFireStoreController>();
  @override
  Widget build(BuildContext context) {
    controller.getUserPost(FirebaseAuth.instance.currentUser.uid);
    return Obx(
      () =>
          //  controller.userPosts.length == 0
          //     ? SvgPicture.asset("assets/images/no_content.svg")
          //     :
          Expanded(
        child: Container(
          padding: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1))),
          child: GridView.builder(
              itemCount: controller.userPosts.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 10 / 11,
                  maxCrossAxisExtent: 170),
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () => {
                    Get.to(() => Post(),
                        arguments: controller.userPosts[index].id)
                  },
                  child: Image.network(
                    controller.userPosts[index].photoUrl,
                    fit: BoxFit.fill,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
