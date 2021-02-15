import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    padding: EdgeInsets.only(top: 20),
    alignment: Alignment.topCenter,
    child: RefreshProgressIndicator(),
  );
}

linearProgress() {
  return Container(
      padding: EdgeInsets.only(bottom: 10), child: LinearProgressIndicator());
}
