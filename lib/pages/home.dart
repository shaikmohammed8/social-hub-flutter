import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/logic/PostFirestoreContoller.dart';
import 'package:social_hub/logic/authentication.dart';
import 'package:social_hub/pages/activity_feed.dart';
import 'package:social_hub/pages/profile.dart';
import 'package:social_hub/pages/search.dart';
import 'package:social_hub/pages/timeline.dart';
import 'package:social_hub/pages/upload.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:social_hub/widgets/responsive.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  var post =
      Get.lazyPut<PostFireStoreController>(() => PostFireStoreController());
  var controller = Get.put(Authentication());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isAuth.value
          ? buildAfterAuthScreen()
          : buildAuthScreen(context),
    );
  }

  Widget buildAuthScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).accentColor.withOpacity(0.7)
            ],
          ),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Social  Hub",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                controller.signInWithGoogle();
              },
              child: Container(
                height: 50,
                width: 250,
                child: Image.asset("assets/images/google_signin_button.png"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAfterAuthScreen() {
    return Scaffold(
        body: PageView(
          children: [Timeline(), ActivityFeed(), Upload(), Search(), Profile()],
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: controller.onPageChange,
        ),
        bottomNavigationBar: ResponsiveWidget(
          mobile: buildObx(),
          web: buildObx(),
        ));
  }

  Obx buildObx() {
    return Obx(
      () => BottomNavyBar(
          showElevation: false,
          selectedIndex: controller.pageIndex.value,
          onItemSelected: (int index) {
            controller.pageController.animateToPage(index,
                duration: Duration(microseconds: 500), curve: Curves.easeInOut);
          },
          items: [
            BottomNavyBarItem(
              activeColor: Colors.red,
              title: Text("Feed"),
              icon: Icon(
                Icons.whatshot_outlined,
                color: Colors.black,
              ),
            ),
            BottomNavyBarItem(
              activeColor: Colors.red,
              title: Text("Activities"),
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ),
            BottomNavyBarItem(
              activeColor: Colors.red,
              title: Text("upload"),
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.black,
              ),
            ),
            BottomNavyBarItem(
              activeColor: Colors.red,
              title: Text("Search"),
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
            ),
            BottomNavyBarItem(
              activeColor: Colors.red,
              title: Text("Profile"),
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
              ),
            ),
          ]),
    );
  }
}
