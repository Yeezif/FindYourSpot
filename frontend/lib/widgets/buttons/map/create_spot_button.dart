import 'package:findyourspot/widgets/dialogs/create_spot_dialog.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CreateSpotButton extends StatelessWidget {

  final LatLng location;
  final void Function(Map) onSpotCreated;

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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Center(
              
              child: CreateSpotDialog(
                location: location, 
                onSpotCreated: onSpotCreated
              )
              
            ),
          );
        },
        child: Icon(
          Icons.add_rounded,
          size: 40,                     
        ),
      ),
    );

    
  }

}