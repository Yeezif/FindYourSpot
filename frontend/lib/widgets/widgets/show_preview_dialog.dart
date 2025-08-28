// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:findyourspot/services/upload_service.dart';
// // import 'dart:io';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'dart:convert';

// // void showPreviewDialog(BuildContext context, Map spot, List<XFile> pickedFiles) {
// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return Dialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         child: FractionallySizedBox(
// //           widthFactor: 0.9,
// //           heightFactor: 0.7,
// //           child: Column(
// //             children: [
// //               Expanded(
// //                 child: GridView.builder(
// //                   padding: const EdgeInsets.all(8),
// //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 3,
// //                     crossAxisSpacing: 4,
// //                     mainAxisSpacing: 4,
// //                   ),
// //                   itemCount: pickedFiles.length,
// //                   itemBuilder: (context, index) {
// //                     return Image.file(
// //                       File(pickedFiles[index].path),
// //                       fit: BoxFit.cover,
// //                     );
// //                   },
// //                 ),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   // Hier Upload starten

// //                   final uploadedUrls = await uploadImages(spot['_id'], pickedFiles); 
// //                   final prefs = await SharedPreferences.getInstance();
// //                   final currentUserId = prefs.getString('id');

// //                   currentUserId == spot['createdBy']
// //                       ? spot['ownerImages'].addAll(uploadedUrls)
// //                       : spot['userImages'].addAll(uploadedUrls);
                  
// //                   Navigator.of(context).pop();
// //                 },
// //                 child: const Text('Upload'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:findyourspot/services/upload_service.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';

// void showPreviewDialog(BuildContext context, Map spot, List<XFile> pickedFiles, VoidCallback refreshMainDialog) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: FractionallySizedBox(
//           widthFactor: 0.9,
//           heightFactor: 0.7,
//           child: Column(
//             children: [
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(8),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 4,
//                     mainAxisSpacing: 4,
//                   ),
//                   itemCount: pickedFiles.length,
//                   itemBuilder: (context, index) {
//                     return Image.file(
//                       File(pickedFiles[index].path),
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   print('Upload-Button wurde gedrückt');
//                   // User-ID aus SharedPreferences holen
//                   final prefs = await SharedPreferences.getInstance();
//                   final currentUserId = prefs.getString('id');

//                   print('Aktuelle User-ID: $currentUserId');

//                   // Bilder hochladen und URLs bekommen
//                   final uploadedUrls = await uploadImages(spot['_id'], pickedFiles);

//                   print('Die folgenden URLs wurden hochgeladen: $uploadedUrls');

//                   // Spot lokal updaten UND setState aufrufen für UI rerendering
//                   setState(() {
//                     if (spot['createdBy'] == currentUserId) {
//                     spot['ownerImages'] = [...(spot['ownerImages'] ?? []), ...uploadedUrls];
//                   } else {
//                     spot['userImages'] = [...(spot['userImages'] ?? []), ...uploadedUrls];
//                   }
//                   })

//                   print('Spot wurde lokal aktualisiert');

//                   // Main-Dialog neu rendern
//                   refreshMainDialog();
                  

//                   print('Main-Dialog wird neu gerendert');

//                   // Preview-Dialog schließen
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Upload'),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }


import 'package:findyourspot/pages/settings_categories/settings_categories.dart';
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
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  return Image.file(
                    File(widget.pickedFiles[index].path),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            if (isUploading) const LinearProgressIndicator(),

            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: isUploading
                      ? null
                      : () async {
                          setState(() => isUploading = true);


                          final prefs = await SharedPreferences.getInstance();
                          final currentUserId = prefs.getString('id');

                          final uploadedUrls =
                              await uploadImages(widget.spot['_id'], widget.pickedFiles);


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
                            isUploading = false;
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
