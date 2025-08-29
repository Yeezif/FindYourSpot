import 'dart:io';
import 'package:findyourspot/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatefulWidget {

  final String? spotId; 
  final bool autoUpload;
  final Function(List<String>)? onUploaded;
  final Function(List<XFile>)? onChanged;
  final List<String>? initialUrls;

  const ImageUploadField({
    super.key,
    this.spotId,
    this.autoUpload = false,
    this.onUploaded,
    this.onChanged,
    this.initialUrls
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();

}

class _ImageUploadFieldState extends State<ImageUploadField> {

  final List<XFile> _pickedFiles = [];
  List<String> _uploadedUrls = [];
  bool _isUploading = false;

  @override
  void initState() { 
    super.initState(); 

    if (widget.initialUrls != null) {
      _uploadedUrls = List.from(widget.initialUrls!);
    }
  }

  Future<void> _pickAndHandleImages() async {

    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isEmpty) return;

    if (widget.autoUpload && widget.spotId != null) {

      // previewDialog: instant upload
      setState(() {
        _pickedFiles.addAll(images);
        _isUploading = true;
      });

      final urls = await uploadImages(widget.spotId!, images);
      if (!mounted) return;

      setState(() {
        _uploadedUrls.addAll(urls);
        _pickedFiles.clear();
        _isUploading = false;
      });

      if (widget.onUploaded != null) widget.onUploaded!(_uploadedUrls);

    } else {

      // createSpotForm: no upload
      setState(() => _pickedFiles.addAll(images));
      if (widget.onChanged != null) widget.onChanged!(_pickedFiles);
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: _pickedFiles.length + 1,
            itemBuilder: (context, index) {
              return Draggable(
                data: index,
                feedback: Opacity(
                  opacity: 0.75,
                  child: SizedBox.fromSize(
                    size: const Size(100, 100),
                    child: Image.file(File(_pickedFiles[index].path), fit: BoxFit.cover),
                  ),
                ),  

                childWhenDragging: const SizedBox(width: 100, height: 100),

                child: Image.file(File(_pickedFiles[index].path), fit: BoxFit.cover),
              );
            }
          )
        ),

        SizedBox(height: 12),

        DragTarget(
          builder: (context, candidateData, rejectedData) {
            final isActive = candidateData.isNotEmpty;
            return Icon(
              Icons.delete_forever_rounded,
              size: isActive ? 72 : 50,
              color: isActive ? Colors.red : Theme.of(context).iconTheme.color,
            );
          },
          onAcceptWithDetails: (details) {
            final index = details.data as int;
            setState(() => _pickedFiles.removeAt(index));
            if (!widget.autoUpload && widget.onChanged != null) {
              widget.onChanged!(_pickedFiles);
            }
          },
        ),

        if (_isUploading) const LinearProgressIndicator(),

        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickAndHandleImages,
          icon: const Icon(Icons.add_a_photo_rounded),
          label: const Text('Add Images'),
        )
        
      ]
    );

  }
}