const bookModel = require('../models/bookModel');

// Contrôleur pour ajouter un livre
const addBook = (req, res) => {
  const { title, genre, description, downloadLink, publicationDate } = req.body;

  // Vérification des champs requis
  if (!title || !genre || !description || !downloadLink || !publicationDate) {
    return res.status(400).json({ message: 'Tous les champs sont obligatoires' });
  }

  bookModel.addBook(title, genre, description, downloadLink, publicationDate, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Erreur lors de l\'ajout du livre', error: err });
    }
    res.status(201).json({ message: 'Livre ajouté avec succès', bookId: result.insertId });
  });
};

// Contrôleur pour obtenir tous les livres
const getAllBooks = (req, res) => {
  bookModel.getAllBooks((err, books) => {
    if (err) {
      return res.status(500).json({ message: 'Erreur lors de la récupération des livres', error: err });
    }
    res.status(200).json(books);
  });
};

// Contrôleur pour obtenir un livre par son ID
const getBookById = (req, res) => {
  const { id } = req.params;

  bookModel.getBookById(id, (err, book) => {
    if (err) {
      return res.status(500).json({ message: 'Erreur lors de la récupération du livre', error: err });
    }
    if (!book) {
      return res.status(404).json({ message: 'Livre non trouvé' });
    }
    res.status(200).json(book);
  });
};

module.exports = { addBook, getAllBooks, getBookById };
