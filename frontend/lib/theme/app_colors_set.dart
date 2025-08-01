import 'package:flutter/material.dart';

@immutable
class AppColorSet extends ThemeExtension<AppColorSet> {
  final Color icon;
  final Color iconSelected;
  final Color iconUnselected;
  final Color textPrimary;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  // Füge hier weitere Farben bei Bedarf hinzu

  const AppColorSet({
    required this.icon,
    required this.iconSelected,
    required this.iconUnselected,
    required this.textPrimary,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
  });

  @override
  AppColorSet copyWith({
    Color? icon,
    Color? iconSelected,
    Color? iconUnselected,
    Color? textPrimary,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
  }) {
    return AppColorSet(
      icon: icon ?? this.icon,
      iconSelected: iconSelected ?? this.iconSelected,
      iconUnselected: iconUnselected ?? this.iconUnselected,
      textPrimary: textPrimary ?? this.textPrimary,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
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
    );
  }
}
