import 'package:flutter/material.dart';

class AppColorsLight {

  // main colors - light background base
  static const Color backgroundPrimary = Color(0xFFF5F5F7); // sehr helles Grau mit leichtem Blau-Touch
  static const Color backgroundSecondary = Color(0xFFFFFFFF); // klassisches Weiß
  static const Color panels = Color(0xFFE0E0E0); // helles Grau für Karten/Container

  // accent colors - neutral tones
  static const Color textPrimary = Color(0xFF1E1E1E); // fast schwarz
  static const Color textSecondary = Color(0xFF4A4A4A); // dunkles Grau
  static const Color borderlines = Color(0xFFB0BEC5); // blueGrey[200]
  static const Color icon = Color(0xFF78909C); // blueGrey[400]
  static const Color iconSelected = Color(0xFF546e7a); // blueGrey[600]
  static const Color iconUnselected = Color(0xFFB0BEC5); // blueGrey[200]

  // accent colors - colorful highlights (gleich wie Dark Theme für CI-Konsistenz)
  static const Color accentBlue = Color(0xFF2962FF); // kräftiges, lebendiges Blau
  static const Color accentPink = Color(0xFFD81B60); // kräftiges Magenta/Pink
  static const Color accentGreen = Color(0xFF43A047); // sattes Grün
  static const Color accentYellow = Color(0xFFFFC107); // warmes, helles Gelb
  static const Color accentCyan = Color(0xFF00ACC1); // schönes Türkis

  // optional - light hover variants
  static const Color hoverBlue = Color(0xFF90CAF9); // light blue[300]
  static const Color hoverGrey = Color(0xFFF0F0F0); // hover on panels

}

// Dark Theme
class AppColorsDark {

  // main colors - dark background base
  static const Color backgroundPrimary = Color(0xFF1E1E1E);
  static const Color backgroundSecondary = Color(0xFF121212);
  static const Color panels = Color(0xFF2a2a3c);
  
  // accent colors - neutral tones
  static const Color textPrimary = Color(0xffcfcfcf);
  static const Color textSecondary = Color(0xff888888);
  static const Color borderlines = Color(0xff4c556a);
  static const Color icon = Color(0xff888888);  // textSecondary
  static const Color iconSelected = Color(0xffcfcfcf);  // textPrimary
  static const Color iconUnselected = Color(0xFFCFD8DC);  // blueGrey[200]

  // accent colors - colorful highlights
  static const Color accentBlue = Color(0xff89b4fa);
  static const Color accentPink = Color(0xfff38ba8);
  static const Color accentGreen = Color(0xffa6e3a1);
  static const Color accentYellow = Color(0xfff9e2af);
  static const Color accentCyan = Color(0xff94e2d5);



}