import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CenterLocationButton extends StatelessWidget {

  final LatLng? currentLocation;
  final MapController mapController;

  const CenterLocationButton({

    super.key,
    required this.currentLocation,
    required this.mapController,

  });

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      heroTag: 'center_location_button',
      mini: true,
      backgroundColor: Colors.white,
      elevation: 4.0,
      onPressed: () {
        if (currentLocation != null) {
          mapController.move(currentLocation!, 15);
        }
      },
      child: const Icon(
        Icons.my_location_rounded, 
        color: Color(0xFF78909C)
      ) // == Colors.blueGrey[400]
    );

  }

}