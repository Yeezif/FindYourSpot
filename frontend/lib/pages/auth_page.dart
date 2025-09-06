import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/layout/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:findyourspot/services/api_service.dart';

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


  /// Parses a JSON Web Token (JWT) and returns the decoded payload as a string.
  ///
  /// The payload is expected to be in the format of a JSON object, and is
  /// decoded from the JWT using the base64Url normalize and decode functions.
  ///
  /// Throws an [Exception] if the token is not in the correct format.
  String parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return decoded;
  }

  /// Submits the form, depending on whether isLogin is true or false.
  /// If [isLogin] is true, it sends a POST request to the login endpoint.
  /// If [isLogin] is false, it sends a POST request to the register endpoint.
  /// 
  /// If the request is successful, it saves the token and id to the SharedPreferences.
  /// If the request is not successful, it sets the error state.
  /// 
  /// If the request is successful and [isLogin] is false, it navigates to the AppShell.
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

      if (!isLogin) {
        setState(() {
          error = 'Registration successfull, please verify your email';
          isLoading = false;
        });
        return;
      }

      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      if (data['token'] != null) {
        await prefs.setString('authToken', data['token']);  // save token

        final decoded = parseJwt(data['token']);
        final decodedMap = jsonDecode(decoded);
        final userId = decodedMap['id']?.toString() ?? '';
        await prefs.setString('id', userId);

        print('User ID: $userId');

      }
      
      setState(() => isLoading = false);

      if (!mounted) return;

      final token = prefs.getString('authToken') ?? '';
      final apiService = ApiService(token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AppShell(apiService: apiService)),
      );

    } catch (e) {
      setState(() {
        error = 'Verbindungsfehler: $e';
        isLoading = false;
      });
    }
  }

  @override
  /// Builds the login or registration form, depending on the value of [isLogin].
  ///
  /// If [isLogin] is true, it builds a login form with fields for email and password.
  /// If [isLogin] is false, it builds a registration form with additional fields for username.
  ///
  /// It also includes a button to switch between login and registration forms.
  ///
  /// If [isLoading] is true, it displays a [CircularProgressIndicator].
  ///
  /// If [error] is not empty, it displays the error message below the form fields.
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
