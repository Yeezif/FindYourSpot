import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:findyourspot/services/upload_service.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewDialog extends StatefulWidget {
  final Map spot;
  final List<XFile> pickedFiles;
  final VoidCallback refreshMainDialog;

  const PreviewDialog({
    super.key,
    required this.spot,
    required this.pickedFiles,
    required this.refreshMainDialog,
  });

  @override
  State<PreviewDialog> createState() => _PreviewDialogState();
}

class _PreviewDialogState extends State<PreviewDialog> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.8,
        child: Column(
          children: [

            Expanded(
              child: Center(
                child: Text(
                  'Selected Images', 
                  style: Theme.of(context).textTheme.headlineMedium
                ),
              )
            ),


            Expanded(
              flex: 6,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: widget.pickedFiles.length,
                itemBuilder: (context, index) {
                  return Draggable(

                    data:  index,

                    feedback: Opacity(
                      opacity: 0.75, 
                      child: SizedBox.fromSize(
                        size: const Size(100, 100), 
                        child: Image.file(
                          File(widget.pickedFiles[index].path), 
                          fit: BoxFit.cover
                        )
                      ),
                    ),

                    childWhenDragging: SizedBox.fromSize(size: const Size(100, 100)),

                    child: Image.file(
                      File(widget.pickedFiles[index].path),
                      fit: BoxFit.cover,
                    ),


                  );
                },
              ),
            ),

            DragTarget(
              builder:(context, candidateData, rejectedData) {
                final isActive = candidateData.isNotEmpty;
                return SizedBox.fromSize(
                  size: const Size(100, 100),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    size: isActive ? 72 : 50,
                    color: isActive ? Colors.red : Theme.of(context).iconTheme.color
                  )
                );
              },

              onAcceptWithDetails: (details) {
                final index = details.data as int;
                setState(() {
                  widget.pickedFiles.removeAt(index);
                });
              },
            ),

            if (_isUploading) const LinearProgressIndicator(),

            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          setState(() => _isUploading = true);


                          final prefs = await SharedPreferences.getInstance();
                          if (!mounted) return;
                          final currentUserId = prefs.getString('id');

                          final uploadedUrls = await uploadImages(widget.spot['_id'], widget.pickedFiles);
                          if (!mounted) return;

                          setState(() {
                            if (widget.spot['createdBy'] == currentUserId) {
                              widget.spot['ownerImages'] = [
                                ...(widget.spot['ownerImages'] ?? []),
                                ...uploadedUrls
                              ];
                            } else {
                              widget.spot['userImages'] = [
                                ...(widget.spot['userImages'] ?? []),
                                ...uploadedUrls
                              ];
                            }
                            _isUploading = false;
                          });


                          widget.refreshMainDialog();

                          Navigator.of(context).pop();
                        },
                  child: const Text('Upload'),
                ),
              )
            )
            
            

          ],
        ),
      ),
    );
  }
}

// Zum Aufrufen:
void showPreviewDialog(BuildContext context, Map spot, List<XFile> pickedFiles, VoidCallback refreshMainDialog) {
  showDialog(
    context: context,
    builder: (context) {
      return PreviewDialog(
        spot: spot,
        pickedFiles: pickedFiles,
        refreshMainDialog: refreshMainDialog,
      );
    },
  );
}
