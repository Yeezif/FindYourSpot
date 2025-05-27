import 'package:flutter/material.dart';
import 'app_colors.dart';




// ----------------------------------------------------------------------------------------
// -------------------------------------- LIGHT THEME --------------------------------------
// ----------------------------------------------------------------------------------------

final ThemeData lightTheme = ThemeData(
  // splashColor: Colors.transparent,
  // splashFactory: NoSplash.splashFactory,
  // highlightColor: Colors.transparent,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColorsLight.backgroundPrimary,
  canvasColor: AppColorsLight.backgroundPrimary,
  cardColor: AppColorsLight.backgroundPrimary,
  iconTheme: IconThemeData(color: AppColorsLight.icon),

  // TEXT THEME
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColorsLight.textPrimary),
    bodyMedium: TextStyle(color: AppColorsLight.textPrimary),
    labelLarge: TextStyle(color: AppColorsLight.textPrimary),
  ),
  
  // COLOR SCHEME
  colorScheme: ColorScheme.dark(
    primary: AppColorsLight.icon,
    onPrimary: AppColorsLight.icon, 
    surface: AppColorsLight.backgroundPrimary,
    onSurface: AppColorsLight.icon  
  ),

  // DIALOG THEME
  dialogTheme: DialogTheme(
    backgroundColor: AppColorsLight.backgroundSecondary, //backgroundSecondary
  ),

  // ELEVATED BUTTON THEME
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.textPrimary),
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

  // FLOATING ACTION BUTTON THEME
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColorsLight.backgroundPrimary,
    foregroundColor: AppColorsLight.icon,
    elevation: 4,
  ),

  // TEXT BUTTON THEME
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.icon),
    ),
  ),

  // OUTLINED BUTTON THEME
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsLight.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsLight.icon),
      side: WidgetStateProperty.all(BorderSide(color: AppColorsLight.icon)),
    ),
  ),

  // BOTTOM NAVIGATION BAR THEME
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsLight.backgroundSecondary,
    selectedItemColor: AppColorsLight.iconSelected,
    unselectedItemColor: AppColorsLight.icon
  ),

  // CHOICE CHIP THEME
  chipTheme: ChipThemeData(
    selectedColor: AppColorsLight.iconSelected,
    backgroundColor: AppColorsLight.backgroundSecondary,
    disabledColor: AppColorsLight.iconUnselected,
    labelStyle: TextStyle(color: AppColorsLight.icon),
    secondaryLabelStyle: TextStyle(color: AppColorsLight.backgroundPrimary),
    brightness: Brightness.dark,
  ),

  // SEARCH BAR THEME
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStateProperty.all<double>(4.0),
    backgroundColor: WidgetStateProperty.all(AppColorsLight.backgroundPrimary),
  ),

  // APP BAR THEME
  appBarTheme: AppBarTheme(
    color: AppColorsLight.backgroundSecondary,
    foregroundColor: AppColorsLight.icon,
  ),

  // INPUT DECORATION THEME
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsLight.backgroundPrimary,
    iconColor: AppColorsLight.accentPink,
    prefixIconColor: AppColorsLight.accentBlue,
    suffixIconColor: AppColorsLight.accentGreen,
    focusColor: AppColorsLight.accentCyan,
    hoverColor: AppColorsLight.accentYellow
  )  

);




// ----------------------------------------------------------------------------------------
// -------------------------------------- DARK THEME --------------------------------------
// ----------------------------------------------------------------------------------------

final ThemeData darkTheme = ThemeData(
  // splashColor: Colors.transparent,
  // splashFactory: NoSplash.splashFactory,
  // highlightColor: Colors.transparent,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColorsDark.backgroundPrimary,
  canvasColor: AppColorsDark.backgroundPrimary,
  cardColor: AppColorsDark.backgroundPrimary,
  iconTheme: IconThemeData(color: AppColorsDark.icon),

  // TEXT THEME
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColorsDark.textPrimary),
    bodyMedium: TextStyle(color: AppColorsDark.textPrimary),
    labelLarge: TextStyle(color: AppColorsDark.textPrimary),
  ),
  
  // COLOR SCHEME
  colorScheme: ColorScheme.dark(
    primary: AppColorsDark.icon,
    onPrimary: AppColorsDark.icon, 
    surface: AppColorsDark.backgroundPrimary,
    onSurface: AppColorsDark.icon  
  ),

  // DIALOG THEME
  dialogTheme: DialogTheme(
    backgroundColor: AppColorsDark.backgroundSecondary, //backgroundSecondary
  ),

  // ELEVATED BUTTON THEME
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsDark.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsDark.textPrimary),
      elevation: WidgetStateProperty.all(4), 
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.blueGrey.withAlpha((0.1 * 255).round());
        }
        return null;
      }),
      side: WidgetStateProperty.all(BorderSide(color: AppColorsDark.icon)),
    ),
  ),
  
  // FLOATING ACTION BUTTON THEME
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColorsDark.backgroundPrimary,
    foregroundColor: AppColorsDark.icon,
    elevation: 4,
  ),

  // TEXT BUTTON THEME
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsDark.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsDark.icon),
    ),
  ),

  // OUTLINED BUTTON THEME
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColorsDark.backgroundPrimary),
      foregroundColor: WidgetStateProperty.all(AppColorsDark.icon),
      side: WidgetStateProperty.all(BorderSide(color: AppColorsDark.icon)),
    ),
  ),

  // BOTTOM NAVIGATION BAR THEME
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsDark.backgroundSecondary,
    selectedItemColor: AppColorsDark.iconSelected,
    unselectedItemColor: AppColorsDark.icon
  ),

  // CHOICE CHIP THEME
  chipTheme: ChipThemeData(
    selectedColor: AppColorsDark.iconSelected,
    backgroundColor: AppColorsDark.backgroundSecondary,
    disabledColor: AppColorsDark.iconUnselected,
    labelStyle: TextStyle(color: AppColorsDark.icon),
    secondaryLabelStyle: TextStyle(color: AppColorsDark.backgroundPrimary),
    brightness: Brightness.dark,
  ),

  // SEARCH BAR THEME
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStateProperty.all<double>(4.0),
    backgroundColor: WidgetStateProperty.all(AppColorsDark.backgroundPrimary),
  ),

  // APP BAR THEME
  appBarTheme: AppBarTheme(
    color: AppColorsDark.backgroundSecondary,
    foregroundColor: AppColorsDark.icon,
  ),

  // INPUT DECORATION THEME
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsDark.backgroundPrimary,
    iconColor: AppColorsDark.accentPink,
    prefixIconColor: AppColorsDark.accentBlue,
    suffixIconColor: AppColorsDark.accentGreen,
    focusColor: AppColorsDark.accentCyan,
    hoverColor: AppColorsDark.accentYellow
  )  

);
