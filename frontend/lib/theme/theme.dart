import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  // splashColor: Colors.transparent,
  // splashFactory: NoSplash.splashFactory,
  // highlightColor: Colors.transparent,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColorsLight.background,
  canvasColor: AppColorsLight.background,
  dialogTheme: DialogTheme(backgroundColor: AppColorsLight.background),
  cardColor: AppColorsLight.background,

  iconTheme: IconThemeData(color: AppColorsLight.icon),

  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColorsLight.text),
    bodyMedium: TextStyle(color: AppColorsLight.text),
    labelLarge: TextStyle(color: AppColorsLight.text),
  ),
  
  colorScheme: ColorScheme.light(
    primary: AppColorsLight.icon,
    onPrimary: AppColorsLight.background,
    surface: AppColorsLight.background,
    onSurface: AppColorsLight.icon  
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.background),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.text),
      elevation: WidgetStateProperty.all(4), 
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.blueGrey.withAlpha((0.1 * 255).round());
        }
        return null;
      }),
      side: WidgetStateProperty.all(BorderSide(color: AppColorsLight.icon)),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColorsLight.background,
    foregroundColor: AppColorsLight.icon,
    elevation: 4,
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.background),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.icon),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.background),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.icon),
      side: WidgetStateProperty.all(BorderSide(color: AppColorsLight.icon)),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsLight.background,
    selectedItemColor: AppColorsLight.iconSelected,
    unselectedItemColor: AppColorsLight.icon
  ),

  chipTheme: ChipThemeData(
    selectedColor: AppColorsLight.icon,
    backgroundColor: AppColorsLight.background,
    disabledColor: AppColorsLight.iconUnselected,
    labelStyle: TextStyle(color: AppColorsLight.icon),
    secondaryLabelStyle: TextStyle(color: AppColorsLight.background),
    brightness: Brightness.light,
  )


);
