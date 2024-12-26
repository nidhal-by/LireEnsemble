import 'package:book_publishing_app/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mesdonnees extends StatefulWidget {
  const Mesdonnees({super.key});

  @override
  State<Mesdonnees> createState() => _MesdonneesState();
}

class _MesdonneesState extends State<Mesdonnees> {
  bool _isLoading = true;
  Map<String, String> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Charger les données de l'utilisateur depuis SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userData = {
        'Nom': prefs.getString('nom') ?? 'Non défini',
        'Prénom': prefs.getString('prenom') ?? 'Non défini',
        'Email': prefs.getString('email') ?? 'Non défini',
        'Rôle': prefs.getString('role') ?? 'Non défini',
      };
      _isLoading = false;
    });
  }

  // Fonction pour déconnecter
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Effacer toutes les données de l'utilisateur

    // Rediriger vers la page Welcome
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const WelcomeScreen(), // Rediriger vers la page Welcome
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Données'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app), // Icône de déconnexion
            onPressed: _logout, //fonction de déconnexion
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: _userData.entries
                    .map((entry) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                color: Colors.deepPurple, width: 1),
                          ),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              entry.key,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout, // fonction de déconnexion
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
