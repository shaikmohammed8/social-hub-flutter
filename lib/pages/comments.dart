import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/logic/commentController.dart';

// ignore: must_be_immutable
class Comments extends StatelessWidget {
  CommentController controller = Get.put(CommentController());
  var postController = Get.find<PostFireStoreController>();
  var user = Get.find<FirestoreController>();
  Map<String, dynamic> args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    user.gerCurrentUser();
    controller.getComments(args['id']);

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
                    Get.mediaQuery.padding.top -
                    Get.mediaQuery.viewInsets.bottom) *
                0.9,
            child: Obx(
              () => ListView.builder(
                  itemCount: controller.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Comment(
                        userPhoto: controller.comments[index]['avtar'],
                        username: controller.comments[index]['username'],
                        comment: controller.comments[index]['comment'],
                        userid: controller.comments[index]['userid']);
                  }),
            ),
          ),
          Container(
            height: (Get.mediaQuery.size.height -
                    AppBar().preferredSize.height -
                    Get.mediaQuery.padding.top -
                    Get.mediaQuery.viewInsets.bottom) *
                0.1,
            child: CupertinoTextField(
              maxLength: 100,
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
                      args['id'],
                      user.currentUser.value.id,
                      args['uid'],
                      user.currentUser.value.displayname,
                      postController.post.value.photoUrl,
                      user.currentUser.value.profileImage);
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

// ignore: must_be_immutable
class Comment extends StatelessWidget {
  final String comment;
  final userPhoto;
  final username, userid;
  var userController = Get.find<FirestoreController>();

  Comment({this.comment, this.userid, this.username, this.userPhoto});

  @override
  Widget build(BuildContext context) {
    print("asdfasdfasdfsadfsadf" + userPhoto);

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(userPhoto)),
      title: Text(username),
      subtitle: Text(comment),
      trailing: IconButton(icon: Icon(Icons.short_text), onPressed: () {}),
    );
  }
}
