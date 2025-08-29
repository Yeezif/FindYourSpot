// UPLOAD SERVICE

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> uploadImages(String spotId, List<XFile> images) async {
  // Datenbank-URL
  final databaseUrl = dotenv.env['DATABASE_URL'];
  final uri = Uri.parse('$databaseUrl/api/spots/$spotId/images');

  // Auth-Token aus SharedPreferences holen
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  if (token == null) return [];

  // Speicherberechtigung prüfen
  final status = await Permission.storage.request();
  if (!status.isGranted) return [];

  // MultipartRequest erstellen
  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';

  // Bilder hinzufügen
  for (var file in images) {
    request.files.add(await http.MultipartFile.fromPath('images', file.path));
  }

  // Request senden
  final response = await request.send();

  final respStr = await response.stream.bytesToString();

  if (response.statusCode == 200 || response.statusCode == 201) {
    // return urls;
    final data = jsonDecode(respStr);
    final urls = (data['uploadedUrls'] as List<dynamic>).map((e) => e.toString()).toList();
    return urls;
  }
  
  return <String>[];
}
