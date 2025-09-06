import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {


  final String baseUrl = dotenv.env['API_BASE_URL']!;

  final String token;

  ApiService(this.token);

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };


  



  // CREATE COLLECTION

  // POST /api/collections
  Future<Collection> createCollection(Collection collection) async {

    final response = await http.post(
      Uri.parse('$baseUrl/collections'),
      headers: headers,
      body: jsonEncode({
        'title': collection.title,
        'description': collection.description,
      }),
    );

    if (response.statusCode == 201) {

      final decoded = json.decode(response.body);
      final data = decoded is String ? json.decode(decoded) : decoded;
      return Collection.fromJson(data);

    } else {

      throw Exception('Failed to create collection');

    }
  
  }



  // GET ALL COLLECTIONS OF USER BY ID

  // GET /api/users/:userId/collections
  Future<List<Collection>> getUserCollections(String userId) async {
    
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/collections'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {

      final List data = json.decode(response.body);
      return data.map((collection) => Collection.fromJson(collection)).toList();

    } else {

      throw Exception('Failed to load collections');

    }

  }



  // GET COLLECTION BY ID

  // GET /api/collections/:collectionId
  Future<Collection> getCollectionById(String collectionId) async {
    
    final response = await http.get(
      Uri.parse('$baseUrl/collections/$collectionId'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      return Collection.fromJson(data);

    } else {

      throw Exception('Failed to load collections');

    }

  }



  // GET ALL COLLECTIONS OF LOGGIN IN USER

  // GET /api/collections
  Future<List<Collection>> getLoggedInUserCollections() async {
    
    // TODO: check ob das ganze funktioniert
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');

    // final response = await http.get(
    //   Uri.parse('$baseUrl/users/$userId/collections'),
    //   headers: headers,
    // );

    final response = await http.get(
      Uri.parse('$baseUrl/collections'), // Endpoint für eigene Collections
      headers: headers,
    );
    
    if (response.statusCode == 200) {

      final List data = json.decode(response.body);
      return data.map((collection) => Collection.fromJson(collection)).toList();

    } else {

      throw Exception('Failed to load collections');

    }

  }



  // ADD SPOT TO COLLECTION

  // PUT /api/collections/:collectionId
  Future<Collection> addSpotToCollection(String collectionId, String spotId) async {

    final response = await http.put(
      Uri.parse('$baseUrl/collections/$collectionId'),
      headers: headers,
      body: jsonEncode({'spotId': spotId}),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      return Collection.fromJson(data);

    } else {

      throw Exception('Failed to add spot to collection ${response.body}');

    }
    
  }



  // DELETE COLLECTION

  // DELETE /api/collections/:collectionId
  Future<void> deleteCollection(String collectionId) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/collections/$collectionId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete collection: ${response.body}');
    }

  }



  // DELETE SPOT FROM COLLECTION

  // DELETE /api/collections/:collectionId/spots/:spotId
  Future<void> deleteSpotFromCollection(String collectionId, String spotId) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/collections/$collectionId/spots/$spotId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete spot from collection: ${response.body}');
    }

  }

}