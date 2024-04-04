import 'package:dhurandhar/providers/mobile_auth_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:dhurandhar/views/authenication/upload_user_data.dart';
import 'package:dhurandhar/views/profile/username_screen.dart';
import 'package:dhurandhar/views/profile/widgets/iconWithTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        appBarColor: primaryColor,
        title: Text(
          'Settings',
          style: boldTextStyle(context, isStaticCol: true, color: Colors.white),
        ),
      ),
      body: Container(
        color: greyScaleColor,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            IconWithTextWidget(
                onTap: () {
                  launchScreen(context, UploadUserData(fromProfile: true),
                      pageRouteAnimation: PageRouteAnimation.Slide);
                },
                txt: "Account",
                icon: Iconsax.user),
                IconWithTextWidget(
                onTap: () {
                  launchScreen(context, const UsernameScreen(),
                      pageRouteAnimation: PageRouteAnimation.Slide);
                },
                txt: "Username",
                icon: Iconsax.edit),
            IconWithTextWidget(
                onTap: () {
                  _signout(context);
                },
                txt: "Logout",
                icon: Iconsax.logout),
          ],
        ),
      ),
    );
  }

  void _signout(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.001),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            minHeight: 200.0,
                            maxHeight: 350.0,
                          ),
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      "Logout",
                                      style: boldTextStyle(
                                        context,
                                        size: 20,
                                        color: const Color(0xFFF75555),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Are you sure you want to log out?",
                                    style: primaryTextStyle(
                                      context,
                                      size: 18,
                                    ),
                                  ),
                                ),

                                // const Divider(
                                //   thickness: 1,
                                //   color: greyColor,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 48,
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: const Color(0xFFFFF8E8),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Cancel",
                                            style: primaryTextStyle(context,
                                                size: 16,
                                                weight: FontWeight.w500),
                                          )),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<MobileAuthenicationProvider>(
                                                  context,
                                                  listen: false)
                                              .logOut(context);
                                        },
                                        child: Container(
                                          height: 48,
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: primaryColor,
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Yes, Logout",
                                            style: primaryTextStyle(context,
                                                size: 16,
                                                color: Colors.white,
                                                weight: FontWeight.w500),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
