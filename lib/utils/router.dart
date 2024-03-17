import 'package:dhurandhar/views/authenication/auth_screen.dart';
import 'package:dhurandhar/views/authenication/verify.dart';
import 'package:dhurandhar/views/main_screen/main_screen.dart';
import 'package:dhurandhar/views/main_screen/splash_screen.dart';
import 'package:dhurandhar/views/onboarding_tour/onboarding_tour.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  final args = routeSettings.arguments ?? <String, dynamic>{};
  switch (routeSettings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SplashScreen());
    case MainScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => MainScreen());
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case AuthScreenVerify.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreenVerify());
    case OnboardingTourPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => OnboardingTourPage(args as Map<dynamic, dynamic>));

    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
              body: Center(child: Text("Screens does not exist!"))));
  }
}
