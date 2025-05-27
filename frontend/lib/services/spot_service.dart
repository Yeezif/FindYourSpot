import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:findyourspot/widgets/widgets/show_spot_info_dialog.dart';

class SpotService {
  static Marker buildMarkerFromSpot({
    required BuildContext context,
    required Map spot,
    required Widget Function(Map) detailBuilder,
  }) {
    final coords = spot['location']['coordinates'];
    final lat = coords[1];
    final lng = coords[0];

    return Marker(
      point: LatLng(lat, lng),
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          
          showSpotInfoDialog(context, spot);

        },
        child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
      ),
    );
  }

  static Future<List<Marker>> fetchSpotMarkers(
      BuildContext context, Widget Function(Map) detailBuilder) async {
    final databaseUrl = dotenv.env['DATABASE_URL'];
    final uri = Uri.parse('$databaseUrl/api/spots');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data
          .map<Marker>((spot) =>
              buildMarkerFromSpot(context: context, spot: spot, detailBuilder: detailBuilder))
          .toList();
    } else {
      throw Exception('Fehler beim Laden der Spots');
    }
  }
}
