import 'package:book_publishing_app/book/BookListScreen.dart';
import 'package:book_publishing_app/front/authentification/SignUpScreen.dart'; // Importer la page SignUpScreen
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // For SocketException

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword =
      true; // Variable pour cacher ou afficher le mot de passe

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    const String apiUrl =
        'http://localhost:5000/api/auth/login'; // Use your correct URL if different
    final body = json.encode({
      "email": _emailController.text,
      "mot_de_passe": _passwordController.text,
    });

    setState(() {
      _isLoading = true;
    });

    log('Tentative de connexion : $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      setState(() {
        _isLoading = false;
      });

      log('Réponse reçue : ${response.statusCode}');
      log('Corps de la réponse : ${response.body}');

      if (response.statusCode == 200) {
        // Naviguer vers la page BookListScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListScreen()),
        );
      } else {
        final message =
            json.decode(response.body)['message'] ?? 'Erreur inconnue';
        _showDialog('Erreur', message);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      log('Erreur de connexion : $error');

      String errorMessage =
          'Impossible de se connecter. Vérifiez votre connexion réseau ou contactez l\'administrateur.';

      if (error is http.ClientException) {
        errorMessage =
            'Problème de connexion au serveur, vérifiez votre réseau.';
      } else if (error is SocketException) {
        errorMessage =
            'Problème de connexion réseau, veuillez vérifier votre connexion Internet.';
      }

      _showDialog('Erreur', errorMessage);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor:
            Colors.deepPurple, // Couleur similaire au thème de WelcomeScreen
      ),
      body: Container(
        color: Colors.orange, // Couleur de fond vive
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'LireEnsemble',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Couleur du texte
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black, // Ombre noire
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(), // Encadrement du champ
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText:
                    _obscurePassword, // Utilisation de la variable pour afficher/masquer
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(), // Encadrement du champ
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility, // Icône qui change selon l'état
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword; // Alterner l'état de visibilité
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurple, // Bouton de même couleur
                      ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                            color: Colors.white), // Texte en blanc clair
                      ),
                    ),
              const SizedBox(height: 20),
              // Ajout d'un lien pour s'inscrire
              TextButton(
                onPressed: () {
                  // Rediriger vers la page d'inscription
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "Pas de compte ? S'inscrire ici",
                  style: TextStyle(color: Colors.deepPurple), // Texte du lien
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
