import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';

class EditProfile extends StatelessWidget {
  var controller = Get.find<FirestoreController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              child: Obx(() => controller.user.value.profileImage == null
                  ? CircleAvatar(backgroundColor: Colors.grey)
                  : CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          controller.user.value.profileImage),
                    )),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: Column(children: [
                ListTile(
                  leading: Text(
                    "Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  title: CupertinoTextFormFieldRow(
                    controller: controller.nameController,
                    maxLength: 30,
                    validator: (val) {
                      if (val.trim().length < 3 || val.length > 30) {
                        if (val.length == 0) {
                          return null;
                        }
                        return "Please enter a valid name";
                      } else
                        return null;
                    },
                    placeholder: controller.user.value.displayname,
                    decoration: BoxDecoration(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    " Bio    ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  title: CupertinoTextFormFieldRow(
                    controller: controller.bioController,
                    maxLength: 150,
                    validator: (val) {
                      if (val.length > 150) {
                        return "bio should be less then 150";
                      } else
                        return null;
                    },
                    placeholder: controller.user.value.bio.length == 0
                        ? "Bio"
                        : controller.user.value.bio,
                    decoration: BoxDecoration(),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.keyboard_capslock),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  controller.updateUser(FirebaseAuth.instance.currentUser.uid);
                }
              },
              label: Text("Update"),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}
