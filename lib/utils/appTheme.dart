import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

bool inDarkMode(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return theme.brightness == Brightness.dark ? true : false;
}

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: iconColor),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    dialogTheme: DialogTheme(shape: dialogShape()),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black, // Change background color to black
    fontFamily: GoogleFonts.urbanist().fontFamily,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors
          .black, // Change bottom navigation bar background color to black
    ),
    iconTheme: IconThemeData(color: iconColor),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white), // Change text color to white
      titleMedium: TextStyle(color: Colors.white), // Change text color to white
      titleSmall: TextStyle(color: Colors.white), // Change text color to white
    ),
    dialogBackgroundColor:
        Colors.black, // Change dialog background color to black
    unselectedWidgetColor:
        Colors.white, // Change unselected widget color to white
    dividerColor: viewLineColor,
    cardColor: Colors.black, // Change card color to black
    dialogTheme: DialogTheme(shape: dialogShape()),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        // Change status bar to dark
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
