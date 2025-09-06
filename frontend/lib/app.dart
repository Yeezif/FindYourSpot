import 'package:findyourspot/layout/app_shell.dart';
import 'package:findyourspot/theme/theme.dart';
import '/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:findyourspot/services/api_service.dart';

class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  final ApiService apiService;


  MyApp({
    super.key,
    required this.isLoggedIn,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: isLoggedIn 
          ? AppShell(apiService: apiService): const AuthPage(),
      debugShowCheckedModeBanner: false,

      theme: lightTheme, // ThemeData.light(),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );

  }
  
}

