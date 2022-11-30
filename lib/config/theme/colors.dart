import 'package:flutter/material.dart';

class BrandColor {
  // static Color get primary => const Color.fromRGBO(94, 105, 238, 1.0);

  // static Color get secondary => Colors.white;

  // static Color get accent => Colors.white;

  // static Color get white => Colors.white;

  static MaterialColor get primary => const MaterialColor(0xFF5E69EE, {
        50: Color(0xFFF7F8FF),
        100: Color(0xFFEFF0FE),
        200: Color(0xFFD7DAFB),
        300: Color(0xFFBDC2F9),
        400: Color(0xFF8F96F4),
        500: Color(0xFF5E69EE),
        600: Color(0xFF545ED4),
        700: Color(0xFF393F8F),
        800: Color(0xFF2B306C),
        900: Color(0xFF1C1F46),
      });

  static MaterialColor get error => const MaterialColor(0xFFE92F2F, {
        50: Color(0xFFFEF5F5),
        100: Color(0xFFFDEBEB),
        200: Color(0xFFFACBCB),
        300: Color(0xFFF6AAAA),
        400: Color(0xFFF06E6E),
        500: Color(0xFFE92F2F),
        600: Color(0xFFD02A2A),
        700: Color(0xFF8C1D1D),
        800: Color(0xFF691616),
        900: Color(0xFF440E0E),
      });

  static MaterialColor get warning => const MaterialColor(0xFFF3BA59, {
        50: Color(0xFFFFFCF7),
        100: Color(0xFFFEF9EF),
        200: Color(0xFFFCEED6),
        300: Color(0xFFFBE3BB),
        400: Color(0xFFF7CF8B),
        500: Color(0xFFF3BA59),
        600: Color(0xFFD9A650),
        700: Color(0xFF927036),
        800: Color(0xFF6E5429),
        900: Color(0xFF47361A),
      });

  static MaterialColor get success => const MaterialColor(0xFF81E052, {
        50: Color(0xFFF9FEF7),
        100: Color(0xFFF3FCEE),
        200: Color(0xFFE0F8D4),
        300: Color(0xFFCCF3B9),
        400: Color(0xFFA7EA86),
        500: Color(0xFF81E052),
        600: Color(0xFF73C849),
        700: Color(0xFF4E8732),
        800: Color(0xFF3B6525),
        900: Color(0xFF264118),
      });

  static MaterialColor get background => const MaterialColor(0xFF1F292E, {
        50: Color(0xFFF4F5F5),
        100: Color(0xFFE9EAEB),
        200: Color(0xFFC7CACB),
        300: Color(0xFFA4A8AA),
        400: Color(0xFF636A6D),
        500: Color(0xFF1F292E),
        600: Color(0xFF1C2529),
        700: Color(0xFF13191C),
        800: Color(0xFF0E1315),
        900: Color(0xFF090C0E),
      });
}
