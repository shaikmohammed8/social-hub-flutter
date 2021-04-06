import 'package:social_hub/models/post.dart' as post;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/pages/comments.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  var userController = Get.find<FirestoreController>();
  var controller = Get.find<PostFireStoreController>();
  Map<String, dynamic> args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print('ififif' + args['id']);
    print('ififif' + args['uid']);
    userController.gerUserById(args['uid']);
    controller.getPostById(args['uid'], args['id']);
    controller.chekLiked(args['id']);
    controller.likeCount(args['id']);
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
          FutureBuilder<post.Post>(
              future: controller.getPostById(args['uid'], args['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else
                  return Column(children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            userController.user.value.profileImage),
                      ),
                      subtitle: Text(snapshot.data.loction),
                      title: Text(
                        userController.user.value.displayname,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.short_text,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AspectRatio(
                        aspectRatio: 2 / 2,
                        child: GestureDetector(
                          onDoubleTap: () {
                            controller.handleLike(
                                args['uid'],
                                args['id'],
                                userController.user.value.displayname,
                                userController.user.value.profileImage);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image(
                              image: NetworkImage(snapshot.data.photoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Obx(
                        () => IconButton(
                          icon: controller.isLiked.value
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_outline),
                          onPressed: () {
                            controller.handleLike(
                                args['uid'],
                                args['id'],
                                userController.user.value.displayname,
                                userController.user.value.profileImage);
                          },
                        ),
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
                        child: Obx(
                          () => RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                  text: "likes",
                                ),
                                TextSpan(
                                  text: controller.likesCount.value.toString(),
                                ),
                              ])),
                        ),
                      )
                    ])
                  ]);
              }),
        ],
      ),
    );
  }

}
