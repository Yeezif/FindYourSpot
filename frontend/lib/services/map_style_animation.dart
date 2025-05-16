import 'package:flutter/material.dart';

class MapStyleAnimationManager {
  final TickerProvider vsync;
  final int itemCount;

  late final AnimationController controller;
  late final List<Animation<double>> fadeAnimations;
  late final List<Animation<Offset>> slideAnimations;

  MapStyleAnimationManager({
    required this.vsync,
    required this.itemCount,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnimations = List.generate(itemCount, (index) {
      final start = index * 0.1;
      final end = start + 0.5;
      return CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    slideAnimations = List.generate(itemCount, (index) {
      final start = index * 0.1;
      final end = start + 0.5;
      return Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });
  }

  void dispose() {
    controller.dispose();
  }
}
