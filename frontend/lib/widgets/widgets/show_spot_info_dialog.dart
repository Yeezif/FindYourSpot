// // import 'package:flutter/material.dart';

// // enum ImageCategory { owner, user }

// // void showSpotInfoDialog(BuildContext context, Map spot) {

// //   // showDialog(
    
// //   //   context: context,
// //   //   builder: (context) => Dialog(
// //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //   //     child: Padding(

// //   //       padding: const EdgeInsets.all(20),
// //   //       child: Column(

// //   //         mainAxisSize: MainAxisSize.min,

// //   //         children: [

// //   //           Text(
// //   //             spot['title'] ?? 'Kein Titel',
// //   //             style: Theme.of(context).textTheme.headlineSmall,
// //   //           ),

// //   //           SizedBox(height: 10),

// //   //           Text(spot['description'] ?? 'Keine Beschreibung'),

// //   //           SizedBox(height: 10),

// //   //           Row(
// //   //             children: [
// //   //               Icon(Icons.location_on),
// //   //               SizedBox(width: 5),
// //   //               Text('${spot['location']['coordinates'][1]}, ${spot['location']['coordinates'][0]}'),
// //   //             ],
// //   //           ),

// //   //           SizedBox(height: 20),

// //   //           ElevatedButton(
// //   //             onPressed: () => Navigator.of(context).pop(),
// //   //             child: Text('Schließen'),
// //   //           ),
            
// //   //         ],
// //   //       ),
// //   //     ),
// //   //   ),
// //   // );


// //   showDialog(
// //     context: context,
// //     builder: (context) {

// //       ImageCategory selectedCategory = ImageCategory.owner;

// //       return StatefulBuilder(
// //         builder: (context, setState) {

// //           // sources
// //           final ownerImages = List<String>.from(spot['ownerImages'] ?? []);
// //           final userImages = List<String>.from(spot['userImages'] ?? []);



// //           Widget buildImages() {

// //             final images = selectedCategory == ImageCategory.owner
// //                 ? ownerImages
// //                 : userImages;

// //             if (images.isEmpty) {
// //               return const Text('Keine Bilder vorhanden');
// //             }
          
// //             return GridView.builder(
// //               shrinkWrap: true,
// //               physics: NeverScrollableScrollPhysics(),
// //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 crossAxisSpacing: 4,
// //                 mainAxisSpacing: 4,
// //               ),
// //               itemCount: images.length,
// //               itemBuilder: (context, index) {
// //                 return Image.network(
// //                   images[index],
// //                   fit: BoxFit.cover,
// //                   loadingBuilder: (context, child, progress) {
// //                     if (progress == null) return child;
// //                     return Center(child: CircularProgressIndicator());
// //                   },
// //                   errorBuilder: (context, error, stackTrace) {
// //                     return Icon(Icons.broken_image_outlined);
// //                   },
// //                 );
// //               },
// //             );

// //           }

