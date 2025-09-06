import 'dart:convert';
import 'dart:io';
import 'package:findyourspot/models/collection.dart';
import 'package:findyourspot/models/user.dart';
import 'package:findyourspot/widgets/dialogs/local_images_dialog.dart';
import 'package:findyourspot/widgets/messages/messages.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:findyourspot/widgets/dialogs/location_picker_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:findyourspot/services/api_service.dart';

class CreateCollectionForm extends StatefulWidget {
  final ApiService apiService;

  const CreateCollectionForm({
    super.key, 
    required this.apiService,
  });

  @override
  State<CreateCollectionForm> createState() => _CreateSpotFormState();
}




class _CreateSpotFormState extends State<CreateCollectionForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<XFile> _pickedFiles = [];

  bool _isSaving = false;
  bool _isDragging = false;



  // @override
  // void initState() {
  //   super.initState();

  //   _latController.text = widget.location.latitude.toString();
  //   _lngController.text = widget.location.longitude.toString();
  // }


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
            'Create Collection',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
            validator: (value) => value == null || value.isEmpty ? 'please enter title' : null,
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          



          buildPickedImagesGrid(),

          SizedBox(height: 20),


          ElevatedButton(
            onPressed: _isSaving
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSaving = true);
                      await _saveCollection();
                    }
                  },
            child: _isSaving
                ? CircularProgressIndicator()
                : Text('Create Collection'),
          ),
        ],
      ),
    );
  }



// save collection helper
  Future<void> _saveCollection() async {

    final collection = Collection(
      id: null,
      title: _titleController.text,
      description: _descriptionController.text,
      spots: [],
      createdBy: User(id: '', username: '')
      // TODO: images: _pickedFiles.map((file) => file.path).toList(),
    );

    try {
      
      final createdCollection = await widget.apiService.createCollection(collection);

      if (!mounted) return;

      SuccessMessage.show(context, 'Collection created successfully!');
      Navigator.of(context).pop(createdCollection);

    } catch (e) {

      debugPrint('Error creating collection: $e');
      if (!mounted) return;
      ErrorMessage.show(context, 'Error creating collection: $e');
      
    } finally {

      setState(() => _isSaving = false);
      
    }
    



  }
}
