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

setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp);
  }
  return caseSearchList;
}
