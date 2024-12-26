import 'package:book_publishing_app/book/BookDetailScreen.dart';
import 'package:book_publishing_app/front/utilisateur/Mesdonnees.dart';
import 'package:book_publishing_app/front/utilisateur/auteur/GestionBooks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
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
      // Si l'API retourne une erreur, afficher un message
      _showDialog('Erreur', 'Impossible de récupérer les livres.');
    }
  }

  // Méthode pour afficher une boîte de dialogue
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
    _fetchBooks(); // Appeler la méthode pour récupérer les livres
  }

  int _selectedIndex = 0; // Pour garder la trace de l'index sélectionné

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Rediriger vers la page "GestionBooks" lorsqu'on clique sur "Ma liste"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GestionBooks()),
      );
    } else if (index == 1) {
      // Rediriger vers la page "Mes Données" lorsqu'on clique sur l'élément correspondant
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Mesdonnees()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des livres'),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false, // Supprime le bouton de retour
      ),
      body: books.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(), // Afficher un indicateur de chargement
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
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
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ma liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mes données',
          ),
        ],
      ),
    );
  }
}
