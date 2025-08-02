import 'package:flutter/material.dart';
import 'package:findyourspot/theme/app_colors_set.dart';

class MapStyleButtonGroup extends StatelessWidget {
  final AnimationController controller;
  final List<Animation<double>> fadeAnimations;
  final List<Animation<Offset>> slideAnimations;
  final Map<String, IconData> mapStyleIcons;
  final String selectedMapStyle;
  final void Function(String style) onStyleSelected;

  const MapStyleButtonGroup({
    super.key,
    required this.controller,
    required this.fadeAnimations,
    required this.slideAnimations,
    required this.mapStyleIcons,
    required this.selectedMapStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorSet>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Main Toggle Button
        FloatingActionButton(
          mini: true,
          heroTag: 'main-style-button',
          onPressed: () {
            if (controller.status == AnimationStatus.dismissed) {
              controller.forward();
            } else {
              controller.reverse();
            }
          },
          child: const Icon(Icons.layers_rounded),
        ),
        const SizedBox(height: 8),

        // Style Option Buttons
        Column(
          children: List.generate(mapStyleIcons.length, (index) {
            final entry = mapStyleIcons.entries.elementAt(index);
            return FadeTransition(
              opacity: fadeAnimations[index],
              child: SlideTransition(
                position: slideAnimations[index],
                child: FloatingActionButton(
                  mini: true,
                  heroTag: entry.key,
                  backgroundColor: selectedMapStyle == entry.key
                      ? colors.icon
                      : colors.backgroundPrimary,
                  onPressed: () async {
                    onStyleSelected(entry.key);
                    await Future.delayed(const Duration(milliseconds: 300));
                    controller.reverse();
                  },
                  child: Icon(
                    entry.value,
                    color: selectedMapStyle == entry.key
                        ? colors.backgroundPrimary
                        : colors.icon,
                  ),
                ),
                
              ),
            );
          }),
        ),
      ],
    );
  }
}
