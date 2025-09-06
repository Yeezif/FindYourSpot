import 'package:flutter/material.dart';
import 'package:findyourspot/models/collection.dart';

class AppBarCollectionDetail extends StatelessWidget implements PreferredSizeWidget {
  final Collection collection;
  

  const AppBarCollectionDetail({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(collection.title),
      centerTitle: true,

      // Filter Button topleft
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
      ),

      actions: [
        
        // Share Button topright
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: const Icon(Icons.share_rounded),
            iconSize: 30,
            onPressed: () {
              // TODO: Share Collection Button
            },
          ),
        )

      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}