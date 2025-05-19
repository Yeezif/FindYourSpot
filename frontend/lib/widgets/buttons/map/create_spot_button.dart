import 'package:findyourspot/widgets/widgets/create_spot_form.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CreateSpotButton extends StatelessWidget {

  final LatLng location;

  const CreateSpotButton ({
    super.key,
    required this.location,
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
          showDialog(
            context: context,
            barrierDismissible: true, // Klick außerhalb schließt den Dialog
            builder: (context) => Center(
              child: SingleChildScrollView(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 350, // Breite des Pop-Ups
                      child: CreateSpotForm(location: location,),
                    ),
                  ),
                ),
              ),
            ),
          );
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

// import 'package:flutter/material.dart';

// class CreateSpotButton extends StatelessWidget {

//   const CreateSpotButton ({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
    
//     return SizedBox(
//       width: 80,
//       height: 80,
//       child: FloatingActionButton(
//         heroTag: 'create_spot_button',                    
//         backgroundColor: Colors.white,
//         elevation: 4.0,
//         onPressed: () {
//             // TODO: create Spot route
//             throw UnimplementedError();
//         },
//         child: Icon(
//           Icons.add_rounded,
//           color: Colors.blueGrey[400],
//           size: 40,                     
//         ),
//       ),
//     );

    
//   }

// }