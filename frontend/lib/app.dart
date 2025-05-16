import 'package:findyourspot/layout/app_shell.dart';
import '/pages/pages.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {

  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: isLoggedIn ? const AppShell() : const AuthPage(),
      debugShowCheckedModeBanner: false,
    );

  }
  
}

