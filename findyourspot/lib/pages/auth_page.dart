import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/layout/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  Future<void> submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() => isLoading = true);

    final databaseUrl = dotenv.env['DATABASE_URL'];
    final url = isLogin
        ? Uri.parse('$databaseUrl/api/users/login')
        : Uri.parse('$databaseUrl/api/users/register');

    final body = isLogin
        ? {'email': email, 'password': password}
        : {'username': username, 'email': email, 'password': password};

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode != 200 && res.statusCode != 201) {
        setState(() { 
          error = data['message'] ?? data['error'] ?? 'Fehler';
          isLoading = false;
        });
        return;
      }

      

      // TODO: Erfolg: Token oder User-Daten nutzen
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('authToken', data['token']);  // save token
      
      setState(() => isLoading = false);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppShell()),
      );

      // TODO: Weiterleiten oder speichern

    } catch (e) {
      setState(() {
        error = 'Verbindungsfehler: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Registrieren'), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading ? const Center(child: CircularProgressIndicator()) : Form(
          key: _formKey,
          child: Column(
            children: [
              if (!isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Benutzername'),
                  onSaved: (val) => username = val ?? '',
                  validator: (val) =>
                      val == null || val.length < 3 ? 'Min. 3 Zeichen' : null,
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val ?? '',
                validator: (val) =>
                    val != null && val.contains('@') ? null : 'Gültige E-Mail',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                onSaved: (val) => password = val ?? '',
                validator: (val) =>
                    val != null && val.length >= 6 ? null : 'Min. 6 Zeichen',
              ),
              const SizedBox(height: 12),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: submit,
                child: Text(isLogin ? 'Login' : 'Registrieren'),
              ),
              TextButton(
                onPressed: () =>
                    setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? 'Noch keinen Account? Registrieren'
                    : 'Schon registriert? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
