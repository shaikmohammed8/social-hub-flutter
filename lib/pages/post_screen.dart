import 'package:geocoder/geocoder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';

class PostScreen extends StatelessWidget {
  var controller = Get.find<FirestoreController>();
  @override
  Widget build(BuildContext context) {
    controller.gerUserById(FirebaseAuth.instance.currentUser.uid);
    if (Get.isDialogOpen) {
      Get.back();
    }
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            controller.file.value = null;
          },
        ),
        trailing: Obx(
          () => TextButton(
            onPressed: controller.isUploading.value
                ? null
                : () {
                    controller
                        .createPost(FirebaseAuth.instance.currentUser.uid);
                  },
            child: Text(
              "post",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        middle: Text("Caption post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() =>
                controller.isUploading.value ? linearProgress() : Container()),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(
                controller.file.value,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16),
              leading: Obx(
                () => controller.user.value.profileImage == null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(controller.user.value.profileImage),
                      ),
              ),
              title: CupertinoTextField.borderless(
                controller: controller.captionController,
                placeholder: "Caption..       max(250)",
                maxLength: 250,
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: CupertinoTextField.borderless(
                controller: controller.locationController,
                maxLength: 40,
                placeholder: "Where this photo is taken..       max(40)",
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: getGeoLoaction,
              icon: Icon(Icons.person_pin_circle),
              label: Text("pick location"),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }

  void getGeoLoaction() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinated = Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinated);
    var location = address.first;
    controller.setLoaction(location.locality, location.countryName);
  }
}
