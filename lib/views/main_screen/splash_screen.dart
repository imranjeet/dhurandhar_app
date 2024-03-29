// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dhurandhar/providers/onboarding_tour_provider.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/authenication/auth_screen.dart';
import 'package:dhurandhar/views/main_screen/main_screen.dart';
import 'package:dhurandhar/views/onboarding_tour/onboarding_tour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/mobile_auth_provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  OnboardingTourProvider onboardingTourProvider = OnboardingTourProvider();

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initPushNotificationSystem() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      // PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
      // pushNotificationSystem.initializeCloudMessaging(context);
      // pushNotificationSystem.generateTokenAndSave();
    }
  }

  initAsync() async {
    Timer(const Duration(seconds: 2), () async {
      if (await onboardingTourProvider.canLaunch()) {
        startTour();
      } else {
        // CustomLogger.instance.singleLine("Current _checkLoginState");
        _checkLoginState();
      }
    });
  }

  startTour() async {
    await Future.delayed(Duration.zero); // Introduce a microtask delay
    // CustomLogger.instance.singleLine("Starting onboarding tour");
    await Navigator.pushNamed(context, OnboardingTourPage.routeName);
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AuthScreen.routeName, ((route) => false));
      } else {
        // final user = FirebaseAuth.instance.currentUser!;
        final token = await user.getIdToken();
        CustomLogger.instance.singleLine("token: $token");
        initPushNotificationSystem();
        // Provider.of<AppBasicInfoProvider>(context, listen: false)
        //     .initAppBaseData();
        await Provider.of<MobileAuthenicationProvider>(context, listen: false)
            .getCurrentUserData(context);
        var currentUser =
            Provider.of<MobileAuthenicationProvider>(context, listen: false)
                .currentUser;
        if (currentUser != null) {
          launchScreen(context, MainScreen(),
              pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true);
        } else {
          // launchScreen(context, UploadUserData(),
          //     pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        SvgPicture.asset(
          "assets/splash_background.svg",
          fit: BoxFit.cover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: size.width * 0.5,
                height: size.height * 0.1,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Dhurander",
                style: boldTextStyle(context,
                    size: 24, isStaticCol: true, color: Colors.white),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.05),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Made in ',
                style: primaryTextStyle(context,
                    isStaticCol: true,
                    size: 14,
                    weight: FontWeight.w400,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: 'India 🇮🇳',
                      style: primaryTextStyle(context,
                          isStaticCol: true,
                          size: 14,
                          weight: FontWeight.w800,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        )
      ],
    )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   // crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(top: size.height * 0.35),
        //       child: Center(
        //         child: Column(
        //           children: [
        //             Image.asset(
        //               'assets/logo.png',
        //               width: size.width * 0.5,
        //               height: size.height * 0.1,
        //             ),
        //             // SizedBox(height: size.height * 0.01),
        //             RichText(
        //               textAlign: TextAlign.center,
        //               text: TextSpan(
        //                 text: 'A unit of ',
        //                 style: primaryTextStyle(context,
        //                     size: 12, weight: FontWeight.w400),
        //                 children: <TextSpan>[
        //                   TextSpan(
        //                       text: 'Private Limited',
        //                       style: primaryTextStyle(context,
        //                           size: 12, weight: FontWeight.w800)),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     // SizedBox(
        //     //   // height: 300,
        //     //   // width: 350,
        //     //   child: Image.asset(
        //     //     'assets/sp_image.jpg',
        //     //   ),
        //     // ),
        //     // const SizedBox(
        //     //   height: 20,
        //     // ),
        //     // Padding(
        //     //   padding: const EdgeInsets.only(bottom: 20.0),
        //     //   child: SpinnerLoader(
        //     //     size: 50,
        //     //   ),
        //     // ),

        //     // Padding(
        //     //   padding: const EdgeInsets.only(bottom: 20.0),
        //     //   child: RichText(
        //     //     textAlign: TextAlign.center,
        //     //     text: TextSpan(
        //     //       text: 'Brand of  ',
        //     //       style: primaryTextStyle(size: 24),
        //     //       children: <TextSpan>[
        //     //         TextSpan(text: 'Bihar', style: boldTextStyle(size: 24)),
        //     //       ],
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
        );
  }
}
