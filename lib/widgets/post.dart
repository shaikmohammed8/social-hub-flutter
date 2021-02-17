import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/pages/comments.dart';
import 'package:social_hub/widgets/progress.dart';

class Post extends StatelessWidget {
  var userController = Get.find<FirestoreController>();
  var controller = Get.find<PostFireStoreController>();
  String args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.getPostById(FirebaseAuth.instance.currentUser.uid, args);
    controller.chekLiked(FirebaseAuth.instance.currentUser.uid, args);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            }),
        title: Text(
          "Posts",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => controller.post.value.photoUrl == null
                ? circularProgress()
                : Column(children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            userController.user.value.profileImage),
                      ),
                      subtitle: Text(controller.post.value.loction),
                      title: Text(
                        userController.user.value.displayname,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.black,
                          ),
                          onPressed: () {}),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                spreadRadius: -4,
                                blurRadius: 10,
                                offset: Offset(5, 8))
                          ]),
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 2 / 2,
                        child: GestureDetector(
                          onDoubleTap: () {
                            controller.handleLike(
                                FirebaseAuth.instance.currentUser.uid, args);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image(
                              image:
                                  NetworkImage(controller.post.value.photoUrl),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      IconButton(
                        icon: controller.isLiked.value
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_outline),
                        onPressed: () {
                          controller.handleLike(
                              FirebaseAuth.instance.currentUser.uid, args);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_comment_outlined),
                        onPressed: () {
                          Get.to(() => Comments(), arguments: args);
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                text: "likes",
                              ),
                              TextSpan(
                                text: controller.post.value.likes.length
                                    .toString(),
                              ),
                            ])),
                      )
                    ])
                  ]),
          )
        ],
      ),
    );
  }
}
