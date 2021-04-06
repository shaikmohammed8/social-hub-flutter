import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/widgets/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'otheruserprofile.dart';

// ignore: must_be_immutable
class ActivityFeed extends StatelessWidget {
  var controller = Get.find<PostFireStoreController>();
  @override
  Widget build(BuildContext context) {
    controller.getFeedNotification();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Activities",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.feeds.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: controller.feeds.length,
                      itemBuilder: (_, index) => ActivityFeedItem(
                          postId: controller.feeds[index]['postid'],
                          postImage: controller.feeds[index]['postphoto'],
                          type: controller.feeds[index]['type'],
                          userPhoto: controller.feeds[index]['avtart'],
                          userId: controller.feeds[index]['userid'],
                          date: controller.feeds[index]['date'],
                          comment: controller.feeds[index]['comment'],
                          name: controller.feeds[index]['username']),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ActivityFeedItem extends StatelessWidget {
  final String postId, postImage, userPhoto, name, type, comment, date, userId;
  var controller = Get.find<PostFireStoreController>();

  ActivityFeedItem(
      {this.postId,
      this.type,
      this.userId,
      this.comment,
      this.date,
      this.name,
      this.postImage,
      this.userPhoto});

  @override
  Widget build(BuildContext context) {
    print("elseelse" + postId);
    return ListTile(
      isThreeLine: false,
      leading: GestureDetector(
        onTap: () => Get.to(() => OtherUserProfile(userId)),
        child: CircleAvatar(
          backgroundImage: NetworkImage(userPhoto),
        ),
      ),
      title: RichText(
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
        TextSpan(text: name, style: TextStyle(fontSize: 17)),
        TextSpan(
            text: titleText(type),
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " " + comment, style: TextStyle())
      ])),
      subtitle: Text(timeago.format(DateTime.parse(date))),
      trailing: GestureDetector(
          onTap: () => Get.to(() => Post(), arguments: {
                'uid': FirebaseAuth.instance.currentUser.uid,
                'id': postId
              }),
          child: Image.network(postImage)),
    );
  }

  String titleText(String type) {
    if (type == 'like') {
      return ' Liked your photo';
    } else if (type == 'Started Following you') {
      return "  " + type;
    }
    return " comment:";
  }
}
