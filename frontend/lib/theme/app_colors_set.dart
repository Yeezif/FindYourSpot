import 'package:flutter/material.dart';

@immutable
class AppColorSet extends ThemeExtension<AppColorSet> {
  final Color icon;
  final Color iconSelected;
  final Color iconUnselected;
  final Color textPrimary;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color successMessage;
  final Color errorMessage;
  final Color infoMessage;
  // Füge hier weitere Farben bei Bedarf hinzu

  const AppColorSet({
    required this.icon,
    required this.iconSelected,
    required this.iconUnselected,
    required this.textPrimary,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.successMessage,
    required this.errorMessage,
    required this.infoMessage,
  });

  @override
  AppColorSet copyWith({
    Color? icon,
    Color? iconSelected,
    Color? iconUnselected,
    Color? textPrimary,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? successMessage,
    Color? errorMessage,
    Color? infoMessage,
  }) {
    return AppColorSet(
      icon: icon ?? this.icon,
      iconSelected: iconSelected ?? this.iconSelected,
      iconUnselected: iconUnselected ?? this.iconUnselected,
      textPrimary: textPrimary ?? this.textPrimary,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      infoMessage: infoMessage ?? this.infoMessage,
    );
  }

  @override
  AppColorSet lerp(ThemeExtension<AppColorSet>? other, double t) {
    if (other is! AppColorSet) return this;
    return AppColorSet(
      icon: Color.lerp(icon, other.icon, t)!,
      iconSelected: Color.lerp(iconSelected, other.iconSelected, t)!,
      iconUnselected: Color.lerp(iconUnselected, other.iconUnselected, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      successMessage: Color.lerp(successMessage, other.successMessage, t)!,
      errorMessage: Color.lerp(errorMessage, other.errorMessage, t)!,
      infoMessage: Color.lerp(infoMessage, other.infoMessage, t)!,
    );
  }
}
