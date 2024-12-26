import 'package:book_publishing_app/book/BookDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListAuteur extends StatefulWidget {
  const ListAuteur({super.key});

  @override
  State<ListAuteur> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<ListAuteur> {
  // Liste des livres
  List<dynamic> books = [];

  // Méthode pour récupérer la liste des livres depuis l'API
  Future<void> _fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/books'));

    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body);
      });
    } else {
      // Si l'API retourne une erreur
      _showDialog('Erreur', 'Impossible de récupérer les livres.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchBooks(); //récupérer les livres
  }

  int _selectedIndex = 0; //garder la trace de l'index sélectionné

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des livres'),
        backgroundColor: Colors.deepPurple,
      ),
      body: books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.deepPurple, width: 1),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      book['title'] ?? 'Titre inconnu',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      book['genre'] ?? 'Genre inconnu',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Naviguer vers la page des détails du livre
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(
                            title: book['title'] ?? 'Titre inconnu',
                            genre: book['genre'] ?? 'Genre inconnu',
                            description: book['description'] ??
                                'Description indisponible',
                            downloadLink:
                                book['download_link'] ?? 'Lien indisponible',
                            publicationDate:
                                book['publication_date'] ?? 'Date inconnue',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ma liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mes données',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Gestion Livre',
          ),
        ],
      ),
    );
  }
}
