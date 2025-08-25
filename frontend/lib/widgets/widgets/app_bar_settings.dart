import 'package:flutter/material.dart';

class AppBarSettings extends StatelessWidget implements PreferredSizeWidget {
  
  const AppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Settings"),
      centerTitle: true,
    );
  
}

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}