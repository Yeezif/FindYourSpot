import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';

// LOCATION PICKER DIALOG

class LocationPickerDialog extends StatefulWidget {
  
  final LatLng initialLocation;

  const LocationPickerDialog({
    super.key,
    required this.initialLocation,
  });

  @override
  State<LocationPickerDialog> createState() => LocationPickerDialogState();

}

class LocationPickerDialogState extends State<LocationPickerDialog> {

  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {

    final String apiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.8,
        
        child: Column(
          children: [

            // Map
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _pickedLocation,
                    initialZoom: 15,
                    onTap: (tapPos, point) {
                      setState(() => _pickedLocation = point);
                    },
                  ),
                  children: [
                    TileLayer(urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey'),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _pickedLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: EdgeInsets.all(10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _pickedLocation),
                    child: const Text('Speichern'),
                  ),

                ],
              ),
            )

          ],
        ),
        
      ),
    );
  }

}