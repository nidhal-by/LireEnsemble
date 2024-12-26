const bookModel = require('../models/bookModel');
// bookController.js
const mysql = require('mysql2');

// Créez la connexion à la base de données
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'bookpublishing',
});

// Fonction pour supprimer un livre par ID
exports.deleteBook = (req, res) => {
  const { bookId } = req.params;  // Récupérer l'ID du livre de l'URL

  const query = 'DELETE FROM books WHERE id = ?';

  connection.query(query, [bookId], (err, result) => {
    if (err) {
      console.error('Erreur lors de la suppression du livre: ', err);
      return res.status(500).json({ message: 'Erreur lors de la suppression du livre', error: err });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Livre non trouvé' });
    }

    res.status(200).json({ message: 'Livre supprimé avec succès' });
  });
};
