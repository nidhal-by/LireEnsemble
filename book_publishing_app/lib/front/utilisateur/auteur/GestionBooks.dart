import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:book_publishing_app/book/AddBookScreen.dart';

class GestionBooks extends StatefulWidget {
  const GestionBooks({super.key});

  @override
  State<GestionBooks> createState() => _ListBooksScreenState();
}

class _ListBooksScreenState extends State<GestionBooks> {
  bool _isLoading = false;
  List<dynamic> _books = [];

  // URL de l'API pour récupérer les livres
  final String apiUrl = 'http://localhost:5000/api/books';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  // Fonction pour récupérer la liste des livres depuis l'API
  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _books = json.decode(response.body);
        });
      } else {
        log('Erreur lors de la récupération des livres: ${response.body}');
      }
    } catch (e) {
      log('Erreur de connexion: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour supprimer un livre
  Future<void> _deleteBook(String bookId) async {
    final String deleteUrl = 'http://localhost:5000/api/books/$bookId';

    try {
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 200) {
        setState(() {
          _books.removeWhere((book) => book['_id'] == bookId);
        });
        _showDialog('Succès', 'Livre supprimé avec succès.');
      } else {
        _showDialog('Erreur', 'Échec de la suppression du livre.');
      }
    } catch (e) {
      _showDialog('Erreur',
          'Impossible de supprimer le livre. Vérifiez votre connexion.');
    }
  }

  // Fonction pour afficher un dialogue
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
        title: const Text('Liste des livres'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(book['title'] ??
                                'Titre inconnu'), // Valeur par défaut si null
                            subtitle: Text(book['author'] ??
                                'Auteur inconnu'), // Valeur par défaut si null
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteBook(book['_id']);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Naviguer vers la page d'ajout de livre
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddBookScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                        child: const Text(
                          'Ajouter un livre',
                          style: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
