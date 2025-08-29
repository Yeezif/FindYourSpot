import 'package:flutter/material.dart';

class ImagesDialog extends StatefulWidget {
  final Map spot;
  final List<String> images;
  final int startIndex;
  
  const ImagesDialog({
    super.key,
    required this.spot,
    required this.images,
    required this.startIndex,
  });

  @override
  State<ImagesDialog> createState() => _ImagesDialogState();
}

class _ImagesDialogState extends State<ImagesDialog> {
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
    pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.8,
        child: Column(
          children: [

            // Spot-Title
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.spot['title'],
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              )
            ),

            // Images
            Expanded(
              flex: 6,
              child: PageView.builder(
                itemCount: widget.images.length,
                controller: pageController,
                
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  );
                },

                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },

              ),
            ),

            // Indicator
            Expanded(
              child: Center(
                child: Text(
                  '${currentIndex + 1} / ${widget.images.length}',
                  style: Theme.of(context).textTheme.headlineSmall
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}



void viewImagesDialog(BuildContext context, Map spot, List<String> images, int startIndex) {
  showDialog(
    context: context,
    builder: (context) {
      return ImagesDialog(
        spot: spot,
        images: images,
        startIndex: startIndex,
      );
    },
  );
}