// //           return Dialog(
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(

// //                 mainAxisSize: MainAxisSize.min,

// //                 children: [

// //                   Text(
// //                     spot['title'] ?? 'title unknown',
// //                     style: Theme.of(context).textTheme.headlineMedium,
// //                   ),

// //                   SizedBox(height: 10),

// //                   Text(spot['description'] ?? 'Keine Beschreibung'),

// //                   SizedBox(height: 10),

// //                   Row(
// //                     children: [

// //                       Icon(Icons.location_on),

// //                       SizedBox(width: 5),

// //                       Column(
// //                         children: [
// //                           Text('Breitengrad, Längengrad'),
// //                           Text('${spot['location']['coordinates'][1]}, ${spot['location']['coordinates'][0]}')
// //                         ],
// //                       )

// //                     ],
// //                   ),

// //                   SizedBox(height: 20),

// //                   SegmentedButton<ImageCategory>(

// //                     segments: const <ButtonSegment<ImageCategory>>[

// //                       ButtonSegment(
// //                         value: ImageCategory.owner,
// //                         label: Text('Fotos'),
// //                       ),

// //                       ButtonSegment(
// //                         value: ImageCategory.user,
// //                         label: Text('von anderen'),
// //                       ),

// //                     ],

// //                     selected: {selectedCategory},
// //                     onSelectionChanged: (Set<ImageCategory> newSelection) {
// //                       setState(() {
// //                         selectedCategory = newSelection.first;
// //                       });
// //                     },
// //                   ),

// //                   SizedBox(height: 10),

// //                   buildImages(),

// //                   SizedBox(height: 10),

// //                   Align(
// //                     alignment: Alignment.centerRight,
// //                     child: TextButton(
// //                       onPressed: () => Navigator.of(context).pop(),
// //                       child: Text('Schließen'),
// //                     ),
// //                   )

// //                 ],

// //               ),
// //             )
// //           );
// //         }
// //       );
// //     },
// //   );
// // }

// import 'package:flutter/material.dart';

// enum ImageCategory { owner, user }

// void showSpotInfoDialog(BuildContext context, Map spot) {
//   showDialog(
//     context: context,
//     builder: (context) => SpotInfoDialog(spot: spot),
//   );
// }

// class SpotInfoDialog extends StatefulWidget {
//   final Map spot;

//   const SpotInfoDialog({super.key, required this.spot});

//   @override
//   State<SpotInfoDialog> createState() => _SpotInfoDialogState();
// }

// class _SpotInfoDialogState extends State<SpotInfoDialog> {
//   ImageCategory selectedCategory = ImageCategory.owner;

//   @override
//   Widget build(BuildContext context) {
//     final ownerImages = List<String>.from(widget.spot['ownerImages'] ?? []);
//     final userImages = List<String>.from(widget.spot['userImages'] ?? []);
//     final images = selectedCategory == ImageCategory.owner ? ownerImages : userImages;

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               Text(
//                 widget.spot['title'] ?? 'Kein Titel',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),

//               const SizedBox(height: 10),

//               Text(widget.spot['description'] ?? 'Keine Beschreibung'),

//               const SizedBox(height: 10),

//               Row(
//                 children: [
//                   const Icon(Icons.location_on),
//                   const SizedBox(width: 5),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Breitengrad, Längengrad'),
//                       Text('${widget.spot['location']['coordinates'][1]}, ${widget.spot['location']['coordinates'][0]}'),
//                     ],
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: SegmentedButton<ImageCategory>(
//                   style: ButtonStyle(
//                     visualDensity: VisualDensity.compact,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12)),
//                     backgroundColor: WidgetStateProperty.resolveWith((states) {
//                       if (states.contains(WidgetState.selected)) {
//                         return Colors.grey.shade300;
//                       }
//                       return Colors.grey.shade100;
//                     }),
//                     shape: WidgetStateProperty.all(RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero,
//                     )),
//                   ),
//                   segments: const <ButtonSegment<ImageCategory>>[
//                     ButtonSegment(
//                       value: ImageCategory.owner,
//                       label: Center(child: Text('Fotos')),
//                       icon: SizedBox.shrink(), 
//                     ),
//                     ButtonSegment(
//                       value: ImageCategory.user,
//                       label: Center(child: Text('von anderen')),
//                       icon: SizedBox.shrink(), 
//                     ),
//                   ],
//                   selected: {selectedCategory},
//                   onSelectionChanged: (Set<ImageCategory> newSelection) {
//                     setState(() {
//                       selectedCategory = newSelection.first;
//                     });
//                   },
//                 ),
//               ),

//               const SizedBox(height: 10),

//               if (images.isEmpty)
//                 const Text('Keine Bilder vorhanden')
//               else
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 4,
//                     mainAxisSpacing: 4,
//                   ),
//                   itemCount: images.length,
//                   itemBuilder: (context, index) {
//                     return Image.network(
//                       images[index],
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;
//                         return const Center(child: CircularProgressIndicator());
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(Icons.broken_image_outlined);
//                       },
//                     );
//                   },
//                 ),

//               const SizedBox(height: 10),

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Schließen'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

enum ImageCategory { owner, user }
ImageCategory selectedCategory = ImageCategory.owner;

void showSpotInfoDialog(BuildContext context, Map spot) {
  showDialog(
    context: context,

    
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Quellen
          final ownerImages = List<String>.from(spot['ownerImages'] ?? []);
          final userImages = List<String>.from(spot['userImages'] ?? []);




          Widget buildImages() {
            final images = selectedCategory == ImageCategory.owner
                ? ownerImages
                : userImages;

            if (images.isEmpty) {
              return const Text('Keine Bilder vorhanden');
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image_outlined);
                  },
                );
              },
            );
          }



          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.8,
              child: Stack(
                children: [


                  // Dialog Content
                  Padding(

                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Text(
                            spot['title'] ?? 'title unknown',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),

                          const SizedBox(height: 10),

                          Text(spot['description'] ?? 'Keine Beschreibung'),

                          const SizedBox(height: 10),

                          Row(
                            children: [

                              const Icon(Icons.location_on),

                              const SizedBox(width: 5),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Breitengrad, Längengrad'),
                                  Text('${spot['location']['coordinates'][1]}, ${spot['location']['coordinates'][0]}'),
                                ],
                              ),

                            ],
                          ),

                          const SizedBox(height: 20),

                          // ChoiceChip-Segmented Alternative
                          Row(

                            children: [

                              Expanded(
                                child: ChoiceChip(
                                  label: const Center(child: Text('Fotos')),
                                  selected: selectedCategory == ImageCategory.owner,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCategory = ImageCategory.owner;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey[300],
                                  labelStyle: TextStyle(
                                    color: selectedCategory == ImageCategory.owner ? Colors.white : Colors.black,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: ChoiceChip(
                                  label: const Center(child: Text('von anderen')),
                                  selected: selectedCategory == ImageCategory.user,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCategory = ImageCategory.user;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey[300],
                                  labelStyle: TextStyle(
                                    color: selectedCategory == ImageCategory.user ? Colors.white : Colors.black,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              
                            ],
                          ),

                          const SizedBox(height: 10),

                          buildImages(),
                        
                        ],
                      ),
                    ),
                  ),


                  // Close Button topleft
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'close',
                    ),
                  ),


                  // Share Button topright
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.share_rounded),
                      onPressed: () {
                        // TODO: Share Button
                      }, 
                      tooltip: 'share'
                    ),
                  )

                ],
              )              
            ),
          );
        },
      );
    },
  );
}
