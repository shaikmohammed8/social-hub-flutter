import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void displayDialoag(Exception ex, String title) {
  Get.dialog(
    CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          ex.toString(),
        )),
  );
}
