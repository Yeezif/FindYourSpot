import 'package:findyourspot/services/logout_service.dart';
import 'package:flutter/material.dart';


class AppBarMain extends StatelessWidget implements PreferredSizeWidget {

  const AppBarMain({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("FindYourSpot"),
      centerTitle: true,
      actions: [

        // Account Button
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () {
              // TODO: Account Page
              logout(context);
            },
            icon: Icon(Icons.account_circle),
            iconSize: 30,
          ),
        ),
      ],

      // Settings Button
      leading: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: IconButton(
          onPressed: () {
            // TODO: Settings Page
          },
          icon: Icon(Icons.settings_rounded),
          iconSize: 30,
        ),
      ),
    );  
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}