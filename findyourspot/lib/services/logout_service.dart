import 'package:findyourspot/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(BuildContext context) async {

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await prefs.setBool('isLoggedIn', false);

  Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (_) => const AuthPage()),
  );

}