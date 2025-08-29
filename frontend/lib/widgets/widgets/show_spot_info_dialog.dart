import 'package:findyourspot/widgets/widgets/show_preview_dialog.dart';
import 'package:findyourspot/widgets/widgets/view_images_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';


enum ImageCategory { owner, user }
ImageCategory selectedCategory = ImageCategory.owner;




void showSpotInfoDialog(BuildContext context, Map spot) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          
          Widget buildImages() {
            final images = selectedCategory == ImageCategory.owner
              ? ((spot['ownerImages'] ?? []) as List<dynamic>).map((e) => e.toString()).toList()
              : ((spot['userImages'] ?? []) as List<dynamic>).map((e) => e.toString()).toList();

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: images.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final images = await picker.pickMultiImage();
                      if (images.isNotEmpty) {

                        showPreviewDialog(context, spot, images, () {
                          // refresh main dialog state
                          setState(() {});
                        });
                      }
                    },
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
                    ),
                  );
                }

                final imageIndex = index - 1;

                return GestureDetector(
                  onTap:() {
                    
                    viewImagesDialog(context, spot, images, index - 1);
                  
                  },

                  child: Image.network(
                    images[imageIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image_outlined);
                    },
                  ),
                );
              },
            );
          }



          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: ChoiceChip(
                                    label: const Center(child: Text('Fotos')),
                                    selected: selectedCategory == ImageCategory.owner,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedCategory = ImageCategory.owner;
                                      });
                                    },
                                    // selectedColor: Theme.of(context).colorScheme.primary,
                                    // backgroundColor: Theme.of(context).colorScheme.surface,
                                    // labelStyle: TextStyle(
                                    //   color: selectedCategory == ImageCategory.owner 
                                    //       ? Theme.of(context).colorScheme.onPrimary
                                    //       : Theme.of(context).colorScheme.onSurface,
                                    // ),

                                    // TODO: fix ripple effect

                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
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
                                  // selectedColor: Theme.of(context).colorScheme.primary,
                                  // backgroundColor: Theme.of(context).colorScheme.surface,
                                  // labelStyle: TextStyle(
                                  //   color: selectedCategory == ImageCategory.user 
                                  //       ? Theme.of(context).colorScheme.onPrimary
                                  //       : Theme.of(context).colorScheme.onSurface,
                                  // ),

                                  // TODO: fix ripple effect

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
