import 'package:flutter/material.dart';
import 'package:findyourspot/theme/app_colors_set.dart';

class SuccessMessage {
  static void show(BuildContext context, String message) {

    final colors = Theme.of(context).extension<AppColorSet>()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: colors.successMessage,
      ),
    );

  }
}

class ErrorMessage {
  static void show(BuildContext context, String message) {

    final colors = Theme.of(context).extension<AppColorSet>()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: colors.errorMessage,
      ),
    );

  }
}

class InfoMessage {
  static void show(BuildContext context, String message) {

    final colors = Theme.of(context).extension<AppColorSet>()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: colors.infoMessage,
      ),
    );

  }
}