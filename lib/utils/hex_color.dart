import 'package:flutter/material.dart';

class HexColor {

  HexColor._(); // private constructor - static utility class

  static Color fromHex(String hex, {
    Color fallback = Colors.transparent,
  }) {
    try {
      String colorStr = hex.trim();

      // Remove # if present
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.substring(1);
      }

      // Handle 3-digit shorthand (#RGB → #RRGGBB)
      if (colorStr.length == 3) {
        colorStr = colorStr
            .split('')
            .map((c) => c + c)
            .join();
      }

      // Now we expect 6 or 8 characters
      if (colorStr.length != 6 && colorStr.length != 8) {
        return fallback;
      }

      // Parse as integer (base 16)
      final intValue = int.parse(colorStr, radix: 16);

      // If 8 digits → has alpha (AARRGGBB)
      if (colorStr.length == 8) {
        return Color(intValue);
      }

      // If 6 digits → full opacity (RRGGBB)
      return Color(0xFF000000 | intValue);
    } catch (e) {
      return fallback;
    }
  }

}