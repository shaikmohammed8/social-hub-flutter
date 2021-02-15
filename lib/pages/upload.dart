import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/pages/post_screen.dart';
import 'package:social_hub/widgets/progress.dart';

// ignore: must_be_immutable
class Upload extends StatelessWidget {
  var controller = Get.find<FirestoreController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
        () => controller.file.value == null ? imagePickLayout() : PostScreen());
  }

  void pickImageFromgallary() async {
    var file = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (file != null) {
      controller.file.value = File(file.path);
    }
  }

  void pickImageFromCamera() async {
    var file = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    if (file != null) {
      controller.file.value = File(file.path);
    }
  }

  Scaffold imagePickLayout() {
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.6),
      body: Column(
        children: [
          SvgPicture.asset(
            "assets/images/upload.svg",
            height: 400,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            onPressed: () {
              Get.dialog(CupertinoAlertDialog(
                content: Column(
                  children: [
                    TextButton.icon(
                        icon: Icon(Icons.camera),
                        onPressed: pickImageFromCamera,
                        label: Text("from camera")),
                    TextButton.icon(
                        icon: Icon(Icons.image),
                        onPressed: pickImageFromgallary,
                        label: Text("from gallery")),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(300, 50),
            ),
            label: Text("upload"),
          ),
        ],
      ),
    );
  }
}
