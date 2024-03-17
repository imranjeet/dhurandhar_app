// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/appTheme.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/home_screen.dart';
import 'package:dhurandhar/views/notification_screen.dart/notification_screen.dart';
import 'package:dhurandhar/views/post_event/post_event.dart';
import 'package:dhurandhar/views/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../profile/profile_screen.dart';
import 'package:iconsax/iconsax.dart';

part 'package:dhurandhar/views/main_screen/_nav_icon.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "MainScreen";
  int? currentIndex;
  MainScreen({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex!;
  }

  final List _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(20),
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  inDarkMode(context) ? Colors.black : Colors.white,
                  const Color.fromRGBO(36, 195, 157, 1)
                ])),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: FloatingActionButton(
            onPressed: () {
              launchScreen(context, const PostEventScreen(),
                  pageRouteAnimation: PageRouteAnimation.Slide);
            },
            backgroundColor: Colors.transparent,
            // inDarkMode(context) ? Colors.white : Colors.black,
            // focusColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Container(
                  height: 48.fh,
                  width: 48.fh,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 30, color: Colors.black)),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
        onWillPop: () async {
          final differeance = DateTime.now().difference(timeBackPressed);
          timeBackPressed = DateTime.now();
          if (differeance >= const Duration(seconds: 2)) {
            const String msg = 'Press the back button again to exit';
            Fluttertoast.showToast(
              msg: msg,
            );
            return false;
          } else {
            Fluttertoast.cancel();
            if (Platform.isAndroid) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            } else if (Platform.isIOS) {
              exit(0);
            }
            return true;
          }
        },
        child: _pages[currentIndex],
      ),
      bottomNavigationBar:
          // NavigationBar(
          //   height: 80.fh,
          //   elevation: 0,
          //   backgroundColor: inDarkMode(context) ? Colors.white : Colors.black,
          //   selectedIndex: currentIndex,
          //   onDestinationSelected: onTap,
          //   destinations: const [
          //     NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          //     NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          //     NavigationDestination(
          //         icon: Icon(Icons.notifications), label: "Notification"),
          //     NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          //   ],
          // ),
          SizedBox(
        height: 65.fh,
        child: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape:
              const CircularNotchedRectangle(), // ← carves notch for FAB in BottomAppBar
          color: inDarkMode(context) ? primaryColor : secondaryColor,
          // ↑ use .withAlpha(0) to debug/peek underneath ↑ BottomAppBar
          elevation: 0,
          child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  inDarkMode(context) ? primaryColor : secondaryColor,
              onTap: onTap,
              currentIndex: currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: inDarkMode(context) ? greyColor : greyColor,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: const [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Iconsax.home, size: 28),
                ),
                BottomNavigationBarItem(
                  label: "Search",
                  icon: Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: Icon(Iconsax.search_normal, size: 28),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Notifications",
                  icon: Padding(
                      padding: EdgeInsets.only(left: 28),
                      child: Icon(Iconsax.notification, size: 28)),
                ),
                BottomNavigationBarItem(
                  label: "Profil",
                  icon: Icon(Iconsax.profile_circle, size: 28),
                ),
              ]),
        ),
      ),
    );
  }
}
