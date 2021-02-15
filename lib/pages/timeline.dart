import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';
import 'package:social_hub/widgets/header.dart';

// ignore: must_be_immutable
class Timeline extends StatelessWidget {
  var controller = Get.put(FirestoreController());

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header("Social  hub"),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (_, index) => Text(
                  controller.users[index].displayname,
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                controller.logout();
              },
              child: Text("logOUt)"))
        ],
      ),
    );
  }
}
