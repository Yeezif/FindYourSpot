import 'package:findyourspot/widgets/widgets/create_spot_form.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class CreateSpotButton extends StatelessWidget {

  final LatLng location;
  final void Function(Marker) onSpotCreated;

  const CreateSpotButton ({
    super.key,
    required this.location,
    required this.onSpotCreated,
  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        heroTag: 'create_spot_button',                    
        backgroundColor: Colors.white,
        elevation: 4.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: SingleChildScrollView(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 350, // Breite des Pop-Ups
                      child: CreateSpotForm(
                        location: location,
                        onSpotCreated: onSpotCreated,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.blueGrey[400],
          size: 40,                     
        ),
      ),
    );

    
  }

}