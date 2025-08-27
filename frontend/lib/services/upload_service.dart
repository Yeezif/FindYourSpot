import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> uploadImage(String spotId) async {

  // vars
  final databaseUrl = dotenv.env['DATABASE_URL'];
  final uri = Uri.parse('$databaseUrl/api/spots/$spotId/image');

  // get token
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');

  // pick image
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {

    final request = http.MultipartRequest('POST', uri);

    // add image
    request.files.add(await http.MultipartFile.fromPath('images', pickedFile.path));
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Bild erfolgreich hochgeladen');
    } else {
      print('Fehler beim Hochladen des Bildes: ${response.reasonPhrase} (${response.statusCode})');
    }
  }
}