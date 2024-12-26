import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String genre;
  final String description;
  final String downloadLink;
  final String publicationDate;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.genre,
    required this.description,
    required this.downloadLink,
    required this.publicationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple, // Couleur de l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Genre', genre),
              const SizedBox(height: 16),
              _buildDetailItem('Description', description),
              const SizedBox(height: 16),
              _buildClickableDetailItem(context, 'Download Link', downloadLink),
              const SizedBox(height: 16),
              _buildDetailItem('Publication Date', publicationDate),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire un item de détail avec un titre et une valeur
  Widget _buildDetailItem(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  // Méthode pour construire un item de détail avec un lien cliquable
  Widget _buildClickableDetailItem(
      BuildContext context, String label, String value) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(value)) {
          await launch(value); // Ouvrir l'URL
        } else {
          // Si le lien ne peut pas être lancé
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lien invalide")),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.deepPurple, width: 1),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
