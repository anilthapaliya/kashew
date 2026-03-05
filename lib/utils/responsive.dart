import 'package:flutter/material.dart';

/// R: Responsiveness; similar design across all devices
class R {

  static late MediaQueryData _mediaQueryData;

  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;

  static late double _scaleWidth;
  static late double _scaleHeight;
  static late double _scaleText;

  /// Reference UI size (design size)
  static const double designWidth = 375;
  static const double designHeight = 812;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    pixelRatio = _mediaQueryData.devicePixelRatio;

    _scaleWidth = screenWidth / designWidth;
    _scaleHeight = screenHeight / designHeight;

    // Text scale uses smaller factor to prevent overflow
    _scaleText = _scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight;
  }

  /// Width scaling
  static double w(double width) {
    return width * _scaleWidth;
  }

  /// Height scaling
  static double h(double height) {
    return height * _scaleHeight;
  }

  /// Font scaling
  static double sp(double fontSize) {
    return fontSize * _scaleText;
  }

  /// Radius or general scaling
  static double r(double size) {
    return size * _scaleWidth;
  }

}