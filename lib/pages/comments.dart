import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/logic/commentController.dart';

class Comments extends StatelessWidget {
  CommentController controller = Get.put(CommentController());
  var postController = Get.find<PostFireStoreController>();
  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.getComments(args);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: (Get.mediaQuery.size.height -
                    AppBar().preferredSize.height -
                    Get.mediaQuery.padding.top) *
                0.9,
            child: Obx(
              () => ListView.builder(
                  itemCount: controller.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Comment(
                        comment: controller.comments[index]['comment'],
                        userid: controller.comments[index]['userid']);
                  }),
            ),
          ),
          Container(
            height: (Get.mediaQuery.size.height -
                    AppBar().preferredSize.height -
                    Get.mediaQuery.padding.top) *
                0.1,
            child: CupertinoTextField(
              controller: controller.postComment,
              padding: const EdgeInsets.all(8),
              prefix: IconButton(
                onPressed: () {},
                icon: Icon(Icons.emoji_emotions),
              ),
              //  decoration: BoxDecoration(border: Border.all()),
              suffix: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  controller.addComment(
                      args, FirebaseAuth.instance.currentUser.uid);
                },
              ),
              placeholder: "Enter a Comment",
            ),
          )
        ]),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String comment;
  final userid;
  var userController = Get.find<FirestoreController>();

  Comment({this.comment, this.userid});

  @override
  Widget build(BuildContext context) {
    userController.gerUserById(userid);
    return Obx(
      () => ListTile(
        leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                userController.user.value.profileImage)),
        title: Text(userController.user.value.displayname),
        subtitle: Text(comment),
        trailing: IconButton(icon: Icon(Icons.short_text), onPressed: () {}),
      ),
    );
  }
}
