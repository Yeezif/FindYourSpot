// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// final databaseUrl = dotenv.env['DATABASE_URL'];


// // searchSpots function
// Future<List<dynamic>> searchSpots(String query) async {

//   final response = await http.get(
//     Uri.parse('http://$databaseUrl/api/search?q=$query'),
//   );

//   if (response.statusCode == 200) {

//     final data = jsonDecode(response.body);
//     return data['spots'];

//   } else {
    
//     throw Exception('Spot-Suche fehlgeschlagen');

//   }

// }


// // searchGeo function
// Future<List<dynamic>> searchGeo(String query) async {

//   final response = await http.get(
//     Uri.parse('http://$databaseUrl/api/search/geo?q=$query'),
//   );

//   if (response.statusCode == 200) {
    
//     final data = jsonDecode(response.body);
//     return data;

//   } else {
    
//     throw Exception('Geosuche fehlgeschlagen');

//   }

// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SpotSearchWidget extends StatefulWidget {
  final MapController mapController;

  const SpotSearchWidget({super.key, required this.mapController});

  @override
  _SpotSearchWidgetState createState() => _SpotSearchWidgetState();
}

class _SpotSearchWidgetState extends State<SpotSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _spots = [];
  List<Map<String, dynamic>> _geoResults = []; 

  final databaseUrl = dotenv.env['DATABASE_URL'];

  Future<void> _onSearch(String query) async {
    if (query.length < 2) return;

    final spotRes = await http.get(Uri.parse('$databaseUrl/api/search?q=$query'));
    if (spotRes.statusCode == 200) {
      final data = jsonDecode(spotRes.body);
      final List<Map<String, dynamic>> spots = List<Map<String, dynamic>>.from(data['spots']);
      if (spots.isNotEmpty) {
        setState(() => _spots = spots);
        final first = spots.first;
        widget.mapController.move(LatLng(first['latitude'], first['longitude']), 15.0);
        return;
      }
    }

    // Falls keine Spots, dann Adresse versuchen
    final geoRes = await http.get(Uri.parse('$databaseUrl/api/search/geo?q=$query'));
    if (geoRes.statusCode == 200) {
      final List geo = jsonDecode(geoRes.body);
      if (geo.isNotEmpty) {
        final first = geo.first;
        final lat = double.parse(first['lat']);
        final lon = double.parse(first['lon']);
        widget.mapController.move(LatLng(lat, lon), 15.0);
        setState(() {
          _geoResults = List<Map<String, dynamic>>.from(geo);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      hintText: 'Suchen...',
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        )
      ),
      onChanged: (value) {
        if (value.length > 2) {
          _onSearch(value);
        }
      },
      onSubmitted: (value) {
        if (value.length > 2) {
          _onSearch(value);
        }
      },
      trailing: [
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            _controller.clear();
            setState(() {
              _spots.clear();
              _geoResults.clear();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            _onSearch(_controller.text);
          },
        ),
      ],
    );
    

    // return TextField(
    //   controller: _controller,
    //   decoration: InputDecoration(
    //     hintText: 'Suche nach Spot oder Adresse',
    //     suffixIcon: IconButton(
    //       icon: Icon(Icons.clear),
    //       onPressed: () {
    //         _controller.clear();
    //         setState(() {
    //           _spots.clear();
    //           _geoResults.clear();
    //         });
    //       },
    //     ),
    //   ),
    //   onSubmitted: (value) {
    //     print('submitted: $value');
    //     _onSearch(value);
    //   },
    //   onChanged: (value) {
    //     print('changed: $value');
    //   },
    // );
  }
}









// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';

// class SpotSearchWidget extends StatefulWidget {
//   final MapController mapController;

//   const SpotSearchWidget({Key? key, required this.mapController}) : super(key: key);

//   @override
//   _SpotSearchWidgetState createState() => _SpotSearchWidgetState();
// }

// class _SpotSearchWidgetState extends State<SpotSearchWidget> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> _spots = [];
//   List<Map<String, dynamic>> _geoResults = [];

//   final databaseUrl = dotenv.env['DATABASE_URL'];

//   Future<void> _onSearch(String query) async {
//     if (query.length < 2) return;

//     try {
//       final spotRes = await http.get(Uri.parse('$databaseUrl/api/search?q=$query'));
//       if (spotRes.statusCode == 200) {
//         final data = jsonDecode(spotRes.body);
//         final List<Map<String, dynamic>> spots = List<Map<String, dynamic>>.from(data['spots']);
//         if (spots.isNotEmpty) {
//           setState(() {
//             _spots = spots;
//             _geoResults.clear();
//           });
//           final first = spots.first;
//           widget.mapController.move(LatLng(first['latitude'], first['longitude']), 15.0);
//           return;
//         }
//       }

//       // Fallback: Adresse suchen
//       final geoRes = await http.get(Uri.parse('$databaseUrl/api/search/geo?q=$query'));
//       if (geoRes.statusCode == 200) {
//         final List geo = jsonDecode(geoRes.body);
//         if (geo.isNotEmpty) {
//           final first = geo.first;
//           final lat = double.parse(first['lat']);
//           final lon = double.parse(first['lon']);
//           widget.mapController.move(LatLng(lat, lon), 15.0);
//           setState(() {
//             _geoResults = List<Map<String, dynamic>>.from(geo);
//             _spots.clear();
//           });
//         }
//       }
//     } catch (e) {
//       print('Fehler bei der Suche: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 400,
//       child: Column(
//         children: [
//           SearchBar(
//             controller: _controller,
//             hintText: 'Spot oder Adresse suchen...',
//             shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             onChanged: (value) {
//               if (value.length > 2) {
//                 _onSearch(value);
//               }
//             },
//             onSubmitted: (value) {
//               if (value.length > 2) {
//                 _onSearch(value);
//               }
//             },
//             trailing: [
//               IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () {
//                   _controller.clear();
//                   setState(() {
//                     _spots.clear();
//                     _geoResults.clear();
//                   });
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: _spots.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: _spots.length,
//                     itemBuilder: (context, index) {
//                       final spot = _spots[index];
//                       return ListTile(
//                         title: Text(spot['name'] ?? 'Ohne Namen'),
//                         subtitle: Text('${spot['latitude']}, ${spot['longitude']}'),
//                       );
//                     },
//                   )
//                 : _geoResults.isNotEmpty
//                     ? ListView.builder(
//                         itemCount: _geoResults.length,
//                         itemBuilder: (context, index) {
//                           final geo = _geoResults[index];
//                           return ListTile(
//                             title: Text(geo['display_name']),
//                             subtitle: Text('${geo['lat']}, ${geo['lon']}'),
//                           );
//                         },
//                       )
//                     : const Center(child: Text('Keine Ergebnisse')),
//           ),
//         ],
//       ),
//     );
//   }
// }
