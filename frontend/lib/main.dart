
import 'package:findyourspot/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> main() async {

  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken') ?? '';
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final apiService = ApiService(token);

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    apiService: apiService,  
  ));

}
