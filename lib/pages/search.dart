import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/FirestoreCotroller.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
      Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.black54,
          ),
          Center(
            child: Text(
              "      search...",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    ));
  }
}

// ignore: must_be_immutable
class UserResult extends StatelessWidget {
  var controller = Get.find<FirestoreController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(CupertinoTextField(
          onChanged: (val) {
            print(val);
            controller.search(val);
          },
          autofocus: true,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              height: 0.9),
          cursorColor: Colors.black,
          prefix: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 22,
            ),
          ),
          decoration: BoxDecoration(),
        )),
        body: Obx(
          () => controller.searchUser.length == 0
              ? SvgPicture.asset("assets/images/search.svg")
              : ListView.builder(
                  itemCount: controller.searchUser.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ListTile(
                          horizontalTitleGap: 30,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              controller.searchUser[index].profileImage,
                            ),
                          ),
                          title: Text(
                            controller.searchUser[index].displayname,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

Widget appBar(Widget child) {
  return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: GestureDetector(
        onTap: () => Get.to(() => UserResult()),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(padding: const EdgeInsets.all(8.0), child: child),
        ),
      ));
}
