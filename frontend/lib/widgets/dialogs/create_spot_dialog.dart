import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:findyourspot/widgets/widgets/create_spot_form.dart';

class CreateSpotDialog extends StatelessWidget {
  final LatLng location;
  final void Function(Map spotData) onSpotCreated;

  const CreateSpotDialog({
    super.key,
    required this.location,
    required this.onSpotCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CreateSpotForm(
            location: location,
            onSpotCreated: onSpotCreated,
          ),
        ),
      ),
    );
  }
}
