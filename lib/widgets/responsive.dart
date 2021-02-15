import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile, web;
  ResponsiveWidget({this.mobile, this.web});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth > 700) {
        return web;
      } else {
        return mobile;
      }
    });
  }
}
