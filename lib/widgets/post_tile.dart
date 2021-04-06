import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/models/post.dart' as post;
import 'package:social_hub/widgets/post.dart';
import 'package:social_hub/widgets/progress.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ignore: must_be_immutable
class PostTile extends StatelessWidget {
  final String uid;
  PostTile(this.uid);
  var controller = Get.find<PostFireStoreController>();
  @override
  @override
  Widget build(BuildContext context) {
    if (uid == FirebaseAuth.instance.currentUser.uid) {
      controller.currentUserPost(uid);
      buildExpanded(true);
    } else
      controller.getUserPost(uid);

    return buildExpanded(false);
  }

  Expanded buildExpanded(bool isCurrentUser) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: controller.getUserPost(uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else if (snapshot.data.isBlank) {
              return SvgPicture.asset("assets/images/no_content.svg");
            } else {
              return StaggeredGridView.countBuilder(
                itemCount: isCurrentUser
                    ? controller.currentUserPosts.length
                    : snapshot.data.length,
                crossAxisCount: 2,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => {
                      Get.to(() => Post(), arguments: {
                        "uid": uid,
                        "id": uid == FirebaseAuth.instance.currentUser.uid
                            ? controller.currentUserPosts[index].postId
                            : post.Post.fromFirestore(snapshot.data[index])
                                .postId
                      })
                    },
                    child: Card(
                      shadowColor: Get.theme.primaryColor,
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          uid == FirebaseAuth.instance.currentUser.uid
                              ? controller.currentUserPosts[index].photoUrl
                              : post.Post.fromFirestore(snapshot.data[index])
                                  .photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            }
          },
        ),
      ),
    );
  }
}
