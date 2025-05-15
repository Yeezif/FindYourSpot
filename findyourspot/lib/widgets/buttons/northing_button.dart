import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;


class NorthingButton extends StatelessWidget {

  final MapController mapController;
  final double mapRotation;

  const NorthingButton({

    super.key,
    required this.mapController,
    required this.mapRotation,

  });

  @override
  Widget build(BuildContext context) {
    
    return FloatingActionButton(
      heroTag: 'northing_button',
      mini: true,
      backgroundColor: Colors.white,
      elevation: 4.0,
      onPressed: () {
        mapController.rotate(0);
      },
      
      child: Transform.rotate(
        angle: mapRotation * (math.pi / 180), // conversion to radians
        child: const Icon(
          Icons.navigation_rounded,
          color: Color(0xFF78909C)
        )
      )
    );

  }

}