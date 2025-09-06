import 'package:flutter/material.dart';

class AppBarCollections extends StatelessWidget implements PreferredSizeWidget {
  
  const AppBarCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Collections"),
      centerTitle: true,
      // Filter Button topleft
      leading: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: IconButton(
          onPressed: () {
            // TODO: Filter
          },
          icon: Icon(Icons.filter_alt_outlined),
          iconSize: 30,
        ),
      ),
      
      actions: [

        // Favorites Button topright
        Padding(
          padding: EdgeInsets.only(right: 0),
          child: IconButton(
            onPressed: () {
              // TODO: Favorites
            },
            icon: Icon(Icons.favorite_outline_rounded),
            iconSize: 30,
          ),
        ),

        // Search Button topright
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () {
              // TODO: Search
            },
            icon: Icon(Icons.search_rounded),
            iconSize: 30,
          ),
        ),

      ],
    );
  
}

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}