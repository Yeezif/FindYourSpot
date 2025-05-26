import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSpotForm extends StatefulWidget {
  final LatLng location;
  final void Function(Marker) onSpotCreated;

  const CreateSpotForm({
    super.key, 
    required this.location,
    required this.onSpotCreated,
  });

  @override
  State<CreateSpotForm> createState() => _CreateSpotFormState();
}




class _CreateSpotFormState extends State<CreateSpotForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  bool _isSaving = false;



  @override
  void initState() {
    super.initState();

    _latController.text = widget.location.latitude.toString();
    _lngController.text = widget.location.longitude.toString();
  }



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

          Row(children: [

            Expanded(
              child: 
              TextFormField(
                controller: _latController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Breitengrad'),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: 
              TextFormField(
                controller: _lngController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Längengrad'),
              ),
            ),

            const SizedBox(width:  8),

            IconButton(
              icon: const Icon(Icons.edit_location_outlined),
              tooltip: 'Auf Karte auswählen',
              onPressed: () async {

                final picked = await showDialog<LatLng>(
                  context: context,
                  builder: (context) => _LocationPickerDialog(
                    initialLocation: LatLng(
                      double.tryParse(_latController.text) ?? widget.location.latitude,
                      double.tryParse(_lngController.text) ?? widget.location.longitude,
                    ),
                  ),
                );

                if (picked != null) {
                  _latController.text = picked.latitude.toStringAsFixed(6);
                  _lngController.text = picked.longitude.toStringAsFixed(6);
                }

              },
            )

          ],),

          SizedBox(height: 20),

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
          double.tryParse(_lngController.text) ?? widget.location.longitude,
          double.tryParse(_latController.text) ?? widget.location.latitude,
        ],
      },
    };

    final databaseUrl = dotenv.env['DATABASE_URL'];
    final uri = Uri.parse('$databaseUrl/api/spots');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    try {

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(spot),
      );

      if (response.statusCode == 201) {
        
        print('Spot erfolgreich erstellt');
        // TODO: success message

        // set marker
        final newMarker = Marker(
          point: LatLng(
            double.tryParse(_latController.text) ?? widget.location.latitude, 
            double.tryParse(_lngController.text) ?? widget.location.longitude,
          ),
          width: 40,
          height: 40,
          alignment: Alignment.topCenter,
          child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
        );

        // callback to mappage
        widget.onSpotCreated(newMarker);

      } else {

        print('Fehler beim Erstellen: ${response.statusCode}');
        print(response.body);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: ${response.statusCode}'))
        );

      }

    } catch (e) {

      print('HTTP Fehler: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verbindungsfehler: $e'))
      );
    }

  }
}














// LOCATION PICKER DIALOG

class _LocationPickerDialog extends StatefulWidget {
  
  final LatLng initialLocation;

  const _LocationPickerDialog({
    required this.initialLocation,
  });

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();

}

class _LocationPickerDialogState extends State<_LocationPickerDialog> {

  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {

    final String apiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        
        width: 350,
        height: 400,
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

              TileLayer(
                // TODO: MapStyles global verwalten
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),

            ],

          ),
        )
        
        
      ),

      actions: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen')
            ),

            SizedBox(width: 8),

            ElevatedButton(
              onPressed: () => Navigator.pop(context, _pickedLocation),
              child: const Text('Speichern'),
            ),
          ]
        )
      ],

    );  
  }

}