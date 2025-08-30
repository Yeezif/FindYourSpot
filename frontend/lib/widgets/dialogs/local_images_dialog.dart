import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LocalImagesDialog extends StatefulWidget {
  final List<XFile> images;
  final int startIndex;

  const LocalImagesDialog({
    super.key,
    required this.images,
    required this.startIndex,
  });

  @override
  State<LocalImagesDialog> createState() => _LocalImagesDialogState();
}

class _LocalImagesDialogState extends State<LocalImagesDialog> {
  late int currentIndex;
  late PageController pageController;

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

            // Title & Close Button
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Vorschau", // kein Spot-Titel vorhanden
                      style: Theme.of(context).textTheme.headlineMedium,
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
              ),
            ),

            // Images
            Expanded(
              flex: 6,
              child: PageView.builder(
                itemCount: widget.images.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return Image.file(
                    File(widget.images[index].path),
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void viewLocalImagesDialog(BuildContext context, List<XFile> images, int startIndex) {
  showDialog(
    context: context,
    builder: (context) {
      return LocalImagesDialog(
        images: images,
        startIndex: startIndex,
      );
    },
  );
}
