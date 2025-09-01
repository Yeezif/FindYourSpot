import 'dart:convert';
import 'dart:io';
import 'package:findyourspot/widgets/dialogs/local_images_dialog.dart';
import 'package:findyourspot/widgets/messages/messages.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:findyourspot/widgets/dialogs/location_picker_dialog.dart';
import 'package:image_picker/image_picker.dart';

class CreateSpotForm extends StatefulWidget {
  final LatLng location;
  final void Function(Map spotData) onSpotCreated;

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
  List<XFile> _pickedFiles = [];
  bool _isDragging = false;



  @override
  void initState() {
    super.initState();

    _latController.text = widget.location.latitude.toString();
    _lngController.text = widget.location.longitude.toString();
  }


  Widget buildPickedImagesGrid() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _pickedFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "Add Image"-Button
            return GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage();
                if (!mounted) return;
                if (images.isNotEmpty) {
                  setState(() {
                    _pickedFiles.addAll(images);
                  });
                }
              },
              child: DragTarget(
                builder: (context, candidateData, rejectedData) {
                  final isActive = candidateData.isNotEmpty;
                  return SizedBox.fromSize(
                    size: const Size(100, 100),
                    child: _isDragging
                        ? Icon(
                            Icons.delete_forever_rounded,
                            size: isActive ? 72 : 50,
                            color: isActive ? Colors.red : Theme.of(context).iconTheme.color,
                          )
                        : const Icon(
                            Icons.add_a_photo_rounded,
                            size: 50,
                            color: Colors.grey,
                          ),
                    
                  );
                },
                onAcceptWithDetails: (details) {
                final index = details.data as int;
                setState(() {
                  _pickedFiles.removeAt(index);
                });
              },
              ),
            );
          } 
        
        
          final imageIndex = index - 1;
          return Draggable(
            data: imageIndex,

            feedback: Opacity(
              opacity: 0.75, 
              child: SizedBox.fromSize(
                size: const Size(100, 100), 
                child: Image.file(
                  File(_pickedFiles[imageIndex].path), 
                  fit: BoxFit.cover
                )
              ),
            ),

            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (details) => setState(() => _isDragging = false),

            childWhenDragging: SizedBox.fromSize(size: const Size(100, 100)),

            child: GestureDetector(
              onTap: () {
                viewLocalImagesDialog(context, _pickedFiles, index - 1);
              },
              child: Image.file(
                File(_pickedFiles[imageIndex].path),
                fit: BoxFit.cover,
            ),
            )
          );
        },
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        
        children: [

          Text(
            'Neuen Spot erstellen',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
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
                  builder: (context) => LocationPickerDialog(
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

          buildPickedImagesGrid(),

          SizedBox(height: 20),


          ElevatedButton(
            onPressed: _isSaving
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSaving = true);
                      await _saveSpot();
                    }
                  },
            child: _isSaving
                ? CircularProgressIndicator()
                : Text('Spot erstellen'),
          ),
        ],
      ),
    );
  }



// save spot helper
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

      if (!mounted) return;

      if (response.statusCode == 201) {
        
        SuccessMessage.show(context, 'Spot erfolgreich erstellt');

        final createdSpot = jsonDecode(response.body);
        widget.onSpotCreated(createdSpot);
        if (context.mounted) Navigator.of(context).pop();

      } else {

        debugPrint('Fehler beim Erstellen: ${response.statusCode}');
        debugPrint(response.body);
        
        ErrorMessage.show(context, 'Fehler: ${response.statusCode}');

      }

    } catch (e) {
      
      debugPrint('HTTP Fehler: $e');

      if (!mounted) return;

      ErrorMessage.show(context, 'Verbindungsfehler: $e');
    }

  }
}
