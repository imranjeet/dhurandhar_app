import 'package:flutter/material.dart';

class SizeConfig {
  static const double ASSUMED_SCREEN_HEIGHT = 760.0;
  static const double ASSUMED_SCREEN_WIDTH = 412.0;
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  static const logo = "assets/images/logo.png";

  static double _fitContext(assumedValue, currentValue, value) =>
      (value / assumedValue) * currentValue;

  static double fitToWidth(value) =>
      _fitContext(ASSUMED_SCREEN_WIDTH, screenWidth, value);

  static double fitToHeight(value) =>
      _fitContext(ASSUMED_SCREEN_HEIGHT, screenHeight, value);
}

/// Resize [double] acc to Screen Size
extension ReactiveSizeDouble on double {
  double get fh => SizeConfig.fitToHeight(this);

  double get fw => SizeConfig.fitToWidth(this);
}

/// Resize [int] acc to Screen Size
extension ReactiveSizeInt on int {
  double get fh => SizeConfig.fitToHeight(this);

  double get fw => SizeConfig.fitToWidth(this);
}
