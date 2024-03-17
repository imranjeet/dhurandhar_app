import 'dart:io';

import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/StringExtensions.dart';
import 'package:dhurandhar/utils/appTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle boldTextStyle(BuildContext context,
    {int? size,
    Color? color,
    FontWeight? weight,
    TextDecoration? textDecoration,
    bool isStaticCol = false}) {
  return GoogleFonts.urbanist(
    fontSize: size != null ? size.toDouble() : 20,
    color: isStaticCol
        ? color ?? textPrimaryColorGlobal
        : inDarkMode(context)
            ? Colors.white
            : color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.bold,
    decoration: textDecoration ?? TextDecoration.none,
  );
}

// Primary Text Style
TextStyle primaryTextStyle(BuildContext context,
    {int? size, Color? color, FontWeight? weight, bool isStaticCol = false}) {
  return GoogleFonts.urbanist(
    fontSize: size != null ? size.toDouble() : 18,
    color: isStaticCol
        ? color ?? textPrimaryColorGlobal
        : inDarkMode(context)
            ? Colors.white
            : color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.normal,
    // fontFamily: GoogleFonts.f
  );
}

// Secondary Text Style
TextStyle secondaryTextStyle(BuildContext context,
    {int? size, Color? color, FontWeight? weight, bool isStaticCol = false}) {
  return GoogleFonts.urbanist(
    fontSize: size != null ? size.toDouble() : 16,
    color: isStaticCol
        ? color ?? textPrimaryColorGlobal
        : inDarkMode(context)
            ? Colors.white
            : color ?? textSecondaryColorGlobal,
    fontWeight: weight ?? FontWeight.normal,
  );
}

void log(Object? value) {
  if (!kReleaseMode) print(value);
}

bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

Color getColorFromHex(String hexColor, {Color? defaultColor}) {
  if (hexColor.isEmpty) {
    if (defaultColor != null) {
      return defaultColor;
    } else {
      throw ArgumentError('Can not parse provided hex $hexColor');
    }
  }

  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}

void toast(String? value,
    {ToastGravity? gravity,
    length = Toast.LENGTH_SHORT,
    Color? bgColor,
    Color? textColor,
    bool print = false}) {
  if (value!.isEmpty || (!kIsWeb && Platform.isLinux)) {
    log(value);
  } else {
    Fluttertoast.showToast(
      msg: value.validate(),
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor,
      timeInSecForIosWeb: 2,
    );
    if (print) log(value);
  }
}

/// Launch a new screen
Future<T?> launchScreen<T>(BuildContext context, Widget child,
    {bool isNewTask = false,
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration}) async {
  if (isNewTask) {
    return await Navigator.of(context).pushAndRemoveUntil(
      buildPageRoute(child, pageRouteAnimation, duration),
      (route) => false,
    );
  } else {
    return await Navigator.of(context).push(
      buildPageRoute(child, pageRouteAnimation, duration),
    );
  }
}

enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

Route<T> buildPageRoute<T>(
    Widget? child, PageRouteAnimation? pageRouteAnimation, Duration? duration) {
  if (pageRouteAnimation != null) {
    if (pageRouteAnimation == PageRouteAnimation.Fade) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 1000),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            RotationTransition(turns: ReverseAnimation(anim), child: child),
        transitionDuration: const Duration(milliseconds: 700),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            ScaleTransition(scale: anim, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position:
              Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                  .animate(anim),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position:
              Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
                  .animate(anim),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      );
    }
  }
  return MaterialPageRoute<T>(builder: (_) => child!);
}

/// Returns MaterialColor from Color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

ShapeBorder dialogShape([double? borderRadius]) {
  return RoundedRectangleBorder(
    borderRadius: radius(borderRadius ?? 18),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? 18));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? 18);
}

class DefaultValues {
  final String defaultLanguage = "en";
}

DefaultValues defaultValues = DefaultValues();

// GestureDetector bottomButton(
//       VoidCallback ontapp, Size size, String txt, Color color, Color txtColor) {
//     return GestureDetector(
//       onTap: ontapp,
//       child: Container(
//         height: size.height * 0.06,
//         width: size.width * 0.4,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: color,
//           boxShadow: [
//             BoxShadow(
//               // offset: const Offset(-1, 1),
//               blurRadius: 1,
//               color: primaryColor,
//               // color: Color.fromRGBO(0, 0, 0, 0.16),
//             )
//           ],
//         ),
//         child: Center(
//             child: Text(
//           txt,
//           style: primaryTextStyle(
//             context, size: 16,
//             weight: FontWeight.w700,
//             color: txtColor,
//           ),
//         )),
//       ),
//     );
//   }

Widget bottomCustomButton(
  BuildContext context,
  VoidCallback onTap,
  String value, {Color? color}
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color:color ?? primaryColor,
      ),
      child: Center(
          child: Text(
        value,
        style: primaryTextStyle(context, isStaticCol: true, color: Colors.white, size: 16, weight: FontWeight.w700),
      )),

      // child: CircleAvatar(
      //   radius: 30.0,
      //   backgroundColor: const Color(0xFF24c39d),
      //   child: Center(
      //     child: SvgPicture.asset(
      //       'assets/images/onboardingTour/forward_arrow.svg',
      //       fit: BoxFit.contain,
      //     ),
      //   ),
      // ),
    ),
  );
  // }
  // return Container();
}

showScafoldSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

Widget circleProgressLoader() {
  return const Center(child: CircularProgressIndicator());
}
