import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

header(String title) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontFamily: "Signatra",
        color: Colors.black,
        letterSpacing: 4,
      ),
    ),
  );
}
