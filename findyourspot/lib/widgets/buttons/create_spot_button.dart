import 'package:flutter/material.dart';

class CreateSpotButton extends StatelessWidget {

  const CreateSpotButton ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        heroTag: 'create_spot_button',                    
        backgroundColor: Colors.white,
        elevation: 4.0,
        onPressed: () {
            // TODO: create Spot route
            throw UnimplementedError();
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.blueGrey[400],
          size: 40,                     
        ),
      ),
    );

    
  }

}