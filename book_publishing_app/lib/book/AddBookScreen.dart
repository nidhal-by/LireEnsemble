import 'package:book_publishing_app/book/BookListScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _downloadLinkController = TextEditingController();
  final TextEditingController _publicationDateController =
      TextEditingController();

  String? _selectedGenre;

  final List<String> genres = [
    'Fiction',
    'Non-Fiction',
    'Fantasy',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Biography',
    'History',
    'Self-Help',
    'Thriller'
  ];

  // Méthode pour ajouter un livre via l'API
  Future<void> _addBook() async {
    if (_titleController.text.isEmpty ||
        _selectedGenre == null ||
        _descriptionController.text.isEmpty ||
        _downloadLinkController.text.isEmpty ||
        _publicationDateController.text.isEmpty) {
      _showDialog('Erreur', 'Tous les champs doivent être remplis.');
      return;
    }

    // Validation de l'URL du lien de téléchargement
    if (!_isValidUrl(_downloadLinkController.text)) {
      _showDialog('Erreur', 'Le lien de téléchargement est invalide.');
      return;
    }

    final Map<String, String> bookData = {
      'title': _titleController.text,
      'genre': _selectedGenre!,
      'description': _descriptionController.text,
      'downloadLink': _downloadLinkController.text,
      'publicationDate': _publicationDateController.text,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bookData),
    );

    if (response.statusCode == 201) {
      _showDialog('Succès', 'Le livre a été ajouté avec succès.');
      // Rediriger vers la page BookListScreen après l'ajout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookListScreen()),
      );
    } else {
      _showDialog(
          'Erreur', 'Une erreur est survenue lors de l\'ajout du livre.');
    }
  }

  // Méthode pour valider l'URL
  bool _isValidUrl(String url) {
    final RegExp urlPattern = RegExp(
        r'^(https?|ftp)://[^\s/$.?#].[^\s]*$'); // Expression régulière simple
    return urlPattern.hasMatch(url);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Titre du livre',
                icon: Icons.title,
              ),
              const SizedBox(height: 16),
              _buildGenreDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _downloadLinkController,
                label: 'Lien de téléchargement',
                icon: Icons.link,
              ),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ajouter le livre',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire le champ de sélection du genre
  Widget _buildGenreDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGenre,
      onChanged: (String? newValue) {
        setState(() {
          _selectedGenre = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Genre',
        prefixIcon: const Icon(Icons.category, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
        ),
      ),
      items: genres.map<DropdownMenuItem<String>>((String genre) {
        return DropdownMenuItem<String>(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
    );
  }

  // Méthode pour construire le champ de date
  Widget _buildDateField() {
    return TextField(
      controller: _publicationDateController,
      decoration: InputDecoration(
        labelText: 'Date de publication',
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            _publicationDateController.text =
                "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }

  // Méthode pour construire les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
        ),
      ),
    );
  }
}
