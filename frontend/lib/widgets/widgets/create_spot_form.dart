// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';

// class CreateSpotForm extends StatefulWidget {
//   final LatLng location;

//   const CreateSpotForm({
//     super.key,
//     required this.location
//   });

//   @override
//   State<CreateSpotForm> createState() => _CreateSpotFormState();
// }

// class _CreateSpotFormState extends State<CreateSpotForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   bool _isSaving = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Neuen Spot erstellen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             TextFormField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Titel'),
//               validator: (value) => value == null || value.isEmpty ? 'Bitte Titel eingeben' : null,
//             ),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Beschreibung'),
//               maxLines: 2,
//             ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _isSaving ? null : () async {
//                 if (_formKey.currentState!.validate()) {
//                   setState(() => _isSaving = true);
//                   try {
//                     await _saveSpot();
//                     Navigator.of(context).pop();
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler beim Speichern')));
//                   }
//                   setState(() => _isSaving = false);
//                 }
//               }, 
//               child: _isSaving ? CircularProgressIndicator() : Text('Spot erstellen'),
//             )
//           ],
//         )
//       ),
//     );
//   }

//   Future<void> _saveSpot() async {
//     // TODO: Spot speichern (API call)
//     // Beispiel:
//     // await SpotService.createSpot(
//     //   title: _titleController.text,
//     //   description: _descriptionController.text,
//     //   location: ... // Koordinaten von MapPage übergeben oder hier reinholen
//     // );
//   }

// }

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CreateSpotForm extends StatefulWidget {
  final LatLng location;

  const CreateSpotForm({super.key, required this.location});

  @override
  State<CreateSpotForm> createState() => _CreateSpotFormState();
}

class _CreateSpotFormState extends State<CreateSpotForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Höhe passt sich Inhalt an
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Neuen Spot erstellen',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titel'),
            validator: (value) => value == null || value.isEmpty ? 'Bitte Titel eingeben' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Beschreibung'),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSaving
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSaving = true);
                      await _saveSpot();
                      if (context.mounted) Navigator.of(context).pop(); // Schließt das Dialog-Fenster
                    }
                  },
            child: _isSaving
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Spot erstellen'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSpot() async {
    final spot = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': {
        'type': 'Point',
        'coordinates': [
          widget.location.longitude,
          widget.location.latitude,
        ],
      },
    };

    // TODO: Sende diesen `spot` an deine API (z. B. mit http.post)
    print('Sende Spot: $spot');
  }
}